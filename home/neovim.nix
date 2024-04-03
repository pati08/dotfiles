{ config, pkgs, inputs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  home.file = {
    # ".config/nvim".source = ../homeless/nvim;
    ".config/nvim/after".source = ../homeless/nvim/after;
    ".config/nvim/init.lua".source = ../homeless/nvim/init.lua;
    ".config/nvim/lua".source = ../homeless/nvim/lua;
    ".config/nvim/lazy-lock.json".source =
      config.lib.file.mkOutOfStoreSymlink ../homeless/nvim/lazy-lock.json;
    ".config/nvim/spell".source =
      config.lib.file.mkOutOfStoreSymlink ../homeless/nvim/spell;
  };
}

# after  init.lua  lazy-lock.json  lua  spell
