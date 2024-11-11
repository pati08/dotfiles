{ config, options, pkgs, inputs, ... }:
let
  inherit (pkgs) lib;
in {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home = {
    username = lib.mkDefault "patrick";
    homeDirectory = lib.mkDefault "/home/patrick";

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "23.11"; # Please read the comment before changing.
  };

  imports = [
    ./programs.nix
    ./stylix
  ];

  # _module.args = { inherit inputs; };
  # imports = [
  #   ./spotify.nix
  #   ./browser.nix
  # ];

  # allow unfree packages
  nixpkgs.config.allowUnfree = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    NIXOS_OZONE_WL = "1";
    # GI_TYPELIB_PATH = "/run/current-system/sw/lib/girepository-1.0";
  };

  # add imv desktop file
  xdg.desktopEntries = {
    imv = {
      name = "imv";
      genericName = "Image viewer";
      exec = "imv %F";
      terminal = false;
      categories = [ "Graphics" "2DGraphics" "Viewer" ];
      mimeType = [
        "image/bmp"
        "image/gif"
        "image/jpeg"
        "image/jpg"
        "image/pjpeg"
        "image/png"
        "image/tiff"
        "image/x-bmp"
        "image/x-pcx"
        "image/x-png"
        "image/x-portable-anymap"
        "image/x-portable-bitmap"
        "image/x-portable-graymap"
        "image/x-portable-pixmap"
        "image/x-tga"
        "image/x-xbitmap"
        "image/heif"
        "image/avif"
      ];
    };
  };

  # home.packages = [
  #   pkgs.libgtop
  # ];
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
