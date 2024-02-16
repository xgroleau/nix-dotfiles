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

      sessionVariables = lib.mkMerge [
        {
          DOOM_EMACS = "${config.xdg.configHome}/emacs";
          DOOM_EMACS_BIN = "${config.home.sessionVariables.DOOM_EMACS}/bin";
        }

        (lib.mkIf cfg.defaultEditor {
          VISUAL = "emacs";
          EDITOR = "emacs -nw";
        })
      ];
      sessionPath = [ "${config.home.sessionVariables.DOOM_EMACS_BIN}" ];
    };
  };
}
