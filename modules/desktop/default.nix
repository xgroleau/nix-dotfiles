{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs;
    [
      # for font
      fira-code
    ];
  imports = [ ./dunst ./i3 ./picom ./redshift ./rofi ];
}
