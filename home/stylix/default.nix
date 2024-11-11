{ pkgs, ... }: {
  stylix = {
    enable = true;
    image = ../../wallpaper.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/rose-pine.yaml";
    # base16Scheme = ./colors.yaml;
    targets.zellij.enable = false;
  };
}
