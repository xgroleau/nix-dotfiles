{ config, lib, pkgs, ... }:

{
  imports = [
    ./docker
    ./duckdns
    ./home-manager
    ./kdeconnect
    ./media/server
    ./pomerium
    ./ssh
    ./tailscale
    ./xserver
  ];
}
