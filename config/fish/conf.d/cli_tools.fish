status is-interactive || exit

# fzf.fish
set -gx fzf_preview_dir_cmd eza --oneline --color=always

# fzf
if type -q fzf
    fzf --fish | source
end

# fnm (Node version manager)
if type -q fnm
    fnm env --shell fish | source
end

# Starship prompt
if type -q starship
    starship init fish | source
    enable_transience
end

# Zoxide
if type -q zoxide
    zoxide init fish | source
end
