{
  config,
  pkgs,
  inputs,
  ...
}:
let
  suspendScript = pkgs.writeShellScript "suspend-script" ''
    ${pkgs.pipewire}/bin/pw-cli i all 2>&1 | ${pkgs.ripgrep}/bin/rg running -q
    # don't suspend if audio is playing
    if [ $? == 1 ]; then
      ${pkgs.systemd}/bin/systemctl suspend
    fi
  '';
in {

  imports = [
    ../wayland
    ../term.nix
    ../neovim.nix
    ../kitty
  ];

  wayland.hyprland.enableBlur = true;

  home.packages = with pkgs; [
    steam
    blender
    discord
    prismlauncher
    darktable
    godot_4
  ];

  wayland.windowManager.hyprland.settings.env = [
    "LIBVA_DRIVER_NAME,nvidia"
    "XDG_SESSION_TYPE,wayland"
    "GBM_BACKEND,nvidia-drm"
    "__GLX_VENDOR_LIBRARY_NAME,nvidia"
    "WLR_NO_HARDWARE_CURSORS,1"
  ];

  home.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  services.hypridle.listeners = [
    {
      timeout = 1800; # 30 minutes
      onTimeout = suspendScript.outPath;
    }
  ];
}
