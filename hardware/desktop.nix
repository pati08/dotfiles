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
  networking.nameservers = [ "8.8.8.8" ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    # driSupport = true;
    enable32Bit = true;
    # extraPackages = with pkgs; [
    #   amdvlk
    # ];
    # extraPackages32 = with pkgs; [
    #   driversi686Linux.amdvlk
    # ];
  };

  boot.initrd.kernelModules = [ "amdgpu" ];

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "amdgpu" ]; # or "nvidiaLegacy470 etc.

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  boot.kernelParams = [
    "video=DP-3:2560x1440@144"
    "video=HDMI-A-1:1920x1080@60"
    # "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    # "nvidia-drm.fbdev=1"
  ];

  # hardware.nvidia = {
  #   # Modesetting is required.
  #   modesetting.enable = true;
  #
  #   # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
  #   # Enable this if you have graphical corruption issues or application crashes after waking
  #   # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
  #   # of just the bare essentials.
  #   powerManagement.enable = true;
  #
  #   # Fine-grained power management. Turns off GPU when not in use.
  #   # Experimental and only works on modern Nvidia GPUs (Turing or newer).
  #   powerManagement.finegrained = false;
  #
  #   # Use the NVidia open source kernel module (not to be confused with the
  #   # independent third-party "nouveau" open source driver).
  #   # Support is limited to the Turing and later architectures. Full list of
  #   # supported GPUs is at:
  #   # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
  #   # Only available from driver 515.43.04+
  #   # Currently alpha-quality/buggy, so false is currently the recommended setting.
  #   open = false;
  #
  #   # Enable the Nvidia settings menu,
  #   # accessible via `nvidia-settings`.
  #   nvidiaSettings = false;
  #
  #   # Optionally, you may need to select the appropriate driver version for your specific GPU.
  #   #package = config.boot.kernelPackages.nvidiaPackages.production;
  #   package = config.boot.kernelPackages.nvidiaPackages.latest;
  #   # package = pkgs.linuxKernel.packages.linux_6_1.nvidia_x11;
  #
  #   # prime = {
  #   #   offload.enable = true;
  #   #
  #   #   nvidiaBusId = "PCI:1:0:0";
  #   #   intelBusId = "PCI:0:1:0";
  #   # };
  # };
}
