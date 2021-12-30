{ config, lib, pkgs, ... }:

{
  programs.neovim = { enable = true; };
  programs.neovim.vimAlias = true;
  programs.neovim.vimdiffAlias = true;
  xdg.configFile."nvim/init.vim".source = ./nvim/init.vim;
}
