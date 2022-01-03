 { config, options, lib, pkgs, ... }:

 {
   home.packages = with pkgs; [ clang gcc gdb cmake clangd ];
 }
