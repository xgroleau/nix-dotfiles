{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.applications.firefox;
in {

  options.modules.applications.firefox = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      package =
        pkgs.firefox.override { cfg = { enableTridactylNative = true; }; };
    };

    home.sessionVariables.BROWSER = "firefox";
    xdg.configFile.tridactyl.source = ./config;
  };
}
