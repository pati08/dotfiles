{ pkgs, ... }:
let
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
  fhsZulu8 = pkgs.buildFHSEnv {
    name = "zulu8-env";
    targetPkgs = pkgs: [ pkgs.zulu8 ];
  };
in {
  home.packages = with pkgs; [
    # applications
    spotify
    (obsidian.overrideAttrs (_oldAttrs: { buildInputs = [pkgs.d2]; })) celluloid
    godot_4
    libreoffice
    prusa-slicer
    gimp
    blender
    sidequest
    lumafly # hollow knight modding
    vesktop # discord replacement that doesn't suck on linux
    # vscode
    imv
    # Inkscape with .EPS support
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

    # fonts
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.dejavu-sans-mono
    dejavu_fonts

    # openjdk8-bootstrap

    (pkgs.callPackage ffSchool {})

    zulu
    fhsZulu8
    # with the installation of java 21

    lutris

    vscode
    
    jq
    networkmanager
    bluez-experimental
    playerctl
  ];
}
