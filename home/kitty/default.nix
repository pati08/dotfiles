{ config, pkgs, inputs, ... }: {
  home.file.".config/kitty/kitty.conf".source = ./kitty.conf;
}
