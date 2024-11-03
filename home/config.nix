{ config, options, pkgs, inputs, ... }:
let
  inherit (pkgs) lib;
  ffSchool = { pkgs ? import <nixpkgs> {} }:
    pkgs.stdenv.mkDerivation {
      pname = "firefox-school";
      version = "1.0";

      # The main package you want to wrap
      nativeBuildInputs = [ pkgs.firefox ];

      # Create a bin directory with your wrapper script
      buildInputs = [ pkgs.makeWrapper ];

      buildPhase = ''
        mkdir -p $out/bin
        # wrapProgram ${pkgs.firefox}/bin/firefox --add-flags "-P School"
        cp ${pkgs.firefox}/bin/firefox $out/bin/firefox-original
        wrapProgram $out/bin/firefox-original --add-flags "-P School"
        ln -s $out/bin/firefox-original $out/bin/firefox
      '';

      src = builtins.filterSource (path: type: false) ./.;
      # unpackPhase = "true";

      installPhase = ''
        mkdir -p $out/share/applications
        cat > $out/share/applications/firefox-rofi.desktop <<EOF
        [Desktop Entry]
        Version=1.0
        Name=Firefox (School)
        Exec=$out/bin/firefox
        Icon=firefox
        Terminal=false
        Type=Application
        Categories=Network;WebBrowser;
        EOF
      '';
    };
    fhsZulu8 = pkgs.buildFHSUserEnv {
      name = "zulu8-env";
      targetPkgs = pkgs: [ pkgs.zulu8 ];
    };
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

  # _module.args = { inherit inputs; };
  # imports = [
  #   ./spotify.nix
  #   ./browser.nix
  # ];

  # allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # applications
    spotify
    (obsidian.overrideAttrs (_oldAttrs: { buildInputs = [pkgs.d2]; }))
    celluloid
    godot_4
    libreoffice
    prusa-slicer
    dissent # discord
    discordo # discord tui
    gimp
    aseprite
    blender
    sidequest
    lumafly # hollow knight modding
    vesktop # discord replacement that doesn't suck on linux
    # vscode
    imv
    # Inkscape with .EPS support
    (inkscape.overrideAttrs (oldAttrs: { buildInputs = oldAttrs.buildInputs ++ [pkgs.ghostscript]; }))
    ghostscript

    # misc (temp)
    wget
    gh
    postgresql_16
    marksman
    nodejs
    networkmanagerapplet
    
    # volume, brightness, and player controls
    pamixer
    playerctl
    brightnessctl

    (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono"];})

    # openjdk8-bootstrap

    (pkgs.callPackage ffSchool {})

    zulu
    fhsZulu8
                           # with the installation of java 21
  ];
  home.sessionVariables = {
    EDITOR = "nvim";
    NIXOS_OZONE_WL = "1";
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
