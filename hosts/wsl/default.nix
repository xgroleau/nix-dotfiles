{ config, pkgs, inputs, ... }:

{

  imports = [
    # include NixOS-WSL modules
    inputs.nixos-wsl.nixosModules.default
  ];

  config = {
    modules = {
      home = {
        enable = true;
        username = "xgroleau";
        profile = "graphical";
      };
    };


    wsl = {
      enable = true;
      defaultUser = "xgroleau";

      usbip.enalbe = true;
      docker-desktop.enable = true;
    }

    system.stateVersion = "22.11";

  };
}
