{ config, ... }:

# Symlink config files to home directory
let
  dotfiles = "${config.home.homeDirectory}/.dotfiles/config";
  configs = [
    "bat"
    "btop"
    "fastfetch"
    "fish"
    "ghostty"
    "git"
    "gtk-3.0"
    "gtk-4.0"
    "lazygit"
    "niri"
    "noctalia"
    "nvim"
    "qt5ct"
    "qt6ct"
    "ruff"
    "starship"
    "zsh"
  ];

  mkLink = name: {
    name = name;
    value.source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${name}";
  };
in
{
  xdg.configFile = builtins.listToAttrs (map mkLink configs);

  home.file.".zshenv".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/zsh/.zshenv";
}
