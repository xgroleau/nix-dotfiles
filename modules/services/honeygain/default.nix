{ config, lib, pkgs, ... }:

with lib;
with lib.my.option;
let cfg = config.modules.services.honeygain;
in {

  options.modules.services.honeygain = with types; {
    enable = mkBoolOpt false;
    email = mkReq types.nonEmptyStr "The account email";
    name = mkReq types.nonEmptyStr
      "The device name that will be displayed in the dashboard";
    passwordFile =
      mkReq types.path "The full path to a file which contains the password ";
  };

  config = mkIf cfg.enable {
    virtualisation.oci-containers.containers = {
      hackagecompare = {
        image = "honeygain/honeygain:latest";
        cmd = [
          "-tou-accept"
          "-email ${cfg.email}"
          "-pass ${builtins.readFile cfg.passwordFile}"
          "-device ${cfg.name}"
        ];
        autostart = true;
      };
    };
  };
}
