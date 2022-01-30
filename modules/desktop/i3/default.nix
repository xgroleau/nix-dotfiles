{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop;
in {
  config = mkIf (cfg.active == "i3") {
    fonts.fontconfig.enable = true;
    xdg = {
      enable = true;

      configFile.dunst.source = ./config/dunst;
      configFile.i3.source = ./config/i3;
      configFile.picom.source = ./config/picom;
      configFile.rofi.source = ./config/rofi;
      configFile."redshift.conf".source = ./config/redshift.conf;
    };
    xsession = {
      enable = true;
      windowManager.i3.enable = true;
    };

    home.packages = with pkgs; [
      brightnessctl
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      playerctl
    ];

    services = {
      dunst.enable = true;
      flameshot.enable = true;
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

      unclutter.enable = true;
    };

    programs.rofi = {
      enable = true;
      font = "FiraCode NF 12";
      theme = "slate";
      plugins = with pkgs; [
        rofi-emoji
        rofi-calc
        rofi-power-menu
      ]; # TODO: migrate i3 scripts to rofi plugins

      extraConfig = {
        modi = "drun,window,emoji,calc";
        show-icons = true;
        sort = true;
        matching = "fuzzy";
        display-drun = "Exec";
        display-emoji = "Emoji";
        display-calc = "Calc";
        display-window = "Window";
      };
    };

    services.redshift = {
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
  };
}
