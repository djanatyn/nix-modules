{ config, lib, pkgs, ... }:
with lib;
let cfg = config.djanatyn;
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

    djanatyn.email = mkOption {
      type = types.str;
      default = "djanatyn@gmail.com";
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
    } // (if (pkgs.stdenv.system != "x86_64-darwin") then {
      isNormalUser = true;
      extraGroups = cfg.groups;
    } else
      { });

    home-manager.users."${cfg.username}" = {
      # zsh
      home.file.".zshrc".text = lib.fileContents ./files/zshrc;

      # tmux
      home.file.".tmux.conf".text = lib.fileContents ./files/tmux.conf;

      # emacs
      home.file.".doom.d".source = ./files/doom.d;

      services.gpg-agent = {
        enable = cfg.enableGpgAgent;
        enableSshSupport = true;
      };

      programs.git = {
        enable = true;
        userName = cfg.username;
        userEmail = cfg.email;
      };

      # play tmuxp
      home.file.".tmuxp/play.yaml".text = lib.generators.toYAML { } {
        session_name = "play";
        windows = [
          {
            window_name = "nixpkgs";
            start_directory = "~/repos/nixpkgs";
            panes = [ "blank" ];
          }
          {
            window_name = "nix-modules";
            start_directory = "~/repos/nix-modules";
            panes = [ "blank" ];
          }
        ];
      };

      # work tmuxp
      home.file.".tmuxp/work.yaml".text = lib.generators.toYAML { } {
        session_name = "workin'";
        windows = [
          {
            window_name = "nixpkgs";
            start_directory = "~/.nix-defexpr/channels_root/nixpkgs";
            panes = [{
              shell_command = [ "bat ~/.nixpkgs/darwin-configuration.nix" ];
            }];
          }
          {
            window_name = "aeo-nix";
            start_directory = "~/repos/aeo-nix";
            panes = [ "blank" ];
          }
          {
            window_name = "ansible-inventory";
            start_directory = "~/repos/ansible-inventory";
            panes = [ "blank" ];
          }
          {
            window_name = "ansible-playbooks";
            start_directory = "~/repos/ansible-playbooks";
            panes = [ "blank" ];
          }
        ];
      };
    };
  };
}
