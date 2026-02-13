#!/usr/bin/env bash
set -x
set -eo pipefail

function buildnvim() {
    # Clone the neovim repository if it doesn't exist.
    local nvim_dir="$HOME/Documents/Repos/neovim"
    if [ ! -d "$nvim_dir" ]; then
        echo "Cloning neovim repository..."
        mkdir -p "$HOME/Documents/Repos"
        git clone https://github.com/neovim/neovim.git "$nvim_dir"
    fi

    # Go to the neovim directory.
    cd "$nvim_dir" || { printf '\n========== COULD NOT CD TO NEOVIM DIRECTORY ==========\n' && return; }

    if ! git diff --exit-code; then
        printf '\n========== LOCAL NEOVIM CHANGES! ==========\n'
        return
    fi

    # Checkout the master branch.
    git checkout master

    # Fetch the latest changes.
    git fetch origin master

    # Log the upstream commits.
    git --no-pager log --decorate=short --pretty=short master..origin/master

    # Merge the latest changes.
    git merge origin/master

    # Go back to the given commit or HEAD.
    local commit="${1:-HEAD}"
    printf '\n========== CHECKING OUT COMMIT %s... ==========\n' "$commit"
    git reset --hard "$commit"

    # Clear the previous build.
    local install_dir="$HOME/.nvim"
    rm -rf "$install_dir"
    make distclean

    # Build.
    make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX="$install_dir" install
}

buildnvim "$@"
