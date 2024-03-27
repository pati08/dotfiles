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
  ];
  system = [
    testdisk
    gparted
    unixtools.fsck
    ntfs3g
    diskscan
    nmap
  ];
}
