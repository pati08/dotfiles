{ config, pkgs, inputs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # just directy symlinking for now b/c of issues
  # home.file = {
    # ".config/nvim".source =
      # config.lib.file.mkOutOfStoreSymlink
        # /home/patrick/dotfiles/homeless/nvim;

    # ".config/nvim/after".source = ../homeless/nvim/after;
    # ".config/nvim/init.lua".source = ../homeless/nvim/init.lua;
    # ".config/nvim/lua".source = ../homeless/nvim/lua;
    # ".config/nvim/lazy-lock.json".source =
    #   config.lib.file.mkOutOfStoreSymlink
    #     "${config.home.homeDirectory}/dotfiles/homeless/nvim/lazy-lock.json";
    #
    # ".config/nvim/spell".source =
    #   config.lib.file.mkOutOfStoreSymlink
    #     "${config.home.homeDirectory}/dotfiles/homeless/nvim/spell";
  # };
}

# after  init.lua  lazy-lock.json  lua  spell
