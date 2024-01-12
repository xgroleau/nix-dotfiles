{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.editors.nvim;
in {

  options.modules.editors.nvim = with types; {
    enable = mkEnableOption "Enables neovim with my config";
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable = true;
      vimAlias = true;
      vimdiffAlias = true;
    };
    xdg.configFile.nvim.source = ./config;
    home.packages = with pkgs;
      [ (nerdfonts.override { fonts = [ "FiraCode" ]; }) ];
  };
}
