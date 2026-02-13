# Homebrew
if [[ $OSTYPE == darwin* ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Launch fish shell if not already in fish
if ! ps -p $PPID | grep -q fish; then
    fish
fi
