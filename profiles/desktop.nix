{ config
, pkgs
, lib
, inputs
, ...
}: {
  services.hardware.openrgb.enable = true;

  environment.systemPackages = with pkgs; [
    testdisk
    gparted
    unixtools.fsck
    ntfs3g
    diskscan
    cudatoolkit
    waydroid
    # blender
  ];

  # services.ollama.acceleration = "rocm";
}
