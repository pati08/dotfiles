{ inputs, pkgs, ... }: {
  home.packages = with pkgs; [
    bun
    sassc
    pipewire
    networkmanager
    hyprshade
    # hyprpicker
    swww
    imagemagick
    flatpak
  ];

  imports = [ inputs.ags.homeManagerModules.default ];

  programs.ags = {
    enable = true;

    configDir = null;

    extraPackages = with pkgs; [
      gtksourceview
      webkitgtk
      accountsservice
      libgtop
    ];
  };
}
