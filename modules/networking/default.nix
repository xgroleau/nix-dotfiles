{ config, lib, pkgs, ... }:

{
  imports = [ ./duckdns ./kdeconnect ./ssh ];
}
