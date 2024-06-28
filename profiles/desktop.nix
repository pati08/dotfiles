{
  config,
  pkgs,
  inputs,
  ...
}: {
  # virtualisation.libvirtd.enable = true;
  # programs.virt-manager.enable = true;
  virtualisation = {
    waydroid.enable = true;
  };

  nixpkgs.config.cudaSupport = true;

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
}
