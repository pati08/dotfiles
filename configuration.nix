{ pkgs
, inputs
, profilePath
, hwConfigPath
, ...
}:
let
  hyprlandFlake = inputs.hyprland.packages."${pkgs.system}".default;
in
{
  imports = [
    profilePath
    hwConfigPath
  ];
  programs = {
    virt-manager.enable = true;
    nix-ld.enable = true;
    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
    steam = {
      enable = true;
      package = with pkgs; steam.override { extraPkgs = pkgs: [ attr ]; };
    };
    hyprland = {
      enable = true;
      xwayland.enable = true;
      package = hyprlandFlake;
    };
    fish.enable = true;
    adb.enable = true;
  };
  services = {
    joycond.enable = true;
    blueman.enable = true;
    ollama.enable = true;
    kanata = {
      enable = true;
      keyboards.all.config = builtins.readFile ./config.kbd;
    };
    nginx = {
      enable = true;
      package = pkgs.nginxStable.override {
        modules = [ pkgs.nginxModules.zstd ];
      };
      recommendedTlsSettings = true;
      recommendedZstdSettings = true;
    };
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
    };
    displayManager.sddm.enable = true;
    printing = {
      enable = true;
      drivers = [ pkgs.brlaser ];
    };
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
    pipewire = {
      enable = true;
      wireplumber.enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    libinput.enable = true;
    dbus.enable = true;
    openssh.enable = true;
  };
  virtualisation = {
    libvirtd.enable = true;
    docker = {
      enable = true;
      daemon.settings = {
        data-root = "/home/patrick/docker/";
      };
    };
  };
  users = {
    groups = {
      docker.members = [ "patrick" ];
      wireshark.members = [ "patrick" ];
      kvm.members = [ "patrick" ];
      adbusers.members = [ "patrick" ];
    };
    users.patrick = {
      isNormalUser = true;
      description = "Patrick Oberholzer";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = [ ];
      uid = 1000;
      shell = pkgs.fish;
    };
    defaultUserShell = pkgs.fish;
  };
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.dejavu-sans-mono
    font-awesome_5
  ];
  nix.settings = {
    # enable hyprland's cachix
    substituters = [ "https://nix-community.cachix.org" "https://hyprland.cachix.org" ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];

    # enable flakes
    experimental-features = [ "nix-command" "flakes" ];
    allowed-users = [ "harmonia" "patrick" ];
  };
  networking = {
    hostName = "patrick-nixos";
    firewall.allowedTCPPorts = [ 443 80 ];
    networkmanager = {
      enable = true;
      wifi = {
        backend = "iwd";
        macAddress = "random";
      };
    };
    extraHosts = ''
      127.0.0.1 www.crossbeamdata.bob
    '';
  };
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];
  security = {
    rtkit.enable = true;
    pam.services.swaylock = { };
  };
  time.timeZone = "America/New_York";
  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
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
  };
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (self: super: {
        waybar = super.waybar.overrideAttrs (oldAttrs: {
          mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
        });
      })
    ];
  };

  environment.systemPackages = with pkgs; [
    iwd
    pulseaudioFull
    gcc
    libsForQt5.qt5.qtwayland
    libsForQt5.qt5ct
    libva
    inotify-tools
    libnotify
    pkg-config
    fish
    libinput
    lxqt.lxqt-policykit
    sbctl
    openssl
    openssl.dev
  ];
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  system.stateVersion = "23.11";
}
