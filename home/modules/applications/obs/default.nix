{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.applications.obs;
in {

  options.modules.applications.obs = with types; { enable = mkBoolOpt false; };

  config = mkIf cfg.enable { home.packages = with pkgs; [ obs-studio ]; };
}
