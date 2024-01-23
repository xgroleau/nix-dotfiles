{ config, lib, pkgs, ... }:

{
  imports = [
    ./authentik
    ./caddy
    ./docker
    ./duckdns
    ./home
    ./kdeconnect
    ./media-server
    ./ocis
    ./palworld
    ./ssh
    ./tailscale
    ./xserver
  ];
}
