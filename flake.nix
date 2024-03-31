{
  description = "My NixOS and home-manager configurations";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprland stuff
    hyprland.url = "github:hyprwm/Hyprland";
    hypridle.url = "github:hyprwm/hypridle";
    hyprlock.url = "github:hyprwm/hyprlock";

  };
  outputs = inputs@{ self, nixpkgs, home-manager, hyprland, ... }:
    let
    lib = nixpkgs.lib;
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      patrick-nixos = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; inherit system; };
        modules = [
          ./configuration.nix
        ];
      };
    };
    homeConfigurations."patrick" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [
        hyprland.homeManagerModules.default
        {wayland.windowManager.hyprland.enable = true;}
        ./home
      ];

    # Optionally use extraSpecialArgs
    # to pass through arguments to home.nix
    };
  };
}
