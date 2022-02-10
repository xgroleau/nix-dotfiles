{ config, lib, pkgs, nixpkgs, ... }:

{

  imports = [
    ./modules/desktop
    ./modules/dev
    ./modules/shell
    ./modules/editors
    ./modules/applications
  ];

  config = {
    # User config
    targets.genericLinux.enable = true;
    systemd.user.startServices = true;
    nixpkgs.config.allowUnfree = true;

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
