{ config, lib, pkgs, ... }:

{
  imports = [
    ./docker
    ./duckdns
    ./home
    ./kdeconnect
    ./media-server
    ./pomerium
    ./ssh
    ./tailscale
    ./xserver
  ];
}
