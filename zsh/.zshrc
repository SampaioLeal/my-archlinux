export ZSH="$HOME/.oh-my-zsh"

ZSH_CUSTOM=$HOME/.oh-my-zsh/custom
ZSH_THEME="spaceship"

zstyle ":omz:update" mode auto

# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="dd/mm/yyyy"

plugins=(
  git 
  npm
  nvm
  docker
  zsh-syntax-highlighting 
  zsh-autosuggestions
)
fpath+=${ZSH_CUSTOM}/plugins/zsh-completions/src

source $ZSH/oh-my-zsh.sh

# NodeJS Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

export DENO_INSTALL="$HOME/.deno"

typeset -U path

path+=(
  "${HOME}/.yarn/bin"
  "${DENO_INSTALL}/bin"
  "${HOME}/go/bin"
  "${HOME}/.krew/bin"
)

# Personal Aliases
alias awsp="source _awsp"

# Kubernetes completion
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

# Helm completion
[[ $commands[helm] ]] && source <(helm completion zsh)

# Personal Functions
pokemon-colorscripts -r
