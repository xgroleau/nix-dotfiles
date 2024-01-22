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
    ./palworld-container
    ./ssh
    ./tailscale
    ./xserver
  ];
}
