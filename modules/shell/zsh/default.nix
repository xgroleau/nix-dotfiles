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
      envExtra = "source ${config.xdg.configHome}/zsh/zshenv";
      initExtra = "source ${config.xdg.configHome}/zsh/zshrc";
    };
    home.sessionVariables.SHELL = "zsh";

    home.packages = with pkgs; [ nix-zsh-completions git pythonCfg.package ];

    home.sessionPath = [
      "${config.home.homeDirectory}/.local/bin"
      "${config.home.homeDirectory}/bin"
    ];
  };
}
