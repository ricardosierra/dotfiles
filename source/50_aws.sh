
# =============================================================================
# AWS — funções pra gerenciar ECS e CloudWatch Logs
# =============================================================================

# aws-account: mostra o nome da conta AWS atual (alias configurado no IAM)
function aws-account() {
  aws iam list-account-aliases | jq ".AccountAliases[0]" -r
}

# aws-list-clusters: lista todos os clusters ECS da role atual
function aws-list-clusters() {
  aws ecs list-clusters | jq -r '.clusterArns|map((./"/")[1])|.[]'
}

# aws-list-services: lista todos os serviços de um cluster
# uso: aws-list-services <nome-do-cluster>
function aws-list-services() {
  aws ecs list-services --cluster $1 | jq -r '.serviceArns|map((./"/")[1])|.[]'
}

# aws-list-services-by-cluster: lista todos os serviços agrupados por cluster
# útil pra ter uma visão geral do que está rodando
function aws-list-services-by-cluster() {
  local clusters services
  clusters=($(aws-list-clusters))
  for c in "${clusters[@]}"; do
    services=($(aws-list-services $c))
    for s in "${services[@]}"; do
      echo "$c $s"
    done
    [[ ${#services[@]} -gt 0 ]] && echo
  done
}

# aws-list-tasks: lista as tasks rodando num serviço específico
# uso: aws-list-tasks <cluster> <servico>
function aws-list-tasks() {
  aws ecs list-tasks --cluster $1 --service-name $2 \
    | jq -r '.taskArns|map((./"/")[1])|.[]'
}

# aws-list-task-definitions: mostra as definições de task das tasks rodando
# uso: aws-list-task-definitions <cluster> <servico>
function aws-list-task-definitions() {
  local t=$(aws ecs describe-tasks --cluster $1 --tasks $(aws-list-tasks $1 $2))
  echo $t | jq -r '.tasks|map((.taskDefinitionArn/"/")[1])|.[]'
}

# aws-task-definition: retorna a definição de task atual
# uso: aws-task-definition <cluster> <servico> [filtro-jq]
# ou: aws-task-definition <td-name:revision> [filtro-jq]
function aws-task-definition() {
  local tds
  if [[ "$1" =~ : ]]; then
    tds=($1)
  else
    tds=($(aws-list-task-definitions $1 $2 | uniq))
    shift
  fi
  shift
  for td in "${tds[@]}"; do
    aws ecs describe-task-definition --task-definition $td | jq "$@"
  done
}

# aws-task-definition-env-history: mostra o histórico de mudanças nas variáveis
# de ambiente de uma task definition ao longo das revisões
# uso: aws-task-definition-env-history <td-name> [rev-inicial] [rev-final]
function aws-task-definition-env-history() {
  local cur=$2 max=$3 next diff a b
  [[ ! "$cur" ]] && cur=0
  [[ ! "$max" ]] && max=9999
  if [[ $(($cur+1-1)) != "$cur" || $(($max+1-1)) != "$max" ]]; then
    echo "Usage: aws-task-definition-env-history td-name [start-rev] [end-rev]"
    return 1
  fi
  while [[ $cur != $max ]]; do
    next=$((cur+1))
    b=$(aws-task-definition-env $1:$next 2>/dev/null | sort)
    if [[ ! "$b" ]]; then
      echo "No more revisions."
      return
    fi
    a=
    if [[ $cur != 0 ]]; then
      echo -ne "\rComparing revisions $cur and $next..." 1>&2
      a=$(aws-task-definition-env $1:$cur 2>/dev/null | sort)
    fi
    diff=$(diff <(echo "$a") <(echo "$b"))
    if [[ "$diff" ]]; then
      echo -ne '\r' 1>&2
      if [[ $cur == 0 ]]; then
        echo "Initial values"
      else
        echo "Differences between revisions $cur and $next"
      fi
      echo "-------------------------------------------"
      echo "$diff"
      echo "==========================================="
    fi
    cur=$((cur+1))
  done
}

# aws-task-definition-env: mostra as variáveis de ambiente no formato VAR=VALOR
# uso: aws-task-definition-env <cluster> <servico>
function aws-task-definition-env() {
  aws-task-definition "$@" \
    -r '.taskDefinition.containerDefinitions[0].environment|map(.name+"="+.value)|.[]'
}

# aws-stop-tasks: para todas as tasks de um ou mais serviços num cluster
# uso: aws-stop-tasks <cluster> <servico1> [servico2 ...]
function aws-stop-tasks() {
  local tasks count cluster pad s t
  cluster=$1; shift
  for s in "$@"; do
    [[ "$pad" ]] && echo; pad=1
    echo "Finding tasks for service <$s> on cluster <$cluster>"
    tasks=($(aws-list-tasks $cluster $s))
    count=${#tasks[@]}
    if [[ $count == 0 ]]; then
      echo "No tasks found, skipping"
      continue
    fi
    echo "${#tasks[@]} task(s) found"
    for t in "${tasks[@]}"; do
      echo "Stopping task $t"
      aws ecs stop-task --cluster $cluster --task $t --query 'task.stoppedReason' --output=text
    done
  done
}

# info: loga linhas de info no stderr (usado internamente pelas funções aws)
function info() {
  local prefix=$1; shift
  echo "[$prefix] $*" 1>&2
}

# aws-logs: lê logs do CloudWatch de um stream específico
# pagina automaticamente até chegar ao fim
# uso: aws-logs <grupo> <stream>
function aws-logs() {
  local token text line next_token
  local group_name=$1; shift
  local stream_name=$1; shift
  [[ "$1" ]] && token="--next-token $1"
  text=$(
    aws logs get-log-events --log-group-name $group_name --log-stream-name $stream_name \
    --query '[nextForwardToken,events[*].[timestamp,message]]' \
    --output text $token \
    --start-from-head
  )
  while read -r line; do
    if [[ ! "$next_token" ]]; then
      next_token="$line"
    else
      local parts=($line)
      printf "[%(%F %T)T] ${parts[*]:1}\n" $((${parts[0]}/1000))
    fi
  done <<< "$text"
  if [[ "$next_token" != "$1" ]]; then
    info LOG "Fetching more..."
    aws-logs $group_name $stream_name $next_token
  else
    info LOG "Done!"
  fi
}
