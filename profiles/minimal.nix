{ config, lib, pkgs, ... }:

{
  config.modules = {
    dev.common.enable = true;
    editors.nvim.enable = true;
    editors.emacs.enable = true;
    shell.tmux.enable = true;
    shell.zsh.enable = true;
  };
}