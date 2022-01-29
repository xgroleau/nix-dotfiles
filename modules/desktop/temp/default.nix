{ config, lib, pkgs, ... }:


with lib;
with lib.my;
let cfg = config.modules.theme;
in {
  config = mkIf (cfg.active == "alucard") {
    fonts.fontconfig.enable = true;
    xdg = {
      enable = true;
      configFile.i3.source = ./config/i3;
    };
    xsession = {
      enable = true;
      windowManager.i3.enable = true;
    };

    home.packages = with pkgs;
      [
        brightnessctl
        (nerdfonts.override { fonts = ["FiraCode"]; })
        playerctl
      ];

    services = {
      dunst = {
        enable = true;
        settings = {
          global = {
            monitor = 0;
            follow = "mouse";
            geometry = "320x5-15-15";
            indicate_hidden = "yes";
            shrink = "no";
            transparency = 0;
            notification_height = 0;
            separator_height = 2;
            padding = 10;
            horizontal_padding = 10;
            frame_width = 1;
            frame_color = "#282c33";
            separator_color = "frame";
            sort = "yes";
            idle_threshold = 120;
            font = "FiraCode NF 10 ";
            line_height = 0;
            markup = "full";
            format = "<span foreground='#aea79f'><b>%s %p</b></span>\\n%b";
            alignment = "left";
            vertical_alignment = "center";
            show_age_threshold = 60;
            word_wrap = "yes";
            ellipsize = "middle";
            ignore_newline = "no";
            stack_duplicates = true;
            hide_duplicate_count = false;
            show_indicators = "yes";
            icon_position = "left";
            max_icon_size = 32;
            sticky_history = "yes";
            history_length = 20;
            always_run_script = true;
            startup_notification = false;
            verbosity = "mesg";
            corner_radius = 0;
            ignore_dbusclose = false;
            force_xinerama = false;
            mouse_left_click = "do_action";
            mouse_middle_click = "close_all";
            mouse_right_click = "close_current";
          };

          shortcuts = {
            close = "mod1+space";
            close_all = "mod1+shift+space";
            history = "mod1+period";
            context = "mod1+shift+period";
          };

          urgency_low = {
            background = "#282c33";
            foreground = "#aea79f";
            timeout = 3;
          };

          urgency_normal = {
            background = "#1e293e";
            foreground = "#aea79f";
            timeout = 3;
          };

          urgency_critical = {
            background = "#771f3f";
            foreground = "#aea79f";
            timeout = 5;
          };
        };
      };

      flameshot.enable = true;

      network-manager-applet.enable = true;

      picom = {
        enable = true;
        backend = "glx";
        activeOpacity = "1";
        inactiveOpacity = "0.9";
        vSync = true;

        #Shadows
        shadow = true;
        shadowOffsets = [ (-5) (-5) ];
        shadowOpacity = "1.0";
        shadowExclude = [
          "name = 'Notification'"
          "name = 'Plank'"
          "name = 'Docky'"
          "name = 'Kupfer'"
          "name = 'xfce4-notifyd'"
          "name *= 'VLC'"
          "name *= 'compton'"
          "name *= 'picom'"
          "name *= 'Chromium'"
          "name *= 'Chrome'"
          "class_g = 'Firefox' && argb"
          "class_g = 'Conky'"
          "class_g = 'Kupfer'"
          "class_g = 'Synapse'"
          "class_g ?= 'Notify-osd'"
          "class_g ?= 'Cairo-dock'"
          "class_g = 'Cairo-clock'"
          "class_g ?= 'Xfce4-notifyd'"
          "class_g ?= 'Xfce4-power-manager'"
        ];
      };

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

    xdg.configFile."rofi/themes".source = ./config/rofithemes;
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
