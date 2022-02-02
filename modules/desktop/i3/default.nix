{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.desktop;
in {
  config = mkIf (cfg.active == "i3") {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      brightnessctl
      flameshot
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      (rofi.override { plugins = [ rofi-emoji rofi-calc rofi-power-menu ]; })
      playerctl
    ];

    services = {
      dunst = {
        enable = true;
        configFile = ./config/dunst/dunstrc;
      };

      network-manager-applet.enable = true;

      picom.enable = true;

      polybar = {
        enable = true;
        package = pkgs.polybarFull;
        config = ./config/polybar/config.ini;
        script = "polybar main &";
      };

      random-background = {
        enable = true;
        imageDirectory = "${./config/wallpapers}";
        interval = "2h";
      };

      redshift = {
        enable = true;
        provider = "manual";
        latitude = 40.74;
        longitude = -74.0;
        temperature = {
          day = 5000;
          night = 3800;
        };
        settings = {
          redshift = {
            fade = true;
            adjustment-method = "randr";
            gamma-day = "0.95:0.95:0.95";
            gamma-night = "0.95:0.95:0.95";
          };
        };
      };

      unclutter.enable = true;
    };

    xdg = {
      enable = true;
      configFile.i3.source = ./config/i3;
      configFile.picom.source = ./config/picom;
      configFile.rofi.source = ./config/rofi;
    };

    xsession = {
      enable = true;
      windowManager.i3 = { enable = true; };
    };
  };
}
