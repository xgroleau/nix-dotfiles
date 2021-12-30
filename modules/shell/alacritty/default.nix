{ config, lib, pkgs, ... }:

{
  # Dependency
  programs.tmux.enable = true;

  programs.alacritty = {
    enable = true;
    settings = {
      # Font
      use_thin_strokes = true;
      font = {
        size = 10;

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

      #launch
      env = { TERM = "xterm-256color"; };
      shell = {
        program = /bin/zsh;
        args = [ "-l" "-c" "tmux attach || tmux" ];
      };
    };
  };
}
