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
export DOCKER_BUILDKIT=1
export GOPATH=$HOME/.go
export GOPRIVATE=github.com/Pattern-Labs
export SNIPPETS=$HOME/repos/github.com/arjungandhi/dot/snippets
export SITEREPO=$HOME/repos/github.com/arjungandhi/arjungandhi.com
export SCRIPTS=$HOME/repos/github.com/arjungandhi/dot/scripts
export NOTES=$HOME/repos/github.com/arjungandhi/dot/vault
export WORKSPACE=$HOME/repos/github.com
export REPOS=$HOME/repos
export FUNCTIONS=$HOME/repos/github.com/arjungandhi/dot/functions
export ZETDIR=$HOME/repos/github.com/arjungandhi/monkey/notes
export LISTDIR=$HOME/repos/github.com/arjungandhi/monkey/lists
export ATP_DIR=$HOME/repos/github.com/arjungandhi/monkey/atp
export TODO_DIR=$HOME/repos/github.com/arjungandhi/monkey/atp
export DARWINDIR=$HOME/repos/github.com/arjungandhi/darwin-tree
export JUPYTER_DD_API_KEY="c8f50944875de920b2cc701376ef9841"

export CARGO_NET_GIT_FETCH_WITH_CLI=true
export OLLAMA_MODEL="llama3.2"
export ANDROID_HOME=$HOME/.android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
# temporary until I can resolve the .profile nonsense
export PATH=$PATH:$HOME/.local/bin


# variables for cd
export snippets=$SNIPPETS
export notes=$SCRIPTS

# -------------------------------- smart prompt --------------------------------
#                 (keeping in bashrc for portability)

PROMPT_AT=@

__ps1() {
  # append history
  # history -a
  # read history
  # history -n

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
  # Remove Build Cache
  docker builder prune -a -f
}


# source the functions (all files in the functions directory)
for file in $FUNCTIONS/*.sh; do
  _source_if "$file"
done
 
# ----------------- source external dependenices / completion -----------------
#enable tab completion
if [ -f /etc/bash_completion ]; then
  source /etc/bash_completion
fi
# source stuff that has inbuilt completion
owncomp=(snip list workon prs license zet excalidraw darwin date_iso branch post kal money atp)
for i in ${owncomp[@]}; do complete -C $i $i; done
# other stuff
_have gh && . <(gh completion -s bash)
_have pattern && . <(pattern completion bash)
_have molecule && . <(molecule completion bash)
_have atom && . <(atom completion bash)
_have kubectl && . <(kubectl completion bash)
_have docker && . <(docker completion bash)

complete -C '/usr/bin/aws_completer' aws
complete -C /usr/bin/terraform terraform

# _have fzf && source /usr/share/fzf/completion.bash

# ---------------------------------- aliases ----------------------------------
# ls 
alias ls='ls --color'

# apollo scripts
alias apollo_dev_start=~/workspace/pattern/apollo/docker/scripts/dev_start.sh
alias apollo_dev_into=~/workspace/pattern/apollo/docker/scripts/dev_into.sh
alias apollo_compose="docker compose --env-file /opt/pattern/robot.env --project-directory ~/workspace/pattern/apollo/docker/service"
alias apollo_into="docker exec -it apollo /bin/bash"

# kitty
# alias ssh="kitty +kitten ssh"
alias icat="kitty +kitten icat"

# alias both vi and vim to nvim
alias vim=nvim

# temp
alias temp="cd $(mktemp -d)"

# scripts
alias scripts="cd $SCRIPTS"

# snippets
alias snippets="cd $SNIPPETS"

# bazel -> bazelisk
alias bazel=bazelisk

# knowledge
# note this is a temporary thing as we work out the organization of our knowledge base
alias knowledge="cd $KNOWLEDGE"

# alias todo.sh -> t
alias t="todo.sh"
# complete -F _todo t

# kubectl -> k
alias k=kubectl
complete -o default -F __start_kubectl k

# ------------------------------ program configs ------------------------------
# gcloud cli
source /etc/profile.d/google-cloud-cli.sh 

# nodenev init
eval "$(nodenv init -)"

# yarn global bin
_have yarn && export PATH="$PATH:$(yarn global bin)"

# thefuck
eval $(thefuck --alias)

# fzf
_have rg && export FZF_DEFAULT_COMMAND='rg --files'
export FZF_DEFAULT_OPTS='-m --height 50% --border'
 
if [[ -f /opt/pattern/bin/pattern_user_env.sh ]]; then
    . /opt/pattern/bin/pattern_user_env.sh
fi

# cargo
. "$HOME/.cargo/env"
