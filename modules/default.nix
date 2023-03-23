{ config, lib, pkgs, ... }:

{
  imports = [ ./home ./networking ./services ];
}
