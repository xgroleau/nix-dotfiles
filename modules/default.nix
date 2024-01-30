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
    ./msmtp
    ./ocis
    ./palworld
    ./ssh
    ./tailscale
    ./xserver
  ];
}
