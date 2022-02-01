{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.dev.common;
in {

  options.modules.dev.common = with types; { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {

    programs.git = { enable = true; };

    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;

    home.packages = with pkgs; [ bpytop bat fd fzf tldr ripgrep ];
  };
}
