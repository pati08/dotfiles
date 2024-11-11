{ config, pkgs, inputs, ...}: {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;

    luaLoader.enable = true;
  };

  imports = [
    ./config
    inputs.nixvim.homeManagerModules.nixvim
  ];
}
