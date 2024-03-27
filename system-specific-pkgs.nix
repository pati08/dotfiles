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
    qt5-wayland
    qt5ct
    libva
    libva-nvidia-driver-git
  ];
}
