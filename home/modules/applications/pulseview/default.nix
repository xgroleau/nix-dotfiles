{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.applications.pulseview;
in {

  options.modules.applications.pulseview = with types; {
    enable = mkEnableOption "Enables pulseview for logic analyzer";

  };

  config = mkIf cfg.enable { home.packages = with pkgs; [ pulseview ]; };
}
