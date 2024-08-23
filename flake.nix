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

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    thokr.url = "github:pati08/thokr";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = inputs@{ self, nixpkgs, home-manager, hyprland, lanzaboote, ... }:
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
          lanzaboote.nixosModules.lanzaboote
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
      };

      modules = [
        # hyprland.homeManagerModules.default
        ./home
        ./home/profiles/desktop.nix
      ];

    };
    homeConfigurations."laptop" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      extraSpecialArgs = {
        inherit inputs;
      };

      modules = [
        # hyprland.homeManagerModules.default
        ./home
        ./home/profiles/laptop.nix
      ];

    };

    homeConfigurations."friend" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      extraSpecialArgs = {
        inherit inputs;
      };

      modules = [
        # hyprland.homeManagerModules.default
        ./home
        ./home/profiles/friend.nix
      ];

    };
  };
}
