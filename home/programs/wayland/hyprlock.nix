{
  config,
  pkgs,
  ...
}: {
  programs.hyprlock.enable = true;

  programs.hyprlock.settings = {
    # input-field = [
    #   {
    #     monitor = "";
    #     size = "200, 50";
    #     outline_thickness = 3;
    #     dots_size = 0.33;
    #     dots_spacing = 0.15;
    #     dots_center = false;
    #     dots_rounding = -1;
    #     outer_color = "rgb(151515)";
    #     inner_color = "rgb(200, 200, 200)";
    #     font_color = "rgb(10, 10, 10)";
    #     fade_on_empty = false;
    #     fade_timeout = 1000;
    #     placeholder_text = "<i>Input Password...</i>";
    #     hide_input = false;
    #     rounding = -0.5;
    #     check_color = "rgb(204, 136, 34)";
    #     fail_color = "rgb(204, 34, 34)";
    #     fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
    #     fail_transition = 300;
    #     capslock_color = "rgb(45, 70, 230)";
    #     numlock_color = -1;
    #     bothlock_color = -1;
    #     invert_numlock = false;
    #     swap_font_color = false;
    #
    #     position = "0, -20";
    #     halign = "center";
    #     valign = "center";
    #   }
    # ];
    label = [
      {
        monitor = "";
        text = "Hi there, $USER";
        color = "rgb(200, 200, 200)";
        font_size = 25;
        font_family = "Noto Sans";
        rotate = 0;

        position = "0, 80";
        halign = "center";
        valign = "center";
      }
    ];
    # background = [
    #   {
    #     monitor = "";
    #     color = "rgba(25, 20, 20, 1.0)";
    #
    #     # all these options are taken from hyprland, see https://wiki.hyprland.org/Configuring/Variables/#blur for explanations
    #     blur_passes = 0;
    #     blur_size = 20;
    #     noise = 0.0117;
    #     contrast = 0.8916;
    #     brightness = 0.8172;
    #     vibrancy = 0.1696;
    #     vibrancy_darkness = 0.0;
    #   }
    # ];
  };
}
