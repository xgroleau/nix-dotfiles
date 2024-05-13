{ config, lib, pkgs, inputs, ... }:

let overlays = import ../overlays { inherit inputs; };
in {
  imports = [
    ./modules/applications
    ./modules/desktop
    ./modules/dev
    ./modules/editors
    ./modules/nixpkgs
    ./modules/shell
  ];

  config = {

    nixpkgs.overlays = [ overlays.unstable-packages overlays.roam ];

    programs.ssh = {
      enable = true;
      extraConfig = ''
        AddKeysToAgent yes
      '';
    };

    # User config
    targets.genericLinux.enable = stdenv.isLinux;
    systemd.user.startServices = true;
    nixpkgs.config.allowUnfree = true;
    manual.manpages.enable = false;

    home = {
      keyboard = {
        layout = "ca";
        options = [ "caps:swapescape" ];
      };

      enableNixpkgsReleaseCheck = true;
      language.base = "en_CA.UTF-8";
    };
  };

}
