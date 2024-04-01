{
  config,
  pkgs,
  ...
}: {
  # Enable the fish shell
  programs.fish = {
    enable = true;
    shellInit = ''
      starship init fish | source
      direnv hook fish | source
      thefuck --alias | source
      '';
    shellAliases = {
      ls = "lsd";
      cat = "bat";
    };
  };
}
