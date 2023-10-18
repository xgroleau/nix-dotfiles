{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.shell.tmux;
in {
  options.modules.shell.tmux = with types; { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      enableZshIntegration = true;
    };
    xdg.configFile.tmux.source = ./config;
  };
}
