{ config, lib, pkgs, ... }:

let cfg = config.modules.editors.emacs;
in {

  options.modules.editors.emacs = {
    enable = lib.mkEnableOption "Enables emacs";
    defaultEditor = lib.mkEnableOption "Set as default editor";
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile.doom = {
      source = ./config;
      recursive = true;
    };

    services.emacs.defaultEditor = cfg.defaultEditor;

    home = {

      packages = with pkgs; [
        # Emacs
        ((emacsPackagesFor emacs29).emacsWithPackages
          (epkgs: [ epkgs.editorconfig epkgs.vterm epkgs.xclip ]))

        # Font
        (nerdfonts.override { fonts = [ "FiraCode" "NerdFontsSymbolsOnly" ]; })

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
        nodePackages.pyright
        rustup

        dune_3
        ocamlPackages.utop
        ocamlPackages.merlin
        ocamlPackages.ocamlformat
        ocamlPackages.ocp-indent

        html-tidy
        nodePackages.stylelint
        nodePackages.js-beautify

        nodePackages.textlint
        nodePackages.prettier
        nodePackages.markdownlint-cli
        multimarkdown
        ispell

        # term
        libtool
        libvterm
      ];

      sessionVariables = {
        DOOM_EMACS = "${config.xdg.configHome}/emacs";
        DOOM_EMACS_BIN = "${config.home.sessionVariables.DOOM_EMACS}/bin";
      };
      sessionPath = [ "${config.home.sessionVariables.DOOM_EMACS_BIN}" ];
    };
  };
}
