{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.appplications.firefox;
in {

  options.modules.applications.firefox = with types; {
    enable = mkBoolOpt false;
  };

  config = {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox.override { enableTridactylNative = true; };
    };

    xdg.configFile.tridactyl.source = ./config;
  };
}
