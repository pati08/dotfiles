{ config
, pkgs
, inputs
, ...
}: {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;

    luaLoader.enable = true;
  };

  home.sessionVariables = {
    LUASNIP_SNIPPETS_DIRS = "${config.home.homeDirectory}/.luasnip-snippets";
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
