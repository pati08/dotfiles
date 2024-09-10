{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  programs.virt-manager.enable = true;
  virtualisation = {
    libvirtd.enable = true;
    docker = {
      enable = true;
      daemon.settings = {
        data-root = "/home/patrick/docker/";
      };
    };
  };

  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };

  services.harmonia.enable = true;
  services.harmonia.signKeyPath = /var/lib/secrets/harmonia.secret;
  # Example using sops-nix to store the signing key
  #services.harmonia.signKeyPaths = [ config.sops.secrets.harmonia-key.path ];
  #sops.secrets.harmonia-key = { };

  security.acme.defaults.email = "mail@poberholzer.com";
  security.acme.acceptTerms = true;
  services.nginx.virtualHosts."nix-cache.poberholzer.com" = {
    enableACME = true;
    forceSSL = true;
    locations."/".extraConfig = ''
      proxy_pass http://127.0.0.1:5000;
      proxy_set_header Host $host;
      proxy_redirect http:// https://;
      proxy_http_version 1.1;
      proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection $connection_upgrade;

      zstd on;
      zstd_types application/x-nix-archive;
    '';
  };

  # users.users.patrick.groups = [ "docker" ];
  users.groups.docker.members = [ "patrick" ];

  nixpkgs.config.cudaSupport = true;

  services.hardware.openrgb.enable = true;

  environment.systemPackages = with pkgs; [
    testdisk
    gparted
    unixtools.fsck
    ntfs3g
    diskscan
    cudatoolkit
    waydroid
    # blender
  ];
}
