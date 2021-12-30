{ config, lib, pkgs, ... }:

let
  doom-emacs = pkgs.callPackage (builtins.fetchTarball {
    url =
      "https://github.com/nix-community/nix-doom-emacs/archive/master.tar.gz";
  }) {
    doomPrivateDir = ./doom; # Directory containing your config.el init.el
    # and packages.el files
    emacsPackagesOverlay = self: super: {
      magit-delta = super.magit-delta.overrideAttrs (esuper: {
        buildInputs = esuper.buildInputs ++ [ pkgs.git pkgs.cacert ];
      });
    };
  };
in {
  home.packages = [ doom-emacs ];
  home.sessionPath = [ (config.home.homeDirectory + "/.emacs.d/bin") ];
}
