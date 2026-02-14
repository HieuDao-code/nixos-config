### Installation

```
curl -fsSL https://raw.githubusercontent.com/HieuDao-Code/nixos-config/main/install.sh | bash
```

### Update System with Flake

```sh
# Update flake.lock
nix flake update

# Apply the updates
sudo nixos-rebuild switch --flake .#$(hostname)
```
