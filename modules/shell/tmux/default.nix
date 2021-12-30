{ config, lib, pkgs, ... }:

{
  programs.tmux = { enable = true; };
  xdg.configFile.tmux.source = ./tmux;
}
