{ config, lib, pkgs, ... }:

let
  zshrcLocal = config.home.homeDirectory + "/.zshrc.local";
  zshenvLocal = config.home.homeDirectory + "/.zshenv.local";
in {
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";

    # plugins
    enableAutosuggestions = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    autocd = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "colored-man-pages" "command-not-found" "git" "sudo" ];
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
        file = "p10k";
      }
      {
        name = "alias-tips";
        src = pkgs.fetchFromGitHub {
          owner = "djui";
          repo = "alias-tips";
          rev = "45e4e97ba4ec30c7e23296a75427964fc27fb029";
          sha256 = "1br0gl5jishbgi7whq4kachlcw6gjqwrvdwgk8l39hcg6gwkh4ji";

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
      # Local environment
      [[ ! -f ${zshenvLocal} ]] || source ${zshenvLocal}
    '';

    initExtra = ''
      # Functions
      fpath=(${./zshfn} "''${fpath[@]}")
      autoload Uz ${./zshfn}/*(.:t)

      # Local environment
      [[ ! -f ${zshrcLocal} ]] || source ${zshrcLocal}
    '';

  };
}
