{ config, lib, pkgs, ... }:

let cfg = config.modules.shell.alacritty;
in {
  options.modules.shell.alacritty = {
    enable = lib.mkEnableOption "Enables alacritty";
  };

  config = lib.mkIf cfg.enable {
    programs.alacritty.enable = true;
    xdg.configFile.alacritty.source = ./config;
    home.packages = with pkgs;
      [ (nerdfonts.override { fonts = [ "FiraCode" ]; }) ];
  };

}
