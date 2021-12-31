{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # For shortcuts
    brightnessctl
    playerctl

    # for font
    fira-code
  ];
  xsession.windowManager.i3 = { enable = true; };

  xdg.configFile.i3.source = ./i3;
}
