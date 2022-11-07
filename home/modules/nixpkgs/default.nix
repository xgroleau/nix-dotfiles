{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.nixpkgs;
in {

  options.modules.nixpkgs = with types; { enable = mkBoolOpt false; };

  config = mkIf cfg.enable {
    nixpkgs.config.allowUnfree = true;
    xdg.configFile.nixpkgs.source = ./config;
  };
}
