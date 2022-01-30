{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.shell.zsh;
  zshrcLocal = config.home.homeDirectory + "/.zshrc.local";
  zshenvLocal = config.home.homeDirectory + "/.zshenv.local";
in {

  options.modules.shell.zsh = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    xdg.configFile.zsh.source = ./config;
    programs.zsh =  {
      enable = true;
      dotDir = ".config/zsh";
      envExtra = "source $HOME/zsh/zshenv";
    };
  };
}
