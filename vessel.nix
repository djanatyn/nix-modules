{ config, ... }:
let
  sources = import ./niv/sources.nix;

  pkgs = import sources.nixpkgs {
    overlays = [ (import sources.nixpkgs-mozilla) ];
    config = { allowUnfree = true; };
  };
in with pkgs; {
  imports = [
    "${sources.nixpkgs}/nixos/modules/profiles/qemu-guest.nix"
    "${sources.nixpkgs}/nixos/modules/services/misc/sourcehut"
    <modules/consul>
    <modules/nomad>
    <modules/terraria>
    <modules/factorio>
    <modules/monitoring>
    <modules/djanatyn>
    <modules/pri>
    (import "${sources.home-manager}/nixos")
  ];

  # system state is from 18.08
  system.stateVersion = "18.08";

  # this system is managed by krops
  environment.variables.NIX_PATH = lib.mkForce "/var/src";

  # user account
  users = {
    users.root = {
      openssh.authorizedKeys.keys = [
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBIOiCqSWnlyk3Efun+zeqeR9afQ3gwYV0QF2l9Us15F8BnNkEqZMvVYQipZUJKwyV4P8X7yJP+2G/KGVhW5kG+4= flowercluster"
      ];
    };

    users.djanatyn = {
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDFQPTKrT397qtitl0hHkl3HysPfnpEm/WmO9f4dC4kLkrHIgs2t9Yvd6z+8C/hufW+e0cVug3sb6xHWFI78+/eCSRQpPWVsE3e6/U5R/EGJqylPLEa/SmB4hB6LpsCnJkeHnD/sVBz/EjFD29wifLFq0Y5keMdxbvUMjkGrep0CD1guYseFJOdFpLF3A5GAnnP2CHgvOT7/Pd2mym5f2Mxp17SF1iYAsx9xId5o6YbmKldz3BN51N+9CROSg9QWuSNCvA7qjflBIPtnBVZFvIN3U56OECZrv9ZY4dY2jrsUGvnGiyBkkdxw4+iR9g5kjx9jPnqZJGSEjWOYSl+2cEQGvvoSF8jPiH8yLEfC+CyFrb5FMbdXitiQz3r3Xy+oLhj8ULhnDdWZpRaJYTqhdS12R9RCoUQyP7tlyMawMxsiCUPH/wcaGInzpeSLZ5BSzVFhhMJ17TX+OpvIhWlmvpPuN0opmfaNGhVdBGFTNDfWt9jjs/OHm6RpVXacfeflP62xZQBUf3Hcat2JOqj182umjjZhBPDCJscfv52sdfkiqwWIc/GwdmKt5HqU+dX7lCFJ1OGF2ymnGEnkUwW+35qX8g2P+Vc4s28MmaO5M1R5UsMFnhtFbLdfLFKn2PEvepvIqyYFMziPzEBya4zBUch/9sd6UN3DV+rA/JB/rBApw== djanatyn@nixos"
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBIOiCqSWnlyk3Efun+zeqeR9afQ3gwYV0QF2l9Us15F8BnNkEqZMvVYQipZUJKwyV4P8X7yJP+2G/KGVhW5kG+4= flowercluster"
      ];
    };

    # elegy for hallownest
    motd = ''
      In wilds beyond they speak your name with reverence and regret,
      For none could tame our savage souls yet you the challenge met,
      Under palest watch, you taught, we changed, base instincts were redeemed,
      A world you gave to bug and beast as they had never dreamed.

    '';
  };

  networking = {
    hostName = "vessel";
    useDHCP = false;
    nameservers = [ "8.8.8.8" ];
    defaultGateway = "167.114.113.1";

    interfaces."ens3".ipv4.addresses = [{
      address = "167.114.113.126";
      prefixLength = 24;
    }];

    firewall = {
      enable = true;
      allowedTCPPorts = [ 8888 7777 ];
      allowedUDPPorts = [ 7777 ];
    };
  };

  services = {
    voidheart.factorio.enable = true;

    sourcehut = {
      enable = true;
      services = [ "meta" "git" "paste" ];
      settings = {
        webhooks = {
          private-key =
            lib.fileContents /var/src/secrets/sourcehut/webhooks/private-key;
        };
        "sr.ht" = {
          secret-key = lib.fileContents /var/src/secrets/sourcehut/secret-key;
        };
        "meta.sr.ht" = { origin = "vessel.voidheart.io"; };
      };
    };

    postgresql = {
      enable = true;
      package = postgresql_10;
      ensureDatabases = [ "root" "sourcehut" ];
      ensureUsers = [{
        name = "root";
        ensurePermissions = { "DATABASE root" = "ALL PRIVILEGES"; };
      }];
    };

    terraria = {
      enable = true;
      password = lib.fileContents /var/src/secrets/terraria-password;
    };

    openssh = {
      enable = true;
      ports = [ 8888 ];
    };

    fail2ban.enable = true;
    flowercluster.monitoring.enable = true;
  };

  nixpkgs.config = { allowUnfree = true; };

  virtualisation.docker.enable = true;
  security.sudo.wheelNeedsPassword = false;

  environment.systemPackages =
    [ zsh openjdk8 consul nomad vim exa git python tmux fzy zip unzip ];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/336f9da5-3a24-4096-b7be-e526207575bb";
      fsType = "ext4";
    };
  };

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/sda";
  };
}
