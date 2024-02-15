{ config, lib, pkgs, ... }:

let cfg = config.modules.shell.alacritty;
in {
  options.modules.shell.alacritty = {
    enable = lib.mkEnableOption "Enables alacritty";
  };

  config = lib.mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      settings = {
        colors = {
          draw_bold_text_with_bright_colors = true;
          cursor = {
            cursor = "0xff2600";
            text = "0xf1c1c1";
          };
          primary = {

            background = "0x191919";
            foreground = "0xeaeaea";
          };
        };

        font = {
          size = 10;
          bold = {
            family = "FiraCode Nerd Font";
            style = "Bold";
          };

          italic = {
            family = "FiraCode Nerd Font";
            style = "Light,Regular";
          };

          normal = {
            family = "FiraCode Nerd Font";
            style = "Regular";
          };
        };

        env = { TERM = "xterm-256color"; };
        mouse = { hide_when_typing = false; };

        scrolling = {
          history = 10000;
          multiplier = 3;
        };
        shell = lib.mkIf config.modules.shell.zellij.enable {
          args = [ "attach" "--create" "default" ];
          program = "zellij";
        };

      };
    };

    home.packages = with pkgs;
      [ (nerdfonts.override { fonts = [ "FiraCode" ]; }) ];
  };

}
