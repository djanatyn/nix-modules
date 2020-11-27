{ config, lib, pkgs, ... }:

{
  options = with lib; { ritual.configPath = mkOption { type = types.str; }; };

  config = {
    systemd = {
      services = {
        "ritual" = {
          serviceConfig = {
            Type = "oneshot";
            User = "root";
          };

          environment = {
            NIX_PATH = builtins.concatStringsSep ":" [
              "modules=/var/lib/nix-modules/modules"
              "nixpkgs=/var/lib/nixpkgs"
              "nixos-config=/var/lib/nix-modules/${config.ritual.configPath}"
            ];
          };

          script = ''
            export PATH=/run/current-system/sw/bin:$PATH
            ln -sfn $(nix-build '<nixpkgs/nixos>' -A system) /var/lib/latest-ritual
          '';
        };
      };
    };
  };
}
