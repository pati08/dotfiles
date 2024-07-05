{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs.virt-manager.enable = true;
  virtualisation = {
    libvirtd.enable = true;
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
