{ config }:

# Module includes most dependencies for development and work
{
  config = {
    imports = [ ./minimal ];
    modules = {
      applications.firefox.enable = true;
      dev.cc.enable = true;
      dev.python.enable = true;
      editors.vscode.enable = true;
      shell.alacritty.enable = true;
    };
  };
}
