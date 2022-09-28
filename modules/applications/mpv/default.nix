{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.applications.mpv;
in {

  options.modules.applications.mpv = with types; { enable = mkBoolOpt false; };

  config = mkIf cfg.enable { home.packages = with pkgs; [ mpv ]; };
}
