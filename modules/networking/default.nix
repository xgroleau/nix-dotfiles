{ config, lib, pkgs, ... }:

{
  imports = [ ./duckdns ./forced-vpn ./kdeconnect ./ssh ./tailscale ];
}
