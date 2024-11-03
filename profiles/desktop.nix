{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  programs.virt-manager.enable = true;
  virtualisation = {
    libvirtd.enable = true;
    docker = {
      enable = true;
      daemon.settings = {
        data-root = "/home/patrick/docker/";
      };
    };
  };

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  # users.users.patrick.groups = [ "docker" ];
  users.groups.docker.members = [ "patrick" ];

  nixpkgs.config.cudaSupport = true;

  services.hardware.openrgb.enable = true;

  environment.systemPackages = with pkgs; [
    docker-compose
    testdisk
    gparted
    unixtools.fsck
    ntfs3g
    diskscan
    cudatoolkit
    waydroid
    # blender
  ];
}
