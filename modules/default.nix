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
    ./firefly-iii
    ./media-server
    ./monitoring
    ./msmtp
    ./ocis
    ./palworld
    ./ssh
    ./tailscale
    ./xserver
  ];
}
