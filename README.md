### Installation

```
curl -fsSL https://raw.githubusercontent.com/HieuDao-Code/nixos-config/main/install.sh | bash
```

### Update System with Flake

```sh
# Update flake.lock
nix flake update

# Or update only the specific input, such as home-manager:
nix flake update home-manager

# Apply the updates
sudo nixos-rebuild switch --flake .#$(hostname)
```
