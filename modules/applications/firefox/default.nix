{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.appplications.firefox;
in {

  options.modules.appplications.firefox = with types; {
    enable = mkBoolOpt false;
  };

  config = {
    programs.firefox = {
      enable = true;
      package = pkgs.firefox.override { enableTridactylNative = true; };
      configFile.i3.source = ./config/i3;
    };

    xdg.configFile.tridactyl.source = ./config;
  };
}
