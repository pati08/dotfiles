{ config, pkgs, inputs, ...}: {
  # home.file.".config/spotify-player/app.toml".source = ./spotify-player.toml;
  # programs.ncspot.enable = true;
  imports = [
    inputs.spicetify-nix.homeManagerModules.default
  ];
  programs.spicetify = let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  in {
    enable = true;
    # theme = spicePkgs.themes.catppuccin;
    # colorScheme = "mocha";
    enabledExtensions = with spicePkgs.extensions; [
      hidePodcasts
      shuffle
    ];
  };
}
