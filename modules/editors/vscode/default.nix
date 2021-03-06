{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.editors.vscode;
in {

  options.modules.editors.vscode = with types; { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        bbenoist.nix
        brettm12345.nixfmt-vscode
      ];
    };
  };
}
