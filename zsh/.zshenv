# XDG base directories.
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_BIN_HOME="$HOME/.local/bin"

# Important path
export PATH="$XDG_BIN_HOME:$PATH"   # Local scripts
export PATH="$HOME/.nvim/bin:$PATH" # Neovim
export PATH="/usr/local/bin:$PATH"  # System tools

# zsh configuration.
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# Set up neovim as the default editor.
export EDITOR=nvim
export VISUAL="$EDITOR"

# Man pages with bat
export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -p -lman'"

# Set up the default language
export LANG="en_US.UTF-8"

# Starship doesn't follow XDG base directory specification...
# see: https://github.com/starship/starship/issues/896
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"

# fzf theme
export FZF_DEFAULT_OPTS="--color=16"
