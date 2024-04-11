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
      cat = "bar";
      fuck = "thefuck $\"(history | last 1 | get command | get 0)\"";
    };
    configFile = ./funcs.nu;
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
