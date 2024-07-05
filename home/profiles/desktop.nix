{
  config,
  pkgs,
  inputs,
  ...
}:
let
  keyboard = "keychron-keychron-c3-pro-keyboard";
  toggleScript = pkgs.writeShellScript "toggle_script" ''
    ${(import ../scripts/toggleGameMode.nix pkgs).outPath}
    hyprctl switchxkblayout ${keyboard} next
  '';
  suspendScript = pkgs.writeShellScript "suspend-script" ''
    ${pkgs.pipewire}/bin/pw-cli i all 2>&1 | ${pkgs.ripgrep}/bin/rg running -q
    # don't suspend if audio is playing
    if [ $? == 1 ]; then
      ${pkgs.systemd}/bin/systemctl suspend
    fi
  '';
in {
  _module.args = { inherit inputs; };
  imports = [
    ../wayland
    ../term.nix
    ../nixvim
    ../kitty
  ];

  wayland.hyprland.enableBlur = true;

  home.packages = with pkgs; [
    steam
    # blender
    discord
    prismlauncher
    darktable
    cassowary
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

  services.hypridle.settings.listener = [
    {
      timeout = 1800; # 30 minutes
      on_timeout = suspendScript.outPath;
    }
  ];

  wayland.windowManager.hyprland.settings.monitor = [
    "DP-1,preferred,0x0,1"
    "Unknown-1,disable"
  ];

  programs.waybar.settings.mainBar."hyprland/language"."on-click"
    = "hyprctl switchxkblayout ${keyboard} next";

  programs.waybar.settings.mainBar."hyprland/language"."keyboard-name" = "${keyboard}";
  wayland.windowManager.hyprland.settings.bind = ["$mod, T, exec, ${(import ../scripts/toggleGameMode.nix pkgs keyboard).outPath}"];
}
