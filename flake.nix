{
  description = "My NixOS and home-manager configurations";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprland stuff
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hypridle.url = "github:hyprwm/hypridle";
    # hyprlock.url = "github:hyprwm/hyprlock"; # switched to swaylock
    hyprpicker.url = "github:hyprwm/hyprpicker";
    hyprpicker.inputs.nixpkgs.follows = "nixpkgs";

    nilLs.url = "github:oxalica/nil";

    waybar = {
      url = "github:Alexays/Waybar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, nixpkgs, home-manager, hyprland, ... }:
    let
    lib = nixpkgs.lib;
  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
  in {
    nixosConfigurations = {
      desktop = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          inherit system;
          profilePath = ./profiles/desktop.nix;
          hwConfigPath = ./hardware/desktop.nix;
        };
        modules = [
          ./configuration.nix
        ];
      };
      laptop = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          inherit system;
          profilePath = ./profiles/laptop.nix;
          hwConfigPath = ./hardware/laptop.nix;
        };
        modules = [
          ./configuration.nix
        ];
      };
    };
    homeConfigurations."desktop" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      extraSpecialArgs = { 
        inherit inputs;
        profilePath = ./home/profiles/desktop.nix;
      };

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [
        # hyprland.homeManagerModules.default
        ./home
      ];

    # Optionally use extraSpecialArgs
    # to pass through arguments to home.nix
    };
    homeConfigurations."laptop" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      extraSpecialArgs = {
        inherit inputs;
        profilePath = ./home/profiles/laptop.nix;
      };

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [
        # hyprland.homeManagerModules.default
        ./home
      ];

    # Optionally use extraSpecialArgs
    # to pass through arguments to home.nix
    };
  };
}
