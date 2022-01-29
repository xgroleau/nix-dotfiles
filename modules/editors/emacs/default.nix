{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.editor.emacs;
in {

  options.modules.editor.emacs = with types; {
    enable = mkBoolOpt false;
  };

  config = {
    programs.emacs = mkIf cfg.enable {
      enable = true;
    };
    xdg.configFile.doom.source = ./config;

    home.packages = with pkgs; [
      # lang nix
      nixfmt
      rnix-lsp
    ];
  };

}
