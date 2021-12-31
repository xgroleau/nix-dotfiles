{ config, lib, pkgs, ... }:

{
  programs.tmux = { enable = true; };
  xdg.configFile."tmux/tmux.conf".source = ./tmux/tmux.conf;
}
