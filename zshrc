# General Setup
# Disable login text
if [[ -o login ]]; then
  touch ~/.hushlogin
fi

# SET VARIABLES
# Set syntax highlighting for man pages
export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"
export HOMEBREW_CASK_OPTS="--no-quarantine"
export N_PREFIX="$HOME/.n"
export PREFIX="$N_PREFIX"

# Set terminal color capabilities (if necessary)
export TERM=xterm-256color

# Add zsh-completions to fpath
fpath=($fpath ~/dotfiles/zsh/plugins/zsh-completions)

# Completion Settings
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -G $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls -G $realpath'

# Enable completion system
autoload -Uz compinit
# -C to prevent overwriting of previous completions
compinit -C

# Load complist for enhanced menu selection completion
zmodload -i zsh/complist

# Enable directory completion features
autoload -Uz cdablevars

# autoload -U bracketed-paste-magic
# bracketed-paste-magic

# Define custom colors (hex values)
NIRUSU_BLUE="#089cec"
NIRUSU_BLUE_DARK="#067cbc"
COLOR_2="#FFA500"  # Orange
COLOR_3="#FFFFFF"  # White

source ~/dotfiles/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh

# After compinit, customize fzf colors
# https://minsw.github.io/fzf-color-picker/
export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS' --color=fg:#e0e0e0,bg:-1,hl:#83cdf5 --color=fg+:#ffffff,bg+:#089cec,hl+:#f2ff00 --color=info:#83cdf5,prompt:#83cdf5,pointer:#089cec --color=marker:#f2ff00,spinner:#ff5e00,header:#089cec,border:#83cdf5'
# After sourcing fzf-tab, customize its colors
zstyle ':fzf-tab:*' fzf-flags $(echo $FZF_DEFAULT_OPTS)

# Completion setup (before syntax highlighting)
source ~/dotfiles/zsh/plugins/zsh-completions/zsh-completions.plugin.zsh

# Autosuggestions
source ~/dotfiles/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Add Homebrew to $PATH
# export PATH="/opt/homebrew/bin:$PATH"
# Check architecture and add the appropriate Homebrew path
if [[ $(uname -m) == "arm64" ]]; then
  # Apple Silicon (M1/M2)
  export PATH="/opt/homebrew/bin:$PATH"
else
  # Intel Mac
  export PATH="/usr/local/bin:$PATH"
fi

# ADD LOCATIONS TO $PATH VARIABLE
# Set default path to ensure user binaries are included first
export PATH="$HOME/bin:$PATH"

# Include global npm binaries
export PATH="$PATH:$HOME/.npm-global/bin"

# Add WezTerm binary (if needed)
export PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"

# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# n for node
export PATH="$PATH:$N_PREFIX/bin"
# try this one when there are conflicting node paths 
# export PATH="$N_PREFIX/bin:$PATH"

# export PATH="/nix/store/0bijgrbc3m0s7vg8fgp7wbq74jd5wc17-php-with-extensions-8.2.22/bin:$PATH"

# PHP 8.3 
export PATH="/usr/local/opt/php@8.3/bin:$PATH"
export PATH="/usr/local/opt/php@8.3/sbin:$PATH"
# Load NVM (Node Version Manager)
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# WRITE HANDY FUNCTIONS

# Enable command auto-correction (optional)
setopt correct

# Enable substitution in the prompt.
setopt prompt_subst

# Disable line-wrapping behavior for pasted text
unsetopt auto_list

# Prompt Customization

# Custom prompt with current directory and Git branch on the first line
# PROMPT='%F{$(echo $NIRUSU_BLUE)}%~ %f %L
# ❯ '
PROMPT='%F{$(echo $NIRUSU_BLUE)}%B%~%b%f %L
❯ '

# Right prompt if in git directory
git_prompt_info() {
  # Check if inside a git repo
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    ref=$(git symbolic-ref --short HEAD 2>/dev/null)  # Get the current branch name
    if [ -n "$ref" ]; then
      echo "$ref"
    fi
  fi
}

# Define variable for right prompt visibility
function update_right_prompt() {
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    RIGHT_PROMPT=true
  else
    RIGHT_PROMPT=false
  fi

  # Update RPROMPT based on the Git status
  if [[ $RIGHT_PROMPT == true ]]; then
    RPROMPT=' $(git_prompt_info) %F{yellow}$(git status --porcelain | wc -l | tr -d " ")%f changes'
  else
    RPROMPT=''  # Empty RPROMPT if not in a git repo
  fi
}

# Update RPROMPT when changing directories
chpwd() {
  update_right_prompt  # Call the function when the directory changes
}

# Update RPROMPT initially when the shell starts
update_right_prompt

# Add a newline after the command output
precmd() {
  print ''  # Print an empty line after the command output
}

# fcd: change directory with fzf, exclude restricted directories like .Trash
function fcd() {
  local dirs=("$HOME/Sites" "$HOME/dotfiles" "$HOME/.config")  # Add your folders here
  local dir
  dir=$(find "${dirs[@]}" -mindepth 1 -maxdepth 2 -type d \( ! -path '*/.Trash/*' \) \
    -not \( -path '*/.git' -prune -or -path '*/.github' -prune -or -path '*/.idea' -prune -or -path '*/.vscode' -prune -or -path '*/.zed' -prune -or -path '*/.nova' -prune -or -path '*/.next' -prune \) \
    2>/dev/null | fzf)  # Exclude .git, .github, .idea, .vscode, .zed, .nova
  cd "$dir" && clear
}

# Keybindings and Editor Configurations
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region
bindkey -v
bindkey -s ^a "nvims\n"

set -o vi

# Aliases
# alias ls='ls -lAGFh'
alias ls='eza -lahF --git'
alias trail='<<<${(F)path}'
alias rm=trash

# nvim switcher
alias nvim-lazy="NVIM_APPNAME=LazyVim nvim"
alias nvim-nirusu="NVIM_APPNAME=NirusuVim nvim"
alias nvim-kick="NVIM_APPNAME=kickstart nvim"
alias nvim-henk="NVIM_APPNAME=HENKVim nvim"


function nvims() {
  items=("default" "kickstart" "LazyVim" "NirusuVim" "HENKVim")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config=""
  fi
  NVIM_APPNAME=$config nvim $@
}

# History Settings
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Shell Integrations
eval "$(fzf --zsh)"

# Syntax Highlighting (must be at the end)
source ~/dotfiles/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Enable additional syntax highlighters
ZSH_HIGHLIGHT_HIGHLIGHTERS+=(brackets pattern cursor)
