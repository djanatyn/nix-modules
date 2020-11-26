{ config, lib, pkgs, ... }:
with lib;
let cfg = config.pri;
in {
  options = {
    pri.groups = mkOption {
      type = types.listOf types.str;
      default = [ "wheel" "networkmanager" "docker" "video" "audio" ];
    };

    pri.username = mkOption {
      type = types.str;
      default = "pripripripripri";
    };

    pri.email = mkOption {
      type = types.str;
      default = "pritika.dasgupta@gmail.com";
    };

    pri.setKeys = mkOption {
      type = types.bool;
      default = true;
    };

    pri.keys = mkOption {
      type = types.listOf types.str;
      default = [ ];
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

      programs.git = {
        enable = true;
        userName = cfg.username;
        userEmail = cfg.email;
      };
    };
  };
}
