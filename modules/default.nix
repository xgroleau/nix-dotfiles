{ config, lib, pkgs, nix-dotfiles, ... }:

{
  imports = [ ./home ./networking ];
}
