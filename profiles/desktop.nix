{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
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
