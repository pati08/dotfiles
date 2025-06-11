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

    hyprpicker.url = "github:hyprwm/hyprpicker";
    hyprpicker.inputs.nixpkgs.follows = "nixpkgs";

    nilLs.url = "github:oxalica/nil";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    thokr.url = "github:pati08/thokr";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";

    mozOverlay.url = "github:mozilla/nixpkgs-mozilla";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay.url = "github:oxalica/rust-overlay";

    tree-sitter-rstml.url = "github:rayliwell/tree-sitter-rstml";
  };
  outputs = inputs@{ self, nixpkgs, home-manager, lanzaboote, nur, rust-overlay, ... }:
    let
      inherit (nixpkgs) lib;
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ nur.overlays.default rust-overlay.overlays.default ];
      };
    in {
      nixosConfigurations = {
        desktop = lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
            inherit system;
            profilePath = ./profiles/desktop.nix;
            hwConfigPath = ./hardware/desktop.nix;
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
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
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
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
          inputs.stylix.homeModules.stylix
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
          inputs.stylix.homeModules.stylix
        ];

      };
    };
}
