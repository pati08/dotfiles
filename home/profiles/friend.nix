{
  config,
  options,
  pkgs,
  inputs,
  ...
}: {
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
