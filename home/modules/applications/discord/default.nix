{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.applications.discord;
in {

  options.modules.applications.discord = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ discord ];
    xdg.configFile.discord = {
      source = ./config;
      recursive = true;
    };

  };
}
