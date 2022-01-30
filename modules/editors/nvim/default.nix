{ config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.nvim;
in {

  options.modules.editors.nvim = with types; { enable = mkBoolOpt false; };

  config = {
    programs.neovim = { enable = true; };
    programs.neovim.vimAlias = true;
    programs.neovim.vimdiffAlias = true;
    xdg.configFile.nvim.source = ./config;
  };
}
