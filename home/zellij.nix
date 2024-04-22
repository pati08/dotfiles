{ pkgs, lib, ... }:
let
  zellij = pkgs.zellij;
in
{
  programs.zellij.enable = true;

  home.file.".config/zellij/config.kdl".source = ./zellij.kdl;
}
