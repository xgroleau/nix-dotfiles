{ config, lib, pkgs, ... }:

{
  imports = [
    ./authentik
    ./docker
    ./duckdns
    ./home
    ./kdeconnect
    ./media-server
    ./ocis
    ./pomerium
    ./palworld
    ./ssh
    ./tailscale
    ./xserver
  ];
}
