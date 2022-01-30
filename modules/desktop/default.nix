{ config, lib, pkgs, ... }:

with lib;
with lib.my; {

  options.modules.desktop = with types; {
    active = mkOption {
      type = nullOr str;
      default = null;
      description = ''
        Name of the desktop theme to use.
      '';
    };
  };

  imports = [ ./i3 ];

  config = {
    fonts.fontconfig.enable = true;
    xdg.enable = true;
    xsession.enable = true;
  };
}
