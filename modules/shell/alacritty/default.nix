{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell.alacritty;
in {
  options.modules.shell.alacritty = with types; {
    enable = mkBoolOpt false;
  };

  config = {
    programs.alacritty = {
      enable = true;
      xdg.configFile.alacritty.source = ./config;
      settings = {
        # Font
        use_thin_strokes = true;
        font = {
          size = 10;
          # TODO: font config
          normal = {
            family = "FiraCode NF";
            style = "Regular";
          };

          bold = {
            family = "FiraCode NF";
            style = "Bold";
          };

          italic = {
            family = "FiraCode NF";
            style = "Light,Regular";
          };

        };
        #styling
        custom_cursor_colors = true;
        draw_bold_text_with_bright_colors = true;
        colors = {
          primary = {
            background = "0x191919";
            foreground = "0xeaeaea";
          };

          cursor = {
            text = "0xf1c1c1";
            cursor = "0xff2600";
          };
        };

        #typing
        hide_cursor_when_typing = false;

        #scrolling
        scrolling = {
          history = 10000;
          multiplier = 3;
        };

        #launch TODO: fix
        env = { TERM = "xterm-256color"; };
        # shell = {
        #   program = /bin/zsh;
        #   args = [ "-l" "-c" "tmux attach || tmux" ];
        # };
      };
    };
  };

}
