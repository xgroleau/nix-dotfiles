{ config, lib, pkgs, ... }:


with lib;
with lib.my;
let
  cfg = config.modules.editor.vscode;
in {

  options.modules.editor.vscode = with types; {
    enable = mkBoolOpt false;
  };

    config = mkIf cfg.enable {
      programs.vscode = {
      enable = true;
      extensions = with pkgs; [ 
        vscode-extensions.bbenoist.Nix
        ];
    };
  };
}
