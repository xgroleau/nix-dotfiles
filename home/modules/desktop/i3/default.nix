{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.desktop;
in
{
  config = lib.mkIf (cfg.active == "i3") {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      arandr
      brightnessctl
      flameshot
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      xclip
      (rofi.override {
        plugins = [
          rofi-emoji
          rofi-calc
        ];
      })
      rofi-power-menu
      playerctl
      pulseaudio

      # KDE apps
      libsForQt5.ark
      libsForQt5.dolphin
      libsForQt5.okular
      libsForQt5.breeze-icons
    ];

    home.sessionVariables = {
      XDG_CURRENT_DESKTOP = "i3";
    };

    programs.autorandr = {
      enable = true;
      hooks.postswitch = {
        polybar = "systemctl --user restart polybar";
        background = "systemctl --user restart random-background";
      };
    };

    services = {

      betterlockscreen = {
        enable = true;
        inactiveInterval = 45;
        arguments = [ "-u ${./config/wallpapers} " ];
      };

      dunst = {
        enable = true;
        configFile = ./config/dunst/dunstrc;
      };

      gnome-keyring.enable = true;
      network-manager-applet.enable = true;

      kdeconnect = {
        enable = true;
        indicator = true;
      };

      picom = {
        enable = true;
        wintypes = {
          tooltip = {
            fade = true;
            shadow = true;
            opacity = 0.95;
            focus = true;
            full-shadow = false;
          };
          dock = {
            shadow = false;
            opacity = 0.8;
          };
          dnd = {
            shadow = false;
          };
          menu = {
            shadow = false;
          };
          popup_menu = {
            opacity = 0.95;
          };
          dropdown_menu = {
            opacity = 0.8;
          };
        };
        settings = {
          blur = true;
          xinerama-shadow-crop = true;
        };
        inactiveOpacity = 0.95;
        shadow = true;
        shadowOffsets = [
          (-5)
          (-5)
        ];
        shadowOpacity = 1.0;
        shadowExclude = [
          "class_g = 'i3-frame'"
          "name = 'noshadow'"
        ];
        vSync = true;
      };

      polybar = {
        enable = true;
        package = pkgs.polybarFull;
        config = ./config/polybar/config.ini;
        script = ''
          for m in $(polybar --list-monitors | ${pkgs.coreutils}/bin/cut -d":" -f1); do
            MONITOR=$m polybar --reload main &
          done'';
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
      udiskie.enable = true;
    };

    xdg = {
      enable = true;
      configFile = {
        autorandr = {
          recursive = true;
          source = ./config/autorandr;
        };
        i3.source = ./config/i3;
        rofi.source = ./config/rofi;
      };
    };

    xsession = {
      enable = true;
      windowManager.i3 = {
        enable = true;
      };
    };
  };
}
