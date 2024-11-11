{ pkgs, ... }:
let
  wallpaper_path = "/home/patrick/dotfiles/wallpaper.png";
in {
  services.hyprpaper = {
    enable = true;
    # settings = {
    #   preload = wallpaper_path;
    #   wallpaper = ",${wallpaper_path}";
    # };
  };
}
