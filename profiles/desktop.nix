{ config, ... }:

# Module includes graphical + the WM/DE setup
{
  imports = [ ./graphical.nix ];
  config = {
    modules = { desktop.active = "i3"; };
  };
}
