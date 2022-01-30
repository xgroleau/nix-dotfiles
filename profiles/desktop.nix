{ config }:

# Module includes graphical + the WM/DE setup
{
  config = {
    imports = [ ./graphical ];
    modules = { desktop.active = "i3"; };
  };
}
