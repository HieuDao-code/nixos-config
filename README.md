### Update System with Flake

```sh
# Update flake.lock
nix flake update

# Or update only the specific input, such as home-manager:
nix flake update home-manager

# Apply the updates
# sudo nixos-rebuild switch --flake .
sudo nixos-rebuild switch
```

### Symlink with stow

```sh
sudo stow --adopt --target="/etc/nixos" nixos-config
```
