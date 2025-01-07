{
  config,
  pkgs,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    stunnel
  ];

  services.logind.powerKey = "ignore";
}
