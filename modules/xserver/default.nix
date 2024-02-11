{ config, lib, pkgs, profiles, ... }:

let cfg = config.modules.xserver;
in {
  options.modules.xserver = {
    home-manager = lib.mkEnableOption "Let home-manager manage the session";
  };

  config = lib.mkIf cfg.home-manager {
    environment.systemPackages = [ pkgs.sddm-chili-theme ];
    services = {
      xserver = {

        enable = true;
        # Setup the display manager
        displayManager = {
          defaultSession = "none+fake";

          # Setup lightdm
          sddm = {
            enable = true;
            theme = "chili";
          };

          # Use a fake session. The actual session is managed by Home Manager.
          session = let
            fakeSession = {
              manage = "window";
              name = "fake";
              start = "";
            };
          in [ fakeSession ];
        };
      };
    };
  };
}
