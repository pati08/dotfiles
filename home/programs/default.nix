{ inputs, ... }: {
  config.programs.kitty = {
    enable = true;
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
