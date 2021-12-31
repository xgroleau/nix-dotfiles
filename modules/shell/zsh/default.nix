{ config, lib, pkgs, ... }:

let
  zshrcLocal = config.home.homeDirectory + "/.zshrc.local";
  zshenvLocal = config.home.homeDirectory + "/.zshenv.local";
in {
  environments.pathsToLink = [ "/share/zsh" ];
  programs.zsh = {
    enable = true;

    # plugins
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    autocd = true;
    cdpath = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "sudo" "colored-man-pages" ];
    };
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./p10k-config;
        file = "p10k.zsh";
      }
      {
        name = "alias-tips";
        src = pkgs.fetchFomGithub {
          owner = "djui";
          repo = "alias-tips";
          rev = "45e4e97ba4ec30c7e23296a75427964fc27fb029";
          sha256 =
            "5CFF043D2ACDB6C8B5AFFD63372748C26392ED298842C0B8355CD8D30682FEDA";
        };
        file = "alias-tips.plugin.zsh";
      }
    ];

    shellAliases = {
      # helpers
      grep = "grep --color=auto";
      df = "df -h";
      du = "du -h";

      # tmux
      ta = "tmux attach";
      tat = "tmux attach -t";
      tns = "tmux new-session -s";
      tls = "tmux ls";

      # emacs
      em = "emacsclient -nw -a ''";
      emh = "emacsclient -c -a ''";
    };

    envExtra = ''
      [[ ! -f ${zshenvLocal} ]] || source ${zshenvLocal}
    '';

    initExtra = ''
      [[ ! -f ${zshrcLocal} ]] || source ${zshrcLocal}
    '';

  };
}
