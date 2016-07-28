	export GO_VERSION=1.6.3
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

	go get github.com/jfrazelle/apk-file
	go get github.com/jfrazelle/bane
	go get github.com/jfrazelle/battery
	go get github.com/jfrazelle/cliaoke
	go get github.com/jfrazelle/magneto
	go get github.com/jfrazelle/netns
	go get github.com/jfrazelle/netscan
	go get github.com/jfrazelle/onion
	go get github.com/jfrazelle/pastebinit
	go get github.com/jfrazelle/pony
	go get github.com/jfrazelle/riddler
	go get github.com/jfrazelle/udict
	go get github.com/jfrazelle/weather

	go get github.com/axw/gocov/gocov
	go get github.com/brianredbeard/gpget
	go get github.com/cloudflare/cfssl/cmd/cfssl
	go get github.com/cloudflare/cfssl/cmd/cfssljson
	go get github.com/crosbymichael/gistit
	go get github.com/crosbymichael/ip-addr
	go get github.com/cbednarski/hostess/cmd/hostess
	go get github.com/FiloSottile/gvt
	go get github.com/FiloSottile/vendorcheck
	go get github.com/nsf/gocode
	go get github.com/rogpeppe/godef
	go get github.com/shurcooL/git-branches
	go get github.com/shurcooL/gostatus
	go get github.com/shurcooL/markdownfmt
	go get github.com/Soulou/curl-unix-socket

	aliases=( cloudflare/cfssl docker/docker letsencrypt/boulder opencontainers/runc jfrazelle/binctr jfrazelle/contained.af )
	for project in "${aliases[@]}"; do
		owner=$(dirname "$project")
		repo=$(basename "$project")
		if [[ -d "${HOME}/${repo}" ]]; then
			rm -rf "${HOME}/${repo}"
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
		if [[ "$owner" != "jfrazelle" ]]; then
			(
			cd "${GOPATH}/src/github.com/${project}"
			git remote set-url --push origin no_push
			git remote add jfrazelle "https://github.com/jfrazelle/${repo}.git"
			)
		fi

		# create the alias
		ln -snvf "${GOPATH}/src/github.com/${project}" "${HOME}/${repo}"
	done

	# do special things for k8s GOPATH
	mkdir -p "${GOPATH}/src/k8s.io"
	git clone "https://github.com/kubernetes/kubernetes.git" "${GOPATH}/src/k8s.io/kubernetes"
	(
	cd "${GOPATH}/src/k8s.io/kubernetes"
	git remote set-url --push origin no_push
	git remote add jfrazelle "https://github.com/jfrazelle/kubernetes.git"
	)
	ln -snvf "${GOPATH}/src/k8s.io/kubernetes" "${HOME}/kubernetes"


	# create symlinks from personal projects to
	# the ${HOME} directory
	projectsdir=$GOPATH/src/github.com/jfrazelle
	base=$(basename "$projectsdir")
	find "$projectsdir" -maxdepth 1 -not -name "$base" -type d -print0 | while read -d '' -r dir; do
	base=$(basename "$dir")
    ln -snvf "$dir" "${HOME}/${base}"
