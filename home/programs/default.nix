{ inputs, config, ... }: {
  config.programs.kitty = {
    enable = config.home.terminal == "kitty";
    extraConfig = builtins.readFile ./kitty.conf;
  };
  config._module.args = { inherit inputs; };
  imports = [
    ./spotify.nix
    ./browser.nix
    ./zellij.nix
    ./term.nix
    ./wayland
    ./nixvim
    ./texvim
  ];
}
