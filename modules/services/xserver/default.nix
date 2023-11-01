{ config, lib, pkgs, profiles, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.services.xserver;
in {

  options.modules.services.xserver = with types; {
    home-manager = mkBoolOpt' false "Let home-manager manage the session";
  };

  config = mkIf cfg.home-manager {
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
