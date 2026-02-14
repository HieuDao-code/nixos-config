# just is a command runner, Justfile is very similar to Makefile, but simpler.

# List all commands
list:
  just --list

# Build and activate new configuration
[group('Nix')]
upgrade:
  nixos-rebuild switch --flake . --sudo

# Build and activate new configuration with verbose output
[group('Nix')]
debug:
  nixos-rebuild switch --flake . --sudo --show-trace --verbose

# Update all flake inputs
[group('Nix')]
update:
  nix flake update --commit-lock-file

# Update specific flake input
[group('Nix')]
update-input input:
  nix flake update {{input}} --commit-lock-file

# Update all Nixpkgs inputs
[group('Nix')]
update-nix:
  nix flake update --commit-lock-file nixpkgs nixpkgs-unstable

# Override nixpkgs's commit hash
[group('Nix')]
override-pkgs hash:
  nix flake update --commit-lock-file nixpkgs --override-input nixpkgs github:NixOS/nixpkgs/{{hash}}

# List all generations of the system profile
[group('Nix')]
history:
  nix profile history --profile /nix/var/nix/profiles/system

# Open nix shell with the flake
[group('Nix')]
repl:
  nix repl -f flake:nixpkgs

# Remove all generations older than 7 days
[group('Nix')]
clean:
  # Wipe out NixOS's history
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d
  # Wipe out home-manager's history
  nix profile wipe-history --profile "${XDG_STATE_HOME:-$HOME/.local/state}/nix/profiles/home-manager" --older-than 7d

# Garbage collect all unused nix store entries
[group('Nix')]
gc:
  # Garbage collect all unused nix store entries (system-wide)
  sudo nix-collect-garbage --delete-older-than 7d
  # Garbage collect all unused nix store entries (for the user - home-manager)
  # https://github.com/NixOS/nix/issues/8508
  nix-collect-garbage --delete-older-than 7d

# Enter shell session which has all the necessary tools for this flake
[group('Nix')]
shell:
  nix shell nixpkgs#git nixpkgs#neovim

# Format nix files in this repo
[group('Nix')]
fmt:
  for f in $(find . -name "*.nix"); do nixfmt "$f"; done

# Nix Store can contains corrupted entries if the nix store object has been modified unexpectedly.
# This command will verify all the store entries,
# and we need to fix the corrupted entries manually via `sudo nix store delete <store-path-1> <store-path-2> ...`
# Verify all the store entries
[group('Nix')]
verify-store:
  nix store verify --all

# Repair nix Store Objects
[group('Nix')]
repair-store *paths:
  nix store repair {{paths}}
