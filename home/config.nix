{ config, options, pkgs, inputs, ... }:
let
  inherit (pkgs) lib;
in {
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home = {
    username = lib.mkDefault "patrick";
    homeDirectory = "/home/patrick";

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

    # misc (temp)
    wget
    gh
    
    # volume, brightness, and player controls
    pamixer
    playerctl
    brightnessctl

    (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono"];})
  ] ++ (if (!config.isGuest) then [
    # applications
    obsidian
    celluloid
    godot_4
    libreoffice
    prusa-slicer
    dissent # discord
    discordo # discord tui
    gimp
    aseprite
    blender

    # misc (temp)
    postgresql
    marksman
    nodejs
    networkmanagerapplet
  ] else []);

  home.sessionVariables = {
    EDITOR = "nvim";
    NIXOS_OZONE_WL = "1";
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
