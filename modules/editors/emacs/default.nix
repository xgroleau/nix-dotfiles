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
      ((emacsPackagesFor emacs).emacsWithPackages
        (epkgs: [ epkgs.vterm epkgs.editorconfig ]))

      # general tools
      fd
      git
      gnutls
      imagemagick
      ripgrep

      # apps
      ## everywhere
      xclip
      xdotool
      xorg.xprop
      xorg.xwininfo

      # lang
      nixfmt
      rustup
      rust-analyzer

      # term
      libtool
      libvterm
    ];

    home.sessionVariables = {
      DOOM_EMACS = "${config.home.homeDirectory}/.emacs.d";
      DOOM_EMACS_BIN = "${config.home.sessionVariables.DOOM_EMACS}/bin";
    };
    home.sessionPath = [ "${config.home.sessionVariables.DOOM_EMACS_BIN}" ];
  };
}
