{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.services.jmusic;
in {

  options.modules.services.jmusic = with types; { enable = mkBoolOpt false; };

  config = mkIf cfg.enable { services.jmusic = { enable = true; }; };
}
