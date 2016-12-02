
export GO_VERSION=1.7.1
export GO_SRC=/usr/local/go

# if we are passing the version
if [[ ! -z "$1" ]]; then
        export GO_VERSION=$1
fi

# purge old src
if [[ -d "$GO_SRC" ]]; then
        sudo rm -rf "$GO_SRC"
        sudo rm -rf "$GOPATH"
fi

# subshell because we `cd`
(
echo ${GO_VERSION}
curl -sSL "https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz" | sudo tar -v -C /usr/local -xz
)

# get commandline tools
(
set -x
set +e
go get github.com/golang/lint/golint
go get golang.org/x/tools/cmd/cover
go get golang.org/x/review/git-codereview
go get golang.org/x/tools/cmd/goimports
go get golang.org/x/tools/cmd/gorename
go get golang.org/x/tools/cmd/guru

go get github.com/jessfraz/apk-file
go get github.com/jessfraz/audit
go get github.com/jessfraz/bane
go get github.com/jessfraz/battery
go get github.com/jessfraz/cliaoke
go get github.com/jessfraz/ghb0t
go get github.com/jessfraz/magneto
go get github.com/jessfraz/netns
go get github.com/jessfraz/netscan
go get github.com/jessfraz/onion
go get github.com/jessfraz/pastebinit
go get github.com/jessfraz/pony
go get github.com/jessfraz/reg
go get github.com/jessfraz/riddler
go get github.com/jessfraz/udict
go get github.com/jessfraz/weather

go get github.com/axw/gocov/gocov
go get github.com/brianredbeard/gpget
go get github.com/cloudflare/cfssl/cmd/cfssl
go get github.com/cloudflare/cfssl/cmd/cfssljson
go get github.com/crosbymichael/gistit
go get github.com/crosbymichael/ip-addr
go get github.com/cbednarski/hostess/cmd/hostess
go get github.com/davecheney/httpstat
go get github.com/FiloSottile/gvt
go get github.com/FiloSottile/vendorcheck
go get github.com/nsf/gocode
go get github.com/rogpeppe/godef
go get github.com/shurcooL/git-branches
go get github.com/shurcooL/gostatus
go get github.com/shurcooL/markdownfmt
go get github.com/Soulou/curl-unix-socket

aliases=( cloudflare/cfssl docker/docker letsencrypt/boulder opencontainers/runc jessfraz/binctr jessfraz/contained.af )
for project in "${aliases[@]}"; do
        owner=$(dirname "$project")
        repo=$(basename "$project")
        if [[ -d "${HOME}/${repo}" ]]; then
                rm -rf "${HOME:?}/${repo}"
        fi

        mkdir -p "${GOPATH}/src/github.com/${owner}"

        if [[ ! -d "${GOPATH}/src/github.com/${project}" ]]; then
                (
                # clone the repo
                cd "${GOPATH}/src/github.com/${owner}"
                git clone "https://github.com/${project}.git"
                # fix the remote path, since our gitconfig will make it git@
                cd "${GOPATH}/src/github.com/${project}"
                git remote set-url origin "https://github.com/${project}.git"
                )
        else
                echo "found ${project} already in gopath"
        fi

        # make sure we create the right git remotes
        if [[ "$owner" != "jessfraz" ]]; then
                (
                cd "${GOPATH}/src/github.com/${project}"
                git remote set-url --push origin no_push
                git remote add jessfraz "https://github.com/jessfraz/${repo}.git"
                )
        fi
done

# do special things for k8s GOPATH
mkdir -p "${GOPATH}/src/k8s.io"
git clone "https://github.com/kubernetes/kubernetes.git" "${GOPATH}/src/k8s.io/kubernetes"
cd "${GOPATH}/src/k8s.io/kubernetes"
git remote set-url --push origin no_push
git remote add jessfraz "https://github.com/jessfraz/kubernetes.git"
)