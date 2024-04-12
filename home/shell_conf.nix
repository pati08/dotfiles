{
  config,
  pkgs,
  ...
}: {
  # Use nushell
  programs.nushell = {
    enable = true;
    shellAliases = {
      ls = "lsd";
      ll = "lsd -l";
    };
    extraConfig = builtins.readFile ./funcs.nu;
  };

  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
  };
}
