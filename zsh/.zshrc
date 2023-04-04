export ZSH="$HOME/.oh-my-zsh"

ZSH_CUSTOM=$HOME/.oh-my-zsh/custom
ZSH_THEME="spaceship"

zstyle ':omz:update' mode auto

# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"
HIST_STAMPS="dd/mm/yyyy"

plugins=(
  git 
  zsh-syntax-highlighting 
  zsh-autosuggestions
)
fpath+=${ZSH_CUSTOM}/plugins/zsh-completions/src

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=pt_BR.UTF-8

# NodeJS Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Yarn Package Manager
export PATH="$PATH:$HOME/.yarn/bin"

# Deno Runtime
export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"

# Go Language
export PATH="$HOME/go/bin:$PATH"
# Kubectl Plugin Manager
export PATH="$HOME/.krew/bin:$PATH"

# Personal Aliases
alias awsp="source _awsp"

# Personal Functions
pokemon-colorscripts -r
