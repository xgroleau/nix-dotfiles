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
        editors.emacs = {
          enable = true;
          defaultEditor = true;
        };

        dev = {
          cc.enable = true;
          python.enable = true;
          rust.enable = true;
        };
      };
    };
  };

  macos = { pkgs, ... }: {
    config.modules = {
      dev.common.enable = true;
      editors.nvim.enable = true;
      nixpkgs.enable = true;
      shell.zellij.enable = true;
      shell.zsh.enable = true;
      editors.emacs = {
        enable = true;
        defaultEditor = true;
      };

      dev = {
        cc.enable = true;
        python.enable = true;
        rust.enable = true;
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
        pkgs.beeper
        pkgs.mattermost-desktop
        pkgs.roam
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
