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
    ./palworld
    ./palworld-2
    ./ssh
    ./tailscale
    ./xserver
  ];
}
