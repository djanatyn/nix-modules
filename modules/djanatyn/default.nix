{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.djanatyn;
  tmux = import ./tmux.nix;
in {
  options = {
    djanatyn.groups = mkOption {
      type = types.listOf types.str;
      default = [ "wheel" "networkmanager" "docker" "video" "audio" ];
    };

    djanatyn.username = mkOption {
      type = types.str;
      default = "djanatyn";
    };

    djanatyn.email = {
      mbsync.enable = mkEnableOption "enable mbsync";

      address = mkOption {
        type = types.str;
        default = "djanatyn@gmail.com";
      };
    };

    djanatyn.enableGpgAgent = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = {
    users.users."${cfg.username}" = {
      name = cfg.username;
      shell = pkgs.zsh;
    } // optionalAttrs (pkgs.stdenv.system != "x86_64-darwin") {
      isNormalUser = true;
      extraGroups = cfg.groups;
    };

    home-manager.users."${cfg.username}" = with lib; {
      home.file = {
        # zsh
        ".zshrc".text = fileContents ./files/zshrc;

        # tmux
        ".tmux.conf".text = fileContents ./files/tmux.conf;

        # emacs
        ".doom.d".source = ./files/doom.d;

        # tmuxp
        ".tmuxp/pivotal.yaml".text = lib.generators.toYAML { } tmux.pivotal;
        ".tmuxp/nix.yaml".text = lib.generators.toYAML { } tmux.nix;
        ".tmuxp/ansible.yaml".text = lib.generators.toYAML { } tmux.ansible;
      } // optionalAttrs (cfg.email.mbsync.enable) {
        ".mbsyncrc".text = fileContents ./files/mbsyncrc;
        ".davmail.properties".text = fileContents ./files/davmail.properties;
      } // optionalAttrs (pkgs.stdenv.system == "x86_64-linux") {
        ".Xresources".text = fileContents ./files/Xresources;
      };

      services.gpg-agent = {
        enable = cfg.enableGpgAgent;
        enableSshSupport = true;
      };

      programs.git = {
        enable = true;
        userName = cfg.username;
        userEmail = cfg.email.address;
      };
    };
  };
}
