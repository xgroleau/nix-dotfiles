 { config, options, lib, pkgs, ... }:

 {
   programs.fzf = {
     enable = true;
     enableZshIntegration = true;
   };
   home.packages = with pkgs; [ ripgrep fd ];
 }
