{
  config,
  pkgs,
  inputs,
  ...
}: let
  keyboard = "at-translated-set-2-keyboard";
in {
  _module.args = { inherit inputs; };
  imports = [
    ../term.nix
    ../nixvim
    ../kitty
  ];

  config.isGuest = true;
}
