{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.emacs;
in {

  options.modules.editors.emacs = with types; { enable = mkBoolOpt false; };

  config = {
    programs.emacs = mkIf cfg.enable { enable = true; };
    xdg.configFile.doom.source = ./config;

    home.packages = with pkgs; [
      # lang nix
      nixfmt
      rnix-lsp
    ];
  };
}
