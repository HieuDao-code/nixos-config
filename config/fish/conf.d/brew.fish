# Homebrew environment setup
if type -q brew
    eval (brew shellenv)
else if test -d /opt/homebrew
    eval (/opt/homebrew/bin/brew shellenv)
end
