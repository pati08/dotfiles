{ config, pkgs, inputs, ... }:
let
  inherit (pkgs) lib;
in {
  imports = [
    ./config.nix
  ];

  config._module.args = { inherit inputs; };
}
