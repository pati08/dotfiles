{ config, pkgs, inputs, ...}: {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;

    luaLoader.enable = true;
  };

  imports = [
    {
      programs.nixvim = inputs.tree-sitter-rstml.nixvimModule {
        config = config.programs.nixvim;
        inherit pkgs;
      };
    }
    ./config
    inputs.nixvim.homeManagerModules.nixvim
  ];
}
