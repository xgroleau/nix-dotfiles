{ config, lib, pkgs, ... }:

let cfg = config.modules.editors.vscode;
in {

  options.modules.editors.vscode = {
    enable = lib.mkEnableOption "Enables VScode with some base extensions";
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = true;
      # Need some packages for web assembly and preview in IDE
      package = pkgs.vscode.fhsWithPackages (ps:
        with ps; [
          cmake
          fontconfig
          libGL
          openssl.dev
          pkg-config
          xorg.libxcb
          xorg.libX11
          xorg.libXcursor
          xorg.libXrandr
          xorg.libXi
          zlib
        ]);

      extensions = with pkgs.vscode-extensions; [
        arrterian.nix-env-selector
        bbenoist.nix
        brettm12345.nixfmt-vscode
        mkhl.direnv
        ms-vscode.cpptools
        tamasfe.even-better-toml
        rust-lang.rust-analyzer
      ];
    };
  };
}
