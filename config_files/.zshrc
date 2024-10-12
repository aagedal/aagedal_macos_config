
# Load Powerlevel10k theme
source $(brew --prefix powerlevel10k)/share/powerlevel10k/powerlevel10k.zsh-theme

# Load your Powerlevel10k configuration if it exists
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh


# Enable Oh My Zsh plugins
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

# Enable syntax highlighting
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Enable autosuggestions
source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# ---- Eza (better ls) -----

alias ls="eza -la --no-permissions --no-user --header --group-directories-last --icons=always"

# Aliases
alias gs='git status'
alias gp='git push'
alias gl='git pull'
alias c='clear'

# Environment Variables
export EDITOR='nano'
export PATH="$HOME/bin:$(brew --prefix)/bin:$(brew --prefix)/opt/powerlevel10k/bin:$PATH"

# History Settings
export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

# Enable auto-completion
autoload -U compinit
compinit
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path ~/.zsh_cache
zstyle ':completion:*' menu select

# Set terminal title
precmd() { print -Pn "\e]0;%n@%m: %~\a" }

# Source additional configuration files if they exist
[[ -f ~/.zsh_aliases ]] && source ~/.zsh_aliases
[[ -f ~/.zsh_functions ]] && source ~/.zsh_functions
