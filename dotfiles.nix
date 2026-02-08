{ config, ... }:

# Symlink config files to home directory
let
  dotfiles = "${config.home.homeDirectory}/.dotfiles/config";
  configs = [
    "btop"
  ];

  mkLink = name: {
    name = name;
    value.source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${name}";
  };
in
{
  xdg.configFile = builtins.listToAttrs (map mkLink configs);
}
