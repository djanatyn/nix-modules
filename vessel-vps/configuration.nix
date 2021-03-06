{ config, ... }:
let
  sources = import ../nix/sources.nix;
  overlay = import ../pkgs/overlay.nix { inherit sources; };

  pkgs = import sources.nixpkgs {
    overlays = [ overlay.vessel (import sources.nixpkgs-mozilla) ];
    config = { allowUnfree = true; };
  };
in with pkgs; {
  imports = [
    "${sources.nixpkgs}/nixos/modules/profiles/qemu-guest.nix"
    <modules/srht-ci>
    <modules/monitoring>
    <modules/pri>
    (import "${sources.home-manager}/nixos")
  ];

  # system state is from 18.08
  system.stateVersion = "18.08";

  # this system is managed by krops
  environment.variables.NIX_PATH = lib.mkForce "/var/src";

  srht-ci.enable = true;

  # user account
  users = {
    users = {
      root = {
        openssh.authorizedKeys.keys = [
          "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBIOiCqSWnlyk3Efun+zeqeR9afQ3gwYV0QF2l9Us15F8BnNkEqZMvVYQipZUJKwyV4P8X7yJP+2G/KGVhW5kG+4= flowercluster"
        ];
      };

      djanatyn = {
        isNormalUser = true;
        description = "Jonathan Strickland";
        openssh.authorizedKeys.keys = [
          "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDFQPTKrT397qtitl0hHkl3HysPfnpEm/WmO9f4dC4kLkrHIgs2t9Yvd6z+8C/hufW+e0cVug3sb6xHWFI78+/eCSRQpPWVsE3e6/U5R/EGJqylPLEa/SmB4hB6LpsCnJkeHnD/sVBz/EjFD29wifLFq0Y5keMdxbvUMjkGrep0CD1guYseFJOdFpLF3A5GAnnP2CHgvOT7/Pd2mym5f2Mxp17SF1iYAsx9xId5o6YbmKldz3BN51N+9CROSg9QWuSNCvA7qjflBIPtnBVZFvIN3U56OECZrv9ZY4dY2jrsUGvnGiyBkkdxw4+iR9g5kjx9jPnqZJGSEjWOYSl+2cEQGvvoSF8jPiH8yLEfC+CyFrb5FMbdXitiQz3r3Xy+oLhj8ULhnDdWZpRaJYTqhdS12R9RCoUQyP7tlyMawMxsiCUPH/wcaGInzpeSLZ5BSzVFhhMJ17TX+OpvIhWlmvpPuN0opmfaNGhVdBGFTNDfWt9jjs/OHm6RpVXacfeflP62xZQBUf3Hcat2JOqj182umjjZhBPDCJscfv52sdfkiqwWIc/GwdmKt5HqU+dX7lCFJ1OGF2ymnGEnkUwW+35qX8g2P+Vc4s28MmaO5M1R5UsMFnhtFbLdfLFKn2PEvepvIqyYFMziPzEBya4zBUch/9sd6UN3DV+rA/JB/rBApw== djanatyn@nixos"
          "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBIOiCqSWnlyk3Efun+zeqeR9afQ3gwYV0QF2l9Us15F8BnNkEqZMvVYQipZUJKwyV4P8X7yJP+2G/KGVhW5kG+4= flowercluster"
        ];
      };
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

    nat = {
      enable = true;
      externalInterface = "ens3";
      internalInterfaces = [ "wg0" ];
    };

    wireguard.interfaces = {
      wg0 = {
        ips = [ "10.100.0.1/24" ];

        listenPort = 51820;

        privateKeyFile = "/var/src/secrets/wireguard/privateKey";

        peers = [
          {
            publicKey = "5H7TcLg6gdrtBEeh8PaJmGKN0xOUVQez+GgEi+YMKGI=";
            allowedIPs = [ "10.100.0.2/32" ];
          }
          {
            publicKey = "HOhxP72Br3SDzeX39mBsTsuV1sZ9SNxPjaklxRrQ5Rs=";
            allowedIPs = [ "10.100.0.3/32" ];
          }
          {
            publicKey = "McJJ4d6OiSGlV2f8GcN4Do/ZmAXf5NsCxjypv9ybjyw=";
            allowedIPs = [ "10.100.0.4/32" ];
          }
        ];
      };
    };

    interfaces."ens3".ipv4.addresses = [{
      address = "167.114.113.126";
      prefixLength = 24;
    }];

    firewall = {
      enable = true;
      allowedTCPPorts = [ 8888 7777 51820 8080 8384 ];
      allowedUDPPorts = [ 7777 51820 8080 ];
    };
  };

  services = {
    miniflux = {
      enable = true;
      config = { "LISTEN_ADDR" = "10.100.0.1:8080"; };
    };

    syncthing = {
      enable = true;
      user = "djanatyn";
      dataDir = "/home/djanatyn/syncthing";
      configDir = "/home/djanatyn/.config/syncthing";
      guiAddress = "10.100.0.1:8384";
    };

    factorio = {
      enable = true;
      password = lib.fileContents /var/src/secrets/factorio/password;
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

  environment.systemPackages = [
    zsh
    openjdk8
    consul
    nomad
    vim
    exa
    git
    python
    tmux
    fzy
    zip
    unzip
    starship
    cachix
  ];

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
