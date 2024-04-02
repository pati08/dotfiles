{
  config,
  pkgs,
  inputs,
  ...
}: {
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  environment.systemPackages = with pkgs; [
    testdisk
    gparted
    unixtools.fsck
    ntfs3g
    diskscan
  ];
}
