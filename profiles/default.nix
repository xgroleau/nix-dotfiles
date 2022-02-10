# Some modules for common presets for profile
rec {
  minimal = _: {
    config.modules = {
      dev.common.enable = true;
      editors.nvim.enable = true;
      editors.emacs.enable = true;
      shell.tmux.enable = true;
      shell.zsh.enable = true;
    };
  };

  graphical = _: {
    imports = [ minimal ];
    config = {
      modules = {
        applications.firefox.enable = true;
        applications.gitkraken.enable = true;
        applications.discord.enable = true;
        applications.spotify.enable = true;
        dev.cc.enable = true;
        dev.python.enable = true;
        editors.vscode.enable = true;
        shell.alacritty.enable = true;
      };
    };
  };

  desktop = _: {
    imports = [ graphical ];
    config = { modules = { desktop.active = "i3"; }; };
  };
}
