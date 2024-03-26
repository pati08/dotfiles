pkgs:
with pkgs; {
  user = [
    steam
    blender
    krita
    discord
    prismlauncher
    ffmpeg
    tor-browser
    brave
  ];
  system = [
    testdisk
    gparted
    unixtools.fsck
    ntfs3g
    diskscan
  ];
}
