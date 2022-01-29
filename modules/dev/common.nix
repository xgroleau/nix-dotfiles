 { config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.dev.common;
in {

  options.modules.dev.common = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };
    home.packages = with pkgs; [
      bpytop 
      fd
      ripgrep ];
  };
 }
