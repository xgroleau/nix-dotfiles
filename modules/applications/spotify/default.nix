{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.applications.spotify;
in {

  options.modules.applications.spotify = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable { home.packages = with pkgs; [ spotify ]; };
}
