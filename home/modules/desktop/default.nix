{ config, lib, pkgs, ... }:

{

  options.modules.desktop = with lib.types; {
    active = lib.mkOption {
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
