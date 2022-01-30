{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.alacritty;
in {
  options.modules.shell.alacritty = with types; { enable = mkBoolOpt false; };

  config = {
    programs.alacritty.enable = true;
    xdg.configFile.alacritty.source = ./config;
  };

}
