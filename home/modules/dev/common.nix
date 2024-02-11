{ config, options, lib, pkgs, ... }:

let cfg = config.modules.dev.common;
in {

  options.modules.dev.common = with lib.types; {
    enable = lib.mkEnableOption "Enable common development settings and tools";

    gitUser = lib.mkOption {
      type = types.str;
      default = "xgroleau";
    };

    gitEmail = lib.mkOption {
      type = types.str;
      default = "xavgroleau@gmail.com";
    };
  };

  config = lib.mkIf cfg.enable {

    programs = {
      git = {
        enable = true;
        userName = cfg.gitUser;
        userEmail = cfg.gitEmail;
      };

      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      zoxide = {
        enable = true;
        enableZshIntegration = true;
      };

      eza = {
        enable = true;
        enableAliases = true;
      };

      fzf = {
        enable = true;
        enableZshIntegration = true;
      };

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
