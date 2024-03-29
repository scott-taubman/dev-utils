# NOTE: This is not a complete .bashrc. The intention is that the local .bashrc
#       will source this one to add all of the customizations managed here.

export EDITOR=vi

# dev-utils
export PROJECT_HOME="$HOME/dev"

# python
export PYTHONDONTWRITEBYTECODE=1

# pyenv
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
