{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.shell.zsh;
in {

  options.modules.shell.zsh = with types; { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    xdg.configFile.zsh.source = ./config;
    programs.zsh = {
      enable = true;
      envExtra = "source $HOME/.config/zsh/zshenv";
      initExtra = "source $HOME/.config/zsh/zshrc";
    };
    home.packages = with pkgs; [ nix-zsh-completions python37 git ];
  };
}
