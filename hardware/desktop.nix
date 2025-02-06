# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/05362d2b-e709-42e8-a30e-cdfae695f0f2";
    fsType = "ext4";
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/e8afcd71-b8c9-4ac0-9504-5cb1e763ebf4";
    fsType = "ext4";
    neededForBoot = true;
    options = [ "noatime" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/13BE-E134";
    fsType = "vfat";
  };
  fileSystems."/home/patrick" = {
    device = "/dev/disk/by-label/nixos-home";
    fsType = "ext4";
  };

  swapDevices = [];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  # networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno2.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;
  # networking =  {
  #   interfaces = {
  #     wlo1.ipv4.addresses = [{
	 #    address = "192.168.1.200";
	 #    prefixLength = 32;
  #     }];
  #   };
  #   defaultGateway4 = {
  #       address = "192.168.1.1";
  #       interface = "wlo1";
  #   };
  # };
  networking.interfaces.wlan0.ipv4.addresses = [ {
      address = "192.168.1.200";
      prefixLength = 24;
  } ];
  networking.defaultGateway = "192.168.1.1";
  networking.nameservers = [ "1.1.1.1" "9.9.9.9" ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  boot.initrd.kernelModules = [ "amdgpu" ];

  # Load amd driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "amdgpu" ]; # or "nvidiaLegacy470 etc.

  # systemd.tmpfiles.rules = [
  #   "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  # ];

  boot.kernelParams = [
    "video=DP-3:2560x1440@144"
    "video=HDMI-A-1:1920x1080@60"
  ];
}
