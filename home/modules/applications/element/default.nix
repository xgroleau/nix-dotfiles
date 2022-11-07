{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.applications.element;
in {

  options.modules.applications.element = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable { home.packages = with pkgs; [ element-desktop ]; };
}
