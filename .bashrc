#!bash shellcheck disable=SC1090

case $- in
*i*) ;; # interactive
*) return ;; 
esac

# -------------------------- local utility functions --------------------------

_have()      { type "$1" &>/dev/null; }
_source_if() { [[ -r "$1" ]] && source "$1"; }

# --------------------------- source bash variables ---------------------------

export EDITOR=nvim
export AWS_PROFILE=pattern
export DOCKER_BUILD_CONTEXT=default
export DOCKER_CLOUD_DEPLOYMENT_CONTEXT=pattern-aws
export DOCKER_DEPLOYMENT_CONTEXT=pattern-aws
export DOCKER_BUILDKIT=1
export GOPATH=/home/arjun/.go
export GOPRIVATE=github.com/Pattern-Labs
export SNIPPETS=/home/arjun/repos/github.com/arjungandhi/dot/snippets
export SCRIPTS=/home/arjun/repos/github.com/arjungandhi/dot/scripts
export NOTES=/home/arjun/repos/github.com/arjungandhi/dot/vault
export WORKSPACE=/home/arjun/repos/github.com
export REPOS=/home/arjun/repos
export FUNCTIONS=/home/arjun/repos/github.com/arjungandhi/dot/functions
export ZETDIR=/home/arjun/repos/github.com/arjungandhi/knowledge
export DARWINDIR=/home/arjun/repos/github.com/arjungandhi/darwin-tree
export PATTERN_DEV_NAMESPACE=monkey

# variables for cd
export pp="/home/arjun/repos/github.com/Pattern-Labs/vault/02 - Getting Sh!t Done/01 - Engineering/03 - What People Are Doing/monkey"
export snippets=$SNIPPETS
export notes=$SCRIPTS

# -------------------------------- smart prompt --------------------------------
#                 (keeping in bashrc for portability)

PROMPT_AT=@

__ps1() {
  # append history
  history -a
  # read history
  history -n

  local P='❯' dir="${PWD##*/}" BR A B \
    red='\[\e[31m\]' grey='\[\e[30m\]' dark_blue='\[\e[36m\]' \
    light_blue='\[\e[34m\]' green='\[\e[32m\]' purple='\[\e[35m\]' \
    reset='\[\e[0m\]' yellow='\[\e[33m\]' \
  P='$' 
  u=$light_blue
  [[ $EUID == 0 ]] && P='#' && u=$red# root
  [[ $PWD = / ]] && dir=/
  [[ $PWD = "$HOME" ]] && dir='~'

  # git branch
  branch=$(git branch --show-current 2>/dev/null)
  [[ $dir = "$branch" ]] && BR=
  [[ -n "$branch" ]] && BR="$grey:$red($branch)"

  # git ahead, behind
  ahead=$(git rev-list --count --right-only @{upstream}...HEAD 2>/dev/null)
  behind=$(git rev-list --count --left-only @{upstream}...HEAD 2>/dev/null)
  A=
  B=
  [[ $ahead -gt 0 ]] && A="$light_blue↑$ahead"
  [[ $behind -gt 0 ]] && B="$purple↓$behind"

  # staged, unstaged, untracked 
  # this takes to long to run every prompt especially on large repos
  # staged=$(git diff --name-only --cached --diff-filter=ACMRT 2>/dev/null)
  # unstaged=$(git diff --name-only --diff-filter=ACMRT 2>/dev/null)
  # untracked=$(git ls-files --others --exclude-standard 2>/dev/null)
  S=
  U=
  UT=
  # [[ -n "$staged" ]] && S="$green●"
  # [[ -n "$unstaged" ]] && U="$yellow●"
  # [[ -n "$untracked" ]] && UT="$red●"

  short="$u\u$grey$PROMPT_AT$green\h$grey:$purple$dir$BR$A$B$S$U$UT $yellow$P$reset "

  PS1="$short"
}

PROMPT_COMMAND="__ps1"

# ---------------------------- useful bash settings ----------------------------
# makes it so that you can use the up arrow to cycle through your history
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# menu complete forward and backward
bind 'TAB:menu-complete'
bind '"\e[Z":menu-complete-backward'

# Display a list of the matching files without beep
bind 'set show-all-if-ambiguous on'
# ignore case
bind 'set completion-ignore-case on'
# Perform partial (common) completion on the first Tab press, only start
# cycling full results on the second Tab press (from bash version 5)
bind 'set menu-complete-display-prefix on'
# disable terminal lock
stty -ixon
# cdable vars
shopt -s cdable_vars

# --------------------------------- dircolors ---------------------------------
if _have dircolors; then
  if [[ -r "$HOME/.dircolors" ]]; then
    eval "$(dircolors -b "$HOME/.dircolors")"
  else
    eval "$(dircolors -b)"
  fi
fi

# ---------------------------------- history ----------------------------------
export HISTCONTROL=ignoreboth
export HISTSIZE=5000
export HISTFILESIZE=10000

shopt -s histappend

# -------------------------------- user scripts --------------------------------

# add the scripts folder to this
export PATH=$SCRIPTS:$PATH

# add go bin to the path
export PATH=$GOPATH/bin:$PATH

# extract zip archives
extract () {
if [ -f $1 ] ; then
  case $1 in
    *.tar.bz2)   tar xjf $1     ;;
    *.tar.gz)    tar xzf $1     ;;
    *.bz2)       bunzip2 $1     ;;
    *.rar)       unrar e $1     ;;
    *.gz)        gunzip $1      ;;
    *.tar)       tar xf $1      ;;
    *.tbz2)      tar xjf $1     ;;
    *.tgz)       tar xzf $1     ;;
    *.zip)       unzip $1       ;;
    *.Z)         uncompress $1  ;;
    *.7z)        7z x $1        ;;
    *)     echo "'$1' cannot be extracted via extract()" ;;
     esac
 else
     echo "'$1' is not a valid file"
 fi
}

# docker purge
docker-purge-all() {
  # Stop all containers
  docker stop `docker ps -qa`
  # Remove all containers
  docker rm `docker ps -qa`
  # Remove all images
  docker rmi -f `docker images -qa `
  # Remove all volumes
  docker volume rm $(docker volume ls -qf dangling="true")
  # Remove all networks
  docker network rm `docker network ls -q`
}


# source the functions
source $FUNCTIONS/workon.sh

 
# ----------------- source external dependenices / completion -----------------
#enable tab completion
if [ -f /etc/bash_completion ]; then
  source /etc/bash_completion
fi
# source stuff that has inbuilt completion
owncomp=(snip workon prs license zet excalidraw darwin date_iso)
for i in ${owncomp[@]}; do complete -C $i $i; done
# other stuff
_have gh && . <(gh completion -s bash)
_have pattern && . <(pattern completion bash)

complete -C '/usr/bin/aws_completer' aws
complete -C /usr/bin/terraform terraform


# ---------------------------------- aliases ----------------------------------
# ls 
alias ls='ls --color'

# apollo scripts
alias apollo_dev_start=~/workspace/pattern/apollo/docker/scripts/dev_start.sh
alias apollo_dev_into=~/workspace/pattern/apollo/docker/scripts/dev_into.sh
alias apollo_compose="docker compose --env-file /opt/pattern/robot.env --project-directory ~/workspace/pattern/apollo/docker/service"
alias apollo_into="docker exec -it apollo /bin/bash"

# ssh kitty
alias ssh="kitty +kitten ssh"

# alias both vi and vim to nvim
alias vi=nvim
alias vim=nvim

# temp
alias temp="cd $(mktemp -d)"

# scripts
alias scripts="cd $SCRIPTS"

# snippets
alias snippets="cd $SNIPPETS"

# knowledge
# note this is a temporary thing as we work out the organization of our knowledge base
alias knowledge="cd $KNOWLEDGE"

# ------------------------------ program configs ------------------------------
# pdm
if [ -n "$PYTHONPATH" ]; then
    export PYTHONPATH='/usr/lib/python3.10/site-packages/pdm/pep582':$PYTHONPATH
else
    export PYTHONPATH='/usr/lib/python3.10/site-packages/pdm/pep582'
fi

# nodenev init
eval "$(nodenv init -)"

# yarn global bin
export PATH="$PATH:$(yarn global bin)"

# thefuck
eval $(thefuck --alias)

# fzf
_have rg && export FZF_DEFAULT_COMMAND='rg --files'
export FZF_DEFAULT_OPTS='-m --height 50% --border'
