{ config, lib, pkgs, ... }:

{ 
  programs.vscode = {
    enable = true;
    extensions = with pkgs; [];
  };
}
