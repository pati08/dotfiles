{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  # users.users.patrick.groups = [ "docker" ];

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
