{ config, lib, pkgs, ... }:

let cfg = config.modules.editors.nvim;
in {

  options.modules.editors.nvim = {
    enable = lib.mkEnableOption "Enables neovim with my config";
  };

  config = lib.mkIf cfg.enable {
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
