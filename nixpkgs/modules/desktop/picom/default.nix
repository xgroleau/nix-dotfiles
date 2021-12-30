{ config, lib, pkgs, ... }:

{
  services.picom = {
    enable = true;
    backend = "glx";
    activeOpacity = "1";
    inactiveOpacity = "0.9";
    vSync = true;

    #Shadows
    shadow = true;
    shadowOffsets = [ (-5) (-5) ];
    shadowOpacity = "1.0";
    shadowExclude = [
      "name = 'Notification'"
      "name = 'Plank'"
      "name = 'Docky'"
      "name = 'Kupfer'"
      "name = 'xfce4-notifyd'"
      "name *= 'VLC'"
      "name *= 'compton'"
      "name *= 'picom'"
      "name *= 'Chromium'"
      "name *= 'Chrome'"
      "class_g = 'Firefox' && argb"
      "class_g = 'Conky'"
      "class_g = 'Kupfer'"
      "class_g = 'Synapse'"
      "class_g ?= 'Notify-osd'"
      "class_g ?= 'Cairo-dock'"
      "class_g = 'Cairo-clock'"
      "class_g ?= 'Xfce4-notifyd'"
      "class_g ?= 'Xfce4-power-manager'"
    ];

  };
}
