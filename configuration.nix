# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  inputs,
  profilePath,
  hwConfigPath,
  ...
}: let
  hyprland_flake = inputs.hyprland.packages."${pkgs.system}".default;
  # tilp2 = pkgs.callPackage (import ./tilp2.nix { inherit pkgs; }).tilp {};
in {
  imports = [
    # Include the results of the hardware scan.
    # ./hardware-configuration.nix

    profilePath
    hwConfigPath
  ];

  programs.virt-manager.enable = true;
  virtualisation = {
    libvirtd.enable = true;
  };

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      data-root = "/home/patrick/docker/";
    };
  };
  users.groups.docker.members = [ "patrick" ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot.loader.systemd-boot.enable = true;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  services.blueman.enable = true;

  # didn't like the delay, but keeping it here just in case

  services.kanata = {
    enable = true;
    keyboards.all.config = builtins.readFile ./config.kbd;
  };

  nix.settings = {
    # enable hyprland's cachix
    substituters = ["https://nix-community.cachix.org" "https://hyprland.cachix.org"];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "ai.cachix.org-1:N9dzRK+alWwoKXQlnn0H6aUx0lU/mspIoz8hMvGvbbc="
    ];

    # enable flakes
    experimental-features = ["nix-command" "flakes"];
  };

  nix.settings.trusted-substituters = ["https://ai.cachix.org"];

  # optional if you use allowed-users in other places
  nix.settings.allowed-users = [ "harmonia" "patrick" ];

  networking.firewall.allowedTCPPorts = [ 443 80 ];

  services.nginx = {
    enable = true;
    package = pkgs.nginxStable.override {
      modules = [ pkgs.nginxModules.zstd ];
    };
    recommendedTlsSettings = true;
    recommendedZstdSettings = true;
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "patrick-nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager = {
    enable = true;
    wifi = {
      backend = "iwd";
      macAddress = "random";
    };
  };

  # allow swaylock to unlock
  security.pam.services.swaylock = {};


  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # use SDDM
  services.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.brlaser ];

  # Enable sound with pipewire.
  # hardware.pulseaudio.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    wireplumber.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  users.groups.wireshark = {
    # gid = 1001;
    members = [ "patrick" ];
  };

  users.users.patrick = {
    isNormalUser = true;
    description = "Patrick Oberholzer";
    extraGroups = ["networkmanager" "wheel"];
    # all in HM now
    packages = [];
    uid = 1000;
  };

  programs.bash = {
    interactiveShellInit = ''
      if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
        fi
    '';
  };

  programs.nix-ld.enable = true;

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = 
    [
      pkgs.iwd
      pkgs.pulseaudioFull
      pkgs.gcc
      pkgs.libsForQt5.qt5.qtwayland pkgs.qt5ct pkgs.libva
      pkgs.inotify-tools
      pkgs.libnotify
      pkgs.pkg-config
      pkgs.fish
      pkgs.libinput
      pkgs.lxqt.lxqt-policykit
      pkgs.sbctl

      inputs.winapps.packages."${pkgs.system}".winapps
      inputs.winapps.packages."${pkgs.system}".winapps-launcher

      pkgs.carla
      pkgs.lsp-plugins
      pkgs.zam-plugins
      pkgs.helvum
    ];

  programs.steam = {
    enable = true;
    package = with pkgs; steam.override { extraPkgs = pkgs: [ attr ]; };
  };

  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    package = hyprland_flake;
  };

  # hint electron apps to use wayland
  environment.sessionVariables = {
    # NIXOS_OZONE_WL = "1";
  };

# screen sharing
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
  };

  # fix waybar not displaying hyprland workspaces
  nixpkgs.overlays = [
    (self: super: {
     waybar = super.waybar.overrideAttrs (oldAttrs: {
         mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
         });
     })
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

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
  system.stateVersion = "23.11"; # Did you read the comment?
}
