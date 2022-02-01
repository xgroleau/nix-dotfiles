{ config , ...}:

# Module includes common dependencies for development and work with GUI apps
{
  imports = [ ./minimal.nix ];
  config = {
    modules = {
      applications.firefox.enable = true;
      dev.cc.enable = true;
      dev.python.enable = true;
      editors.vscode.enable = true;
      shell.alacritty.enable = true;
    };
  };
}
