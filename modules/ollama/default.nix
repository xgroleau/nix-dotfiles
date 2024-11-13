{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.mealie;
in
{

  options.modules.ollama = with lib.types; {
    enable = lib.mkEnableOption "Ollama, an ai gpt, you know what it is";

    port = lib.mkOption {
      type = types.port;
      default = 11434;
      description = "The port to use";
    };

    dataDir = lib.mkOption {
      type = types.str;
      description = "Path to where the data will be stored";
    };
  };

  config =
    let
      homePath = "${cfg.dataDir}/home";
      modelsPath = "${cfg.dataDir}/models";
    in
    lib.mkIf cfg.enable {
      services.ollama = {
        enable = true;
        listenAddress = "127.0.0.1:${toString cfg.port}";
        writablePaths = [
          homePath
          modelsPath
        ];
        home = homePath;
        models = modelsPath;
      };

      systemd.tmpfiles.settings.ollama = {
        "${cfg.dataDir}" = {
          d = {
            mode = "0755";
            user = "root";
          };
        };
      };
    };
}
