{ config, pkgs, inputs, ...}: {
  home.file.".config/spotify-player/app.toml".source = ./spotify-player.toml;
  programs.spotify-player.enable = true;
}
