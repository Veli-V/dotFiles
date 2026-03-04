# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="robbyrussell"

# Plugins
# oh-my-zsh fzf plugin hoitaa completions ja key-bindings jos fzf on asennettu
plugins=(fzf git)

if [ -f $ZSH/oh-my-zsh.sh ]; then
    source $ZSH/oh-my-zsh.sh
else
    echo "⚠️ Oh My Zsh puuttuu: $ZSH/oh-my-zsh.sh"
fi

# --- Editor Configuration ---
if command -v nvim >/dev/null; then
    export EDITOR='nvim'
    alias vim='nvim'
    alias vi='nvim'
else
    echo "⚠️ Neovim (nvim) puuttuu, käytetään oletus-vi:tä"
    export EDITOR='vi'
fi

# --- Path Configuration (Cross-platform) ---
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS specific paths
    export PATH="/Users/veli-v/bin/emacs/bin:/Users/veli-v/scripts:/Users/veli-v/.config/emacs/bin/:/Users/veli-v/.local/bin:/Users/veli-v/Library/Python/3.9/bin:/opt/homebrew/opt/libpq/bin:$PATH"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux specific paths
    export PATH="/home/veli-v/bin/emacs/bin:/home/veli-v/scripts:/home/veli-v/.config/emacs/bin/:/home/veli-v/.local/bin:$PATH"
fi

# --- Tool Integrations & Dependency Checks ---

# Thefuck
if command -v thefuck >/dev/null; then
    eval $(thefuck --alias)
else
    echo "ℹ️ thefuck puuttuu (brew install thefuck / pip install thefuck)"
fi

# Zoxide (parempi cd)
if command -v zoxide >/dev/null; then
    eval "$(zoxide init --cmd j zsh)"
else
    echo "ℹ️ zoxide puuttuu (brew install zoxide / apt install zoxide)"
fi

# Eza (parempi ls)
if command -v eza >/dev/null; then
    alias ls='eza'
    alias ll='eza -l'
    alias la='eza -la'
else
    echo "ℹ️ eza puuttuu (brew install eza / cargo install eza)"
fi

# FZF
if ! command -v fzf >/dev/null; then
    echo "ℹ️ fzf puuttuu (brew install fzf)"
fi
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
if [ -d "$NVM_DIR" ]; then
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
else
    echo "ℹ️ nvm puuttuu: $NVM_DIR"
fi

# Envman
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# Omat scriptit ja agentit
[ -f ~/.agentti ] && source ~/.agentti
[ -f $HOME/.agentti ] && source $HOME/.agentti

# --- Aliases & Variables ---
export AWS_SESSION_TOKEN_TTL="8h"

# Terraform / OpenTofu
alias tf='terraform'
alias tfa='tofu apply --auto-approve'
