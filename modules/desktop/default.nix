{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs;
    [
      # for font
      (nerdfonts.override { fonts = ["FiraCode"]; })
    ];
  imports = [ ./dunst ./flameshot ./i3 ./picom ./redshift ./rofi ];
}
