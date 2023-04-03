{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.shell.zellij;
in {
  options.modules.shell.zellij = with types; { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      settings = {
        on_force_close = "detach";
        theme = "gruvbox-dark";
        pane_frames = false;
      };
    };
  };
}
