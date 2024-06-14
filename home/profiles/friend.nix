{
  config,
  options,
  pkgs,
  inputs,
  ...
}: let
  keyboard = "at-translated-set-2-keyboard";
in {
  imports = [
    ../term.nix
    ../nixvim
    ../kitty
  ];

  config = {
    _module.args = { inherit inputs; };
    isGuest = true;

    home = {
      username = "friend";
      homeDirectory = "/home/friend";
    };
  };

}
