{ config, lib, pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    font = "FiraCode NF 12";
    theme = "slate";
    plugins = [
      pkgs.rofi-emoji
      pkgs.rofi-calc
    ]; # TODO: migrate scripts to rofi plugins

    extraConfig = {
      modi = "drun";
      show-icons = true;
      sort = true;
      matching = "fuzzy";
      display-drun = "Exec";
      display-calc = "Calc";
      display-window = "Window";
    };

  };
}
