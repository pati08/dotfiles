{
  description = "My first flake!";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    unstable.url = "nixpkgs/nixos-unstable";
    wez.url = "github:wez/wezterm?dir=nix";
    # wez = {
    #   url = "github:wez/wezterm/tree/main/nix";
    # }
  };
  outputs = inputs@{ self, nixpkgs, unstable, ... }:
    let
      lib = nixpkgs.lib;
    in {
    nixosConfigurations = {
      patrick-nixos = lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./configuration.nix
        ];
      };
    };
  };
}
