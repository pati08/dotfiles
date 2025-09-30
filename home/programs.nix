{ pkgs, ... }:
let
  ffSchool = { pkgs ? import <nixpkgs> { } }:
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
  cursor = pkgs.stdenv.mkDerivation rec {
    pname = "cursor";
    version = "0.45.7"; # example version

    src = pkgs.fetchurl {
      url = "https://downloads.cursor.com/production/b753cece5c67c47cb5637199a5a5de2b7100c18f/linux/x64/Cursor-1.6.35-x86_64.AppImage";
      sha256 = "sha256-62u8snx9nbJtsg7uROZNVzo3macrkTghTCep943e8+I=";
    };

    nativeBuildInputs = [ pkgs.appimage-run ];

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out/bin
      cp $src $out/cursor.AppImage
      chmod +x $out/cursor.AppImage

      # launcher wrapper
      cat > $out/bin/cursor <<EOF
      #!${pkgs.bash}/bin/bash
      exec ${pkgs.appimage-run}/bin/appimage-run $out/cursor.AppImage "\$@"
      EOF
      chmod +x $out/bin/cursor

      # desktop entry
      mkdir -p $out/share/applications
      cat > $out/share/applications/cursor.desktop <<EOF
      [Desktop Entry]
      Name=Cursor
      Comment=AI-powered code editor
      Exec=$out/bin/cursor %U
      Terminal=false
      Type=Application
      Icon=cursor
      Categories=Development;IDE;
      EOF
    '';

    meta = with pkgs.lib; {
      description = "Cursor Code editor packaged via AppImage";
      homepage = "https://cursor.sh/";
      license = licenses.unfree; # adjust if needed
      platforms = [ "x86_64-linux" ];
      mainProgram = "cursor";
    };
  };
  cursor-agent = pkgs.stdenv.mkDerivation {
    pname = "cursor-agent";
    version = "2025.09.18-7ae6800";

    src = pkgs.fetchurl {
      url = "https://downloads.cursor.com/lab/2025.09.18-7ae6800/linux/x64/agent-cli-package.tar.gz";
      sha256 = "sha256-t+p5+vfLdwww6CBo2FbH/4u19TG7mxU5Ob2+lcceek0=";
    };

    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = [
      pkgs.stdenv.cc.cc.lib
      pkgs.glibc
    ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      cp -r * $out/
      ln -s $out/cursor-agent $out/bin/cursor-agent
      runHook postInstall
    '';
  };
in
{
  home.packages = with pkgs; [
    # applications
    (obsidian.overrideAttrs (_oldAttrs: { buildInputs = [ pkgs.d2 ]; }))
    celluloid
    godot_4
    libreoffice
    prusa-slicer
    gimp
    blender-hip
    sidequest
    lumafly # hollow knight modding
    vesktop # discord replacement that doesn't suck on linux
    imv
    ghostscript # Inkscape with .EPS support
    todoist
    todoist-electron
    cursor
    cursor-agent
    f4c7
    (printing and some other stuff i think)

    # misc (temp)
    wget
    gh
    postgresql_16
    marksman
    nodejs
    networkmanagerapplet

    # Printer management and utilities
    system-config-printer
    cups
    cups-filters
    ghostscript
    hplip
    gutenprint

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

    (pkgs.callPackage ffSchool { })

    zulu
    fhsZulu8
    # with the installation of java 21

    lutris

    vscode

    jq
    networkmanager
    bluez-experimental
    playerctl

    (rust-bin.nightly.latest.default.override {
      extensions = [ "rust-src" "rustfmt" "clippy" "rust-docs" "rust-analyzer" ];
      targets = [ "x86_64-unknown-linux-gnu" "wasm32-unknown-unknown" ];
    })

    zathura
    lldb
  ];
}
