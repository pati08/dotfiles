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
    functions = {
      hm-switch = ''
        if not set -q argv[1]
          echo "Argument required"
          return 1
        end

        pushd ~/dotfiles
        home-manager switch --flake .#$argv
        popd
      '';
      os-switch = ''
        if not set -q argv[1]
          echo "Argument required"
          return 1
        end

        pushd ~/dotfiles
        sudo nixos-rebuild switch --flake .#$argv
        popd
      '';
    };
  };
}
