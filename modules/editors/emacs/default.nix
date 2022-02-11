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
      rustup
      rust-analyzer

      # term
      libtool
      libvterm
    ];

    home.sessionVariables = {
      DOOM_EMACS = "${config.xdg.dataHome}/.emacs.d";
      DOOM_EMACS_BIN = "${config.xdg.dataHome}/doom/bin";
    };
    home.sessionPath = [ "${config.home.sessionVariables.DOOM_EMACS_BIN}" ];
  };
}
