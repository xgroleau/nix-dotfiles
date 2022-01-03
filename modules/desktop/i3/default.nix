{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # For shortcuts
    brightnessctl
    playerctl

  ];
  xsession = {
    enable = true;
    windowManager.i3 = { enable = true; };
  };

  xdg.configFile.i3.source = ./i3;
}
