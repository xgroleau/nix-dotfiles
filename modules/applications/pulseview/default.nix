{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.applications.pulseview;
in {

  options.modules.applications.pulseview = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable { home.packages = with pkgs; [ pulseview ]; };
}
