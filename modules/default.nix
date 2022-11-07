{ config, lib, pkgs, nix-dotfiles, ... }:

{
  imports = [ ./networking ./home ];
}
