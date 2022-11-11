{ config, pkgs, ... }:

{
  imports = [ ../base-config.nix ./hardware-configuration.nix ];

  config = {
    modules = {
      home.username = "xgroleau";
      home.profile = "dev";
    };

    boot.cleanTmpDir = true;
    zramSwap.enable = true;
    networking.hostName = "instance-20221111-1629";
    services.openssh.enable = true;
    users.users.root.openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/ZRV75mh7+1xiTR8+oNDabpUAmUrrEa6drrlhB4H2xqRoaBM5ZGlwuCgB+uTtsdcyM2sf0ZVep9vkjVFDbAAsoSeKM1sIySQXcPjaSFJX51aGUVWorPYfHIVljg6NHFKJtQFow/Kh3lzYs6F7ZbnrSGS25PWiR/ZfJx3RaGpCcyJcDUUjJ0Bt1+ORaayIL429IImEmW0/SqJL3PdzstkS8ukQ8rIki5MTU/Nk7RjbghkmzwONdMbu+8/fego7LbxJYhzdt97lwB0g0k5Z/cSE5Dic3pa2oLRinVyPjfgGyxZ8lugaTjmGB9HroqVfg/C+QWAxUwouX0SWHnCYhXvF xavgroleau@gmail.com"
    ];

  };
}
