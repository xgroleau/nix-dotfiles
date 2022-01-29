{ config, lib, pkgs, ... }:


with lib;
with lib.my;
let
  cfg = config.modules.shell.tmux;
in {
  options.modules.shell.tmux = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.tmux = { enable = true; };
    xdg.configFile.tmux.source = ./config;
  };
}
