{ config, options, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.dev.common;
in {

  options.modules.dev.common = with types; {
    enable = mkBoolOpt false;
    gitUser = mkOpt types.str "xgroleau";
    gitEmail = mkOpt types.str "xavgroleau@gmail.com";
  };

  config = mkIf cfg.enable {

    programs.git = {
      enable = true;
      userName = cfg.gitUser;
      userEmail = cfg.gitEmail;
    };

    programs.direnv.enable = true;
    programs.direnv.nix-direnv.enable = true;

    home.packages = with pkgs; [
      btop
      bat
      comma
      fd
      fzf
      gh
      jq
      killall
      ranger
      tldr
      ripgrep
    ];
  };
}
