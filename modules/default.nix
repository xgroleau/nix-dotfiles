{ config, lib, pkgs, ... }:

{
  imports = [
    ./authentik
    ./caddy
    ./docker
    ./duckdns
    ./home
    ./immich
    ./kdeconnect
    ./media-server
    ./ocis
    ./palworld
    ./ssh
    ./tailscale
    ./xserver
  ];
}
