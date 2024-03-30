{
  description = "My first flake!";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    unstable.url = "nixpkgs/nixos-unstable";
    hypridle.url = "github:hyprwm/hypridle";
    # wez.url = "github:wez/wezterm?dir=nix";
  };
  outputs = inputs@{ self, nixpkgs, unstable, ... }:
    let
      lib = nixpkgs.lib;
    in {
    nixosConfigurations = {
      patrick-nixos = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./configuration.nix
        ];
      };
    };
  };
}
