# Some modules for common presets for profile
rec {
  minimal = _: {
    config.modules = {
      dev.common.enable = true;
      editors.nvim.enable = true;
      nixpkgs.enable = true;
      shell.zellij.enable = true;
      shell.zsh.enable = true;
    };
  };

  dev = _: {
    imports = [ minimal ];
    config = {
      modules = {
        editors.emacs.enable = true;
        editors.emacs.defaultEditor = true;
        dev.cc.enable = true;
        dev.python.enable = true;
        dev.rust.enable = true;
      };
    };
  };

  graphical = { pkgs, ... }: {
    imports = [ dev ];
    config = {
      modules = {
        applications.firefox.enable = true;
        applications.discord.enable = true;
        editors.vscode.enable = true;
        shell.alacritty.enable = true;
      };

      home.packages = with pkgs; [
        pkgs.element-desktop
        pkgs.slack
        pkgs.spotify
      ];
    };
  };

  desktop = _: {
    imports = [ graphical ];
    config = { modules = { desktop.active = "i3"; }; };
  };
}
