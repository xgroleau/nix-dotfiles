{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.applications.gitkraken;
in {

  options.modules.applications.gitkraken = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable { home.packages = with pkgs; [ gitkraken ]; };
}
