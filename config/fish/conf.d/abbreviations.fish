# Abbreviations
status is-interactive || exit

# Eza
if type -q eza
    abbr -a ls 'eza'
    abbr -a ll 'eza -l'
    abbr -a la 'eza -la'
    abbr -a tree 'eza --tree'
end

# Lazygit
if type -q lazygit
    abbr -a lg 'lazygit'
end
