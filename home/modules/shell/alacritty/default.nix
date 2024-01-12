{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.shell.alacritty;
in {
  options.modules.shell.alacritty = with types; { enable = mkBoolOpt false; };

  config = {
    programs.alacritty.enable = true;
    xdg.configFile.alacritty.source = ./config;
    home.packages = with pkgs;
      [ (nerdfonts.override { fonts = [ "FiraCode" ]; }) ];
  };

}
