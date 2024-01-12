{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.nixpkgs;
in {

  options.modules.nixpkgs = with types; {
    enable = mkEnableOption "Enable common nix configurations";
  };

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;
    xdg.configFile.nixpkgs.source = ./config;
  };
}
