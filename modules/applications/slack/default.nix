{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.applications.slack;
in {

  options.modules.applications.slack = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable { home.packages = with pkgs; [ slack ]; };
}
