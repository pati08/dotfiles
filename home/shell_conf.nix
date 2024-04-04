{
  config,
  pkgs,
  ...
}: {
  # Enable the fish shell
  programs.fish = {
    enable = true;
    shellInit = ""; # empty for now
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

  programs.direnv = {
    enable = true;
    # enableFishIntegration = true;
  };

  programs.thefuck = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };
}
