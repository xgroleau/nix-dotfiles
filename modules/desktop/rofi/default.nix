{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [ fira-code ];
  xdg.configFile."rofi/themes".source = ./themes;

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
  
}
