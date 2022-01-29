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
    programs.zsh =  {
      enable = true;
      dotDir = ".config/zsh";
      programs.zsh.envExtra = "source $HOME/zsh/zshenv";
      xdg.configFile.zsh.source = ./config;
  };
}
