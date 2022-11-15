{ config, lib, pkgs, nix-dotfiles, ... }:

{
  imports = [ ./home ./services ./networking ];
}
