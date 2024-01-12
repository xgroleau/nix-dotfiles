{ config, options, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.dev.common;
in {

  options.modules.dev.common = with types; {
    enable = mkEnableOption "Enable common development settings and tools";
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

    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.eza = {
      enable = true;
      enableAliases = true;
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    home = {
      packages = with pkgs; [
        btop
        bat
        comma
        du-dust
        fd
        gh
        jq
        killall
        ranger
        ripgrep
        tldr
      ];

    };
  };
}
