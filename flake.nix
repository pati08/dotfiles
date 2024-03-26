{
  description = "My first flake!";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    unstable.url = "nixos/nixos-unstable";
  };
  outputs = { self, nixpkgs, unstable, ... }:
    let
      lib = nixpkgs.lib;
    in {
    nixosConfigurations = {
      patrick-computer = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
        ];
      };
    };
  };
}
