#####################
# aliases
#####################

# python envs
alias cdsitepackages="cd \`python -c 'import site; print(site.getsitepackages()[0])'\`"
#alias beer="workon beer-garden && cd ~/dev/beer-garden"

# docker
alias dcu="docker-compose up"
alias dcd="docker-compose down"
alias dce="docker-compose exec"
alias de="docker exec -it"
alias dl="docker logs --tail 20 -f" 
alias dps="docker_container_top"
alias drm="docker_stop_and_rm"

# git
alias gb="git branch"
alias gba="git branch -a"
alias gc="git checkout"
alias gf="git fetch"
alias gp="git pull"

alias brew='pyenv deactivate 2>/dev/null; cd $PROJECT_HOME/brewtils; pyenv activate brewtils38'
alias dev='cd $PROJECT_HOME/dev-utils'
alias dev-utils='cd $PROJECT_HOME/dev-utils'
alias react='cd $PROJECT_HOME/react-ui'

#####################
# functions
#####################

# virtualenv
function workon() {
    if [ -z $1 ]; then
        pyenv versions
    elif [ "$1" = "-d" ]; then
        pyenv deactivate
    else
        pyenv activate $1
    fi
}

function beer() {
    case $1 in
        "") pyenv deactivate 2>/dev/null; cd $PROJECT_HOME/beer-garden; pyenv activate beer-garden;;
        *) $PROJECT_HOME/dev-utils/scripts/beer $@ ;;
    esac
}

function docker_container_top() {
    docker container top $1 -o pid,ppid,args
}

function docker_stop_and_rm() {
   docker stop $@ && docker rm $@ 
}
