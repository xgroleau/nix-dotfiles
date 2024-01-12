{ config, options, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.dev.ocaml;
in {

  options.modules.dev.ocaml = with types; {
    enable = mkEnableOption "Enables OCaml development tools";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ dune_3 ocaml ocamlPackages.lsp ];
  };

}
