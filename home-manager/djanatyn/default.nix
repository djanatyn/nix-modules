{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.djanatyn;
  system = pkgs.stdenv.system;
  tmux = import ./tmux.nix;
in {
  options.djanatyn = {
    username = mkOption {
      type = types.str;
      default = "djanatyn";
    };

    email = {
      mbsync.enable = mkEnableOption "fetch mail";

      address = mkOption {
        type = types.str;
        default = "djanatyn@gmail.com";
      };
    };

    gpg-agent.enable = mkEnableOption "run gpg-agent";
    music.enable = mkEnableOption "listen to music";
  };

  config = {
    home.file = {
      ".zshrc".text = fileContents ./files/.zshrc;
      ".tmux.conf".text = fileContents ./files/.tmux.conf;
      ".doom.d".source = ./files/.doom.d;
      ".tmuxp/pivotal.yaml".text = lib.generators.toYAML { } tmux.pivotal;
      ".tmuxp/nix.yaml".text = lib.generators.toYAML { } tmux.nix;
      ".tmuxp/ansible.yaml".text = lib.generators.toYAML { } tmux.ansible;
    } // optionalAttrs (cfg.email.mbsync.enable) {
      ".mbsyncrc".text = fileContents ./files/.mbsyncrc;
      ".davmail.properties".text = fileContents ./files/.davmail.properties;
    } // optionalAttrs (system == "x86_64-linux") {
      ".Xresources".text = fileContents ./files/.Xresources;
    };

    programs = {
      git = {
        enable = true;
        userName = cfg.username;
        userEmail = cfg.email.address;
      };
    };

    services = {
      gpg-agent = {
        enable = cfg.gpg-agent.enable;
        enableSshSupport = true;
        extraConfig = ''
          allow-emacs-pinentry
        '';
      };

      mbsync = { enable = cfg.email.mbsync.enable; };

      mpd = {
        enable = cfg.music.enable;
      } // optionalAttrs (system == "x86_64-linux") {
        extraConfig = ''
          audio_output {
            type "alsa"
            name "ALSA Device"
          }
        '';
      };
    };
  };
}
