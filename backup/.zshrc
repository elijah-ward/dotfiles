# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/eward/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="lambda-gitster"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# This speeds up pasting w/ autosuggest
# https://github.com/zsh-users/zsh-autosuggestions/issues/238
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

export code=~/code/repo

function subla () {
    subl -a $@
}

function subrep () {
        for repo in "$@"
	do
		subl -a $code/$repo
	done
}

source ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
# aliases
alias update="sudo apt-get update"
alias k="kubectl"
alias v="vim"
alias bt="sed 's/\x1b\[[0-9;]*m//g'"
alias cb-plan="terragrunt plan | bt | sed -n '/^------------------------------------------------------------------------$/,/^------------------------------------------------------------------------$/p' | xclip -selection clipboard"
alias cb-plan2="terragrunt plan | bt | sed -n '/^Terraform will perform the following actions:$/,/^------------------------------------------------------------------------$/p' | xclip -selection clipboard"
alias tf-plan="tf-fresh plan | bt | sed -n '/^Terraform will perform the following actions:$/,/^------------------------------------------------------------------------$/p' | xclip -selection clipboard"
alias awsume='. ~/.pyenv/versions/3.9.0/bin/awsume'
alias config-gitlab-repo='git config user.email "eward@miovision.com" && git config user.name "Elijah Ward"'
alias rmtf='rm -rf ./.terraform ./.terragrunt-cache'
alias sk="skaffold"
alias subgr='subl -a $(git root)'
alias vim='nvim'
alias vi='nvim'
alias gits='git status'
alias gitd='git diff'
alias ssol='AWS_PROFILE=default aws sso login'
alias sourcez='source ~/.zshrc'
alias tg='terragrunt'

# functions
function assume () {
    if [[ $(aws configure --profile $1 list) && $? -eq 0 ]]
    then
	    echo "\e[92mAssuming AWS profile \"$1\"..."
	    AWS_PROFILE=$1 && export AWS_PROFILE
    else
	    echo "\e[91mAWS profile \"$1\" does not exist. Exiting..." && return 1
    fi
}

function tf-fresh () {
    rm -rf .terraform
    terraform init
    terraform "$@"
}

function sso() {
    AWS_PROFILE_TEMP=$AWS_PROFILE
    AWS_PROFILE=default
    aws sso login
    AWS_PROFILE=$AWS_PROFILE_TEMP
}

k8debug() { kubectl run -i --rm --tty eli-debug --image=$1 --restart=Never -- sh }

# Keep this at the end
eval "$(pyenv init -)"

if which ruby >/dev/null && which gem >/dev/null; then
  PATH="$(ruby -r rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
export PATH=$PATH:$HOME/bin
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
[ -s "/home/eward/.jabba/jabba.sh" ] && source "/home/eward/.jabba/jabba.sh"
# Created by `pipx` on 2021-04-13 13:34:57
export PATH="$PATH:/home/eward/.local/bin"
export PATH="$HOME/.poetry/bin:$PATH"
alias kx='kubectx'

function k9() {
    kx $1 && k9s
}

alias tf='terraform'
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

#export PATH="$HOME/.jenv/bin:$PATH"
#eval "$(jenv init -)"
#export PATH="/usr/local/opt/openjdk@11/bin:$PATH"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/eward/miniconda-mio/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/eward/miniconda-mio/etc/profile.d/conda.sh" ]; then
        . "/Users/eward/miniconda-mio/etc/profile.d/conda.sh"
    else
        export PATH="/Users/eward/miniconda-mio/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export PATH="$PATH:/Users/eward/istio-1.14.1/bin"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/eward/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
