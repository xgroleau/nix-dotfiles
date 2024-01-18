{ config, lib, pkgs, ... }:

{
  imports = [
    ./docker
    ./duckdns
    ./home
    ./kdeconnect
    ./media-server
    ./ocis
    ./pomerium
    ./ssh
    ./tailscale
    ./xserver
  ];
}
