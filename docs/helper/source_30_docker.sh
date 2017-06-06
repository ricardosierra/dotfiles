cat <<-HELP
Docker Alias:
    dc: GetIP addresses for docker container
        Usage: dc docker_container
    up: docker-compose up
    down: docker-compose down

Docker Functions:
    dockexec: Docker exec container bash
        Usage: dockexec docker_container
    delimg: Delete all containers matching the passed paramater
    delnone: Delete all with a <none> label bad makes will orphan a 'none' img
    delimg: Delete all images matching the arg passed after 'delimg none'
    dcleanup: clean docker images
    nginx_config: creates an nginx config for a local route
        Usage: nginx_config server route

HELP
