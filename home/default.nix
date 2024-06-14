{ config, pkgs, inputs, ... }:
let
  inherit (pkgs) lib;
in {
  imports = [
    ./spotify.nix
    ./browser.nix
    ./config.nix
  ];

  options = {
    isGuest = lib.mkEnableOption "guest settings";
  };

  config._module.args = { inherit inputs; };
}
