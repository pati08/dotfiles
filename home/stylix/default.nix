{ pkgs, ... }: {
  stylix = {
    enable = true;
    image = ../../wallpaper.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    targets = {
      zellij.enable = false;
      waybar.enable = false;
    };
    polarity = "dark";
  };
}
