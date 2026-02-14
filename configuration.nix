# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  inputs,
  config,
  pkgs,
  # pkgs-unstable,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Add ~/.local/bin to PATH
  environment.localBinInPath = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Power profile manager
  services.power-profiles-daemon.enable = true;

  # Power management
  services.upower.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = false;

  # Enable the GNOME Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  # services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us,us";
    variant = ",colemak_dh";
    options = "caps:escape,grp:ctrl_space_toggle";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.hieu = {
    isNormalUser = true;
    description = "Hieu";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "input"
    ];
    packages = with pkgs; [
      #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable the Flakes feature and the accompanying new nix command-line tool
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = (
    with pkgs;
    [
      vim
      wget
      git
      clang # C Compiler
      unzip

      # Nix
      nixfmt # Nix code formatter
      nixd # Nix Language server

      # CLI tools
      bat # A cat clone with syntax highlighting and Git integration
      btop # Resource monitor for the terminal
      difftastic # Diff tool with syntax-aware comparison
      eza # Modern replacement for 'ls' with more features
      fastfetch # Fast system information tool (like neofetch)
      fd # Simple, fast and user-friendly alternative to 'find'
      fish # User-friendly interactive shell
      fnm # Fast Node.js version manager (binary)
      fzf # Command-line fuzzy finder
      lazygit # Simple terminal UI for git commands
      inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default # Ambitious Vim-fork focused on extensibility and agility
      rclone # Command-line cloud storage sync tool
      ripgrep # Fast search tool (like grep, but better)
      starship # Minimal, customizable shell prompt
      stow # Symlink farm manager for dotfiles
      tree-sitter # CLI for Tree-sitter parsing library
      uv # Fast Python virtual environment manager
      zoxide # Smarter cd command for navigation
      zsh # Powerful shell with advanced features

      # Desktop Shell & Window manager
      adw-gtk3 # An unofficial GTK3 port of libadwaita
      cava # Console-based audio visualizer
      cliphist # Clipboard manager for Wayland
      # ly # Lightweight TUI display manager
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default # A beautiful, minimal desktop shell for wayland
      nwg-look # GTK settings editor adapted to work on wlroots-based compositors
      papirus-icon-theme # Papirus icon theme for Linux desktops
      kdePackages.qt6ct # Qt 6 Configuration Utility
      spicetify-cli # CLI to customize Spotify
      xfce.thunar # Modern, fast and easy-to-use file manager for Xfce
      xdg-desktop-portal # Desktop integration portal for sandboxed applications
      xdg-desktop-portal-gnome # GNOME portal backend for desktop integration
      xdg-desktop-portal-gtk # GTK portal backend for desktop integration
      xwayland-satellite # Run X11 applications in Wayland sessions
      wl-clipboard # Clipboard manager for Wayland
      wlsunset # Adjusts the color temperature of your screen

      # Applications
      bitwarden-desktop # Secure password manager
      libreoffice-still # Office suite (stable branch)
      portfolio # Investment portfolio tracking tool
      obsidian # Markdown-based knowledge base app
      spotify # Music streaming client
      # zen-browser-bin # Performance oriented Firefox-based web browser

      # Gaming
      # vesktop # Privacy friendly Discord client
      # gamescope # Micro-compositor for gaming (Steam Deck, etc.)
      # steam # Digital distribution platform for games
      # xpadneo-dkms # DKMS driver for Xbox One wireless gamepads
      ghostty # GPU-accelerated terminal emulator
    ]
  );

  # ++ (with pkgs-unstable; [
  # ]);

  # A scrollable-tiling Wayland compositor
  programs.niri = {
    enable = true;
    # package = pkgs-unstable.niri;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Fonts settings
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono # JetBrains Mono font with Nerd Fonts glyphs
  ];

  # Set the default editor to nvim
  environment.variables.EDITOR = "nvim";

  # Limit the number of generations to keep
  boot.loader.systemd-boot.configurationLimit = 10;
  # boot.loader.grub.configurationLimit = 10;

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Perform garbage collection weekly to maintain low disk usage
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  # Optimize storage
  # You can also manually optimize the store via:
  #    nix-store --optimise
  # Refer to the following link for more details:
  # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
  nix.settings.auto-optimise-store = true;

  # NixOS cannot run dynamically linked executables intended for generic
  # Linux environments out of the box.
  # https://nix.dev/guides/faq.html#how-to-run-non-nix-executables
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Add any missing dynamic libraries for unpackaged programs
    # here, NOT in environment.systemPackages
  ];

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
