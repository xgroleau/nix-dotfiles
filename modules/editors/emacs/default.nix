{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.editors.emacs;
in {

  options.modules.editors.emacs = with types; { enable = mkBoolOpt false; };

  config = {
    xdg.configFile.doom.source = ./config;

    home.packages = with pkgs; [
      # Emacs
      ((emacsPackagesNgGen emacs).emacsWithPackages (epkgs: [ epkgs.vterm ]))

      # tools
      fd
      git
      gnutls
      imagemagick
      ripgrep

      # lang
      nixfmt
      rnix-lsp
      rustfmt
      rust-analyzer

      # term
      libtool
      libvterm
    ];
  };
}
