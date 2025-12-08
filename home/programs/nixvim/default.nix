{ config
, pkgs
, inputs
, lib
, ...
}:
let
  # Use the wrapped nvim from nixvim
  baseNvim = inputs.nixvim.legacyPackages.${pkgs.system}.makeNixvimWithModule {
    inherit pkgs;
    module = {
      imports = [
        ./config
      ];
    };
  };
in
{
  home.sessionVariables = {
    LUASNIP_SNIPPETS_DIRS = "${config.home.homeDirectory}/.luasnip-snippets";
    EDITOR = "nvim";
  };

  home.packages = [
    (
      pkgs.stdenv.mkDerivation
        {
          name = "nvim-no-rust-analyzer";
          buildInputs = [ pkgs.coreutils ];

          dontUnpack = true;

          installPhase = ''
            mkdir -p $out/bin

            # Remove any lines in the nixvim wrapper that add rust-analyzer to PATH
            sed '/rust-analyzer/d' ${baseNvim}/bin/nvim > $out/bin/nvim

            chmod +x $out/bin/nvim
          '';
        }
    )
  ];
}
