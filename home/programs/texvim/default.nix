{ pkgs, inputs, ... }:
let
  inherit (pkgs) system;
  nixvimPkg = inputs.nixvim.legacyPackages.${system}.makeNixvim (import ./config.nix pkgs);
  texvim =  pkgs.stdenv.mkDerivation {
    name = "texvim";
    dontUnpack = true;

    configurePhase = ''
      mkdir -p $out/bin
    '';
    installPhase = ''
      cp ${nixvimPkg}/bin/nvim $out/bin/tvim
    '';
  };
in {
  home.packages = [
    texvim
  ];
}
