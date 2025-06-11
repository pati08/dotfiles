{ config, pkgs, inputs, ... }:
let
  inherit (pkgs) lib;
in {
  imports = [
    ./config.nix
  ];

  config._module.args = { inherit inputs; };

  options.home.terminal = lib.mkOption {
    type = lib.types.enum [ "kitty" "wezterm" ];
    default = "kitty";
    example = "kitty";
    description = ''
      User's terminal
    '';
  };
}
