{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.vscode;
in {

  options.modules.editors.vscode = with types; { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      #extensions = [ pkgs.vscode-extensions.bbenoist.Nix ];
    };
  };
}
