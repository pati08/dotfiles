{ pkgs, ... }: {
  stylix = {
    enable = true;
    image = ../../wallpaper.jpg;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    targets = {
      zellij.enable = false;
      waybar.enable = false;
      firefox.profileNames = [ "personal-profile" "school-profile" ];
      firefox.colorTheme.enable = true;
      nixvim.enable = false;
    };
    polarity = "dark";
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };
  };
}
