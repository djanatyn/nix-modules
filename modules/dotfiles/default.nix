{ config, lib, ... }:
with lib;
let cfg = config.dotfiles;
in {
  options = {
    dotfiles.enable = mkEnableOption "dotfiles";
    dotfiles.username = mkOption {
      type = types.str;
      description = "username for home-manager dotfile configuration";
    };
  };

  config = mkIf cfg.enable {
    home-manager.users."${cfg.username}" = {
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
