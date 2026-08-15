# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{
  inputs,
  config,
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  # Enabling experimental features(flakes)
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable docker
  virtualisation.docker.enable = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "powerful-pc"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  networking.firewall.checkReversePath = false;
  nixpkgs.config.allowUnfree = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  services.xserver = {
    enable = true;
  };

  # optimization of nix store
  nix.optimise.automatic = true;
  nix.optimise.dates = ["daily"];

  # automatic garbage collection with the nh helper
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = " --keep 10";
    flake = "/home/vis/NixOS";
  };

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable sway
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
  # Enable Niri
  programs.niri.enable = true;
  programs.niri.package = pkgs.niri-unstable;

  # Enable gvfs and udevdisks2
  services.udisks2.enable = true;
  services.gvfs.enable = true;

  # add upower service
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  # Enable gnome keyring and polkit
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;

  # Enable flatpak
  services.flatpak.enable = true;

  # Enable libvirtd service
  virtualisation.libvirtd.enable = true;

  # Enable zram
  zramSwap.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Enable zsh
  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.vis = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = ["wheel" "networkmanager" "qemu" "kvm" "libvirtd" "disk" "input" "docker"];
    packages = with pkgs; [
      tree
    ];
  };

  # Set the environment variables
  environment.variables = {
    EDITOR = "nvim";
  };

  # programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    btop
    binutils
    fastfetch
    fzf
    git
    gnupg
    grim
    kitty
    kanata
    libvirt
    gcc
    gnumake
    mako
    pkgs-unstable.neovim
    obsidian
    qemu
    ripgrep
    slurp
    swaybg
    swaylock
    swayidle
    unzip
    virt-manager
    waybar
    wl-clipboard
    wofi
    wget
    xwayland-satellite
    zathura
    zathuraPkgs.zathura_pdf_mupdf
  ];

  # Fonts
  fonts.packages = with pkgs; [
    font-awesome
    nerd-fonts.jetbrains-mono
  ];

  # remap capslock to escape

  services.kanata = {
    enable = true;
    keyboards = {
      "logi".config = ''
        (defsrc
          caps
        )

        (deflayer colemak
           (tap-hold 200 200 esc lctl)
        )
      '';
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?
}
