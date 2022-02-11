{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let
  cfg = config.modules.shell.zsh;
  pythonCfg = config.modules.dev.python;
in {

  options.modules.shell.zsh = with types; { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    xdg.configFile.zsh.source = ./config;
    programs.zsh = {
      enable = true;
      envExtra = "source $XDG_CONFIG_HOME/zsh/zshenv";
      initExtra = "source $XDG_CONFIG_HOME/zsh/zshrc";
    };
    home.packages = with pkgs; [ nix-zsh-completions git pythonCfg.package ];
    home.sessionPath = [ "$HOME/.local/bin" "$HOME/bin" ];
  };
}
