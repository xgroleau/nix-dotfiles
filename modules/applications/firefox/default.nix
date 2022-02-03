{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.appplications.firefox;
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

    xdg.configFile.tridactyl.source = ./config;
  };
}
