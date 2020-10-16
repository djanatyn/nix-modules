{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.djanatyn;
  system = pkgs.stdenv.system;
  tmux = import ./tmux.nix;
  organize-rules = import ./organize.nix;
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
    home.file = with generators;
      {
        ".zshrc".text = fileContents ./files/.zshrc;
        ".tmux.conf".text = fileContents ./files/.tmux.conf;
        ".doom.d".source = ./files/.doom.d;
        ".config/organize/config.yaml".text = toYAML { } organize-rules;
        ".tmuxp/pivotal.yaml".text = toYAML { } tmux.pivotal;
        ".tmuxp/nix.yaml".text = toYAML { } tmux.nix;
        ".tmuxp/ansible.yaml".text = toYAML { } tmux.ansible;
      } // optionalAttrs (cfg.email.mbsync.enable) {
        ".mbsyncrc".text = fileContents ./files/.mbsyncrc;
        ".davmail.properties".text = fileContents ./files/.davmail.properties;
      };

    xresources = {
      properties = {
        "urxvt.font" = "xft:Terminess Powerline";
        "urxvt.scrollbar" = false;
        "urxvt*depth" = 32;
        "urxvt*background" = "rgba:0000/0000/0200/c800";
      };

      extraConfig = builtins.readFile (pkgs.fetchFromGitHub {
        owner = "arcticicestudio";
        repo = "nord-xresources";
        rev = "ad8d70435ee0abd49acc7562f6973462c74ee67d";
        sha256 = "1labc69iis5nx7cz88lkp0jsm5aq3ywih15g1fhc4814hv0x0ckf";
      } + "/src/nord");
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
