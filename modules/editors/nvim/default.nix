{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.editor.nvim;
in {

  options.modules.editor.nvim = with types; {
    enable = mkBoolOpt false;
  };

  config = {
    programs.neovim = { enable = true; };
    programs.neovim.vimAlias = true;
    programs.neovim.vimdiffAlias = true;
    xdg.configFile.nvim.source = ./config;
  };
}
