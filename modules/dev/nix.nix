{ config, options, lib, pkgs, ... }:

 {
  home.packages = with pkgs; [
    nixfmt
    rnix-lsp
  ];
 }
