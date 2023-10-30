{ config, lib, pkgs, profiles, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.services.xserver;
in {

  options.modules.services.xserver = with types; {
    home-manager = mkBoolOpt' false "Let home-manager manage the session";
  };

  config = mkIf cfg.home-manager {
    services = {
      xserver = {

        enable = true;
        # Setup the display manager
        displayManager = {
          defaultSession = "none+fake";

          # Setup lightdm
          lightdm = {
            enable = true;
            greeters.slick = {
              enable = true;
              draw-user-backgrounds = true;
            };
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
