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
      home.file.".tmuxp/pivotal.yaml".text = lib.generators.toYAML { } {
        session_name = "pivotal";
        windows = [
          {
            window_name = "control-plane";
            start_directory = "~/repos/cf-automation";
            panes = [{
              shell_command = [
                "source ./targets/control-plane/ops-manager-credhub-bosh && bosh vms"
              ];
            }];
          }
          {
            window_name = "canary";
            start_directory = "~/repos/cf-automation";
            panes = [{
              shell_command = [
                "source ./targets/sandbox/ops-manager-credhub-bosh && bosh vms"
              ];
            }];
          }
          {
            window_name = "nonprod";
            start_directory = "~/repos/cf-automation";
            panes = [{
              shell_command = [
                "source ./targets/non-prod/ops-manager-credhub-bosh && bosh vms"
              ];
            }];
          }
          {
            window_name = "production";
            start_directory = "~/repos/cf-automation";
            panes = [{
              shell_command = [
                "source ./targets/production/ops-manager-credhub-bosh && bosh vms"
              ];
            }];
          }
        ];
      };

      home.file.".tmuxp/work.yaml".text = lib.generators.toYAML { } {
        session_name = "workin'";
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
