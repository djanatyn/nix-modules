{ config, pkgs, lib, ... }:
let
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "8bbefa77f7e95c80005350aeac6fe425ce47c288";
    ref = "master";
  };
in {
  imports = [
    <nixpkgs/nixos/modules/virtualisation/google-compute-image.nix>
    <modules/consul>
    <modules/nomad>
    <modules/terraria>
    <modules/monitoring>
    <modules/sourcehut>
    <modules/factorio>
    <modules/djanatyn>
    <modules/pri>
    (import "${home-manager}/nixos")
  ];

  # system state is from 18.08
  system.stateVersion = "18.08";

  # flowercluster services
  # ======================
  flowercluster.services.sourcehut.enable = true;
  flowercluster.services.monitoring.enable = true;
  flowercluster.services.factorio.enable = true;

  # user account
  users.users.djanatyn = {
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDFQPTKrT397qtitl0hHkl3HysPfnpEm/WmO9f4dC4kLkrHIgs2t9Yvd6z+8C/hufW+e0cVug3sb6xHWFI78+/eCSRQpPWVsE3e6/U5R/EGJqylPLEa/SmB4hB6LpsCnJkeHnD/sVBz/EjFD29wifLFq0Y5keMdxbvUMjkGrep0CD1guYseFJOdFpLF3A5GAnnP2CHgvOT7/Pd2mym5f2Mxp17SF1iYAsx9xId5o6YbmKldz3BN51N+9CROSg9QWuSNCvA7qjflBIPtnBVZFvIN3U56OECZrv9ZY4dY2jrsUGvnGiyBkkdxw4+iR9g5kjx9jPnqZJGSEjWOYSl+2cEQGvvoSF8jPiH8yLEfC+CyFrb5FMbdXitiQz3r3Xy+oLhj8ULhnDdWZpRaJYTqhdS12R9RCoUQyP7tlyMawMxsiCUPH/wcaGInzpeSLZ5BSzVFhhMJ17TX+OpvIhWlmvpPuN0opmfaNGhVdBGFTNDfWt9jjs/OHm6RpVXacfeflP62xZQBUf3Hcat2JOqj182umjjZhBPDCJscfv52sdfkiqwWIc/GwdmKt5HqU+dX7lCFJ1OGF2ymnGEnkUwW+35qX8g2P+Vc4s28MmaO5M1R5UsMFnhtFbLdfLFKn2PEvepvIqyYFMziPzEBya4zBUch/9sd6UN3DV+rA/JB/rBApw== djanatyn@nixos"
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBIOiCqSWnlyk3Efun+zeqeR9afQ3gwYV0QF2l9Us15F8BnNkEqZMvVYQipZUJKwyV4P8X7yJP+2G/KGVhW5kG+4= flowercluster"
    ];
  };

  # enable postgres
  # https://nixos.wiki/wiki/PostgreSQL
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_10;
    ensureDatabases = [ "root" "sourcehut" ];
    ensureUsers = [{
      name = "root";
      ensurePermissions = { "DATABASE root" = "ALL PRIVILEGES"; };
    }];
  };

  # nixpkgs
  nixpkgs.config.allowUnfree = true;

  # terraria: journey's end!
  services.terraria.enable = true;
  services.terraria.password = lib.fileContents /var/secrets/terraria-password;

  # enable docker
  virtualisation.docker.enable = true;

  # networking
  # ==========
  networking.hostName = "sahaquiel";
  networking.interfaces.eth0.useDHCP = true;

  networking.firewall.enable = true;
  networking.firewall.allowedUDPPorts = [ 25565 7777 8388 34197 ];
  networking.firewall.allowedTCPPorts = [ 25565 7777 8388 ];
  services.fail2ban.enable = true;

  services.traefik.enable = true;

  # sudo
  # ====
  security.sudo.wheelNeedsPassword = false;

  # packages
  # ========
  environment.systemPackages = with pkgs; [
    zsh
    openjdk8
    consul
    nomad
    vim
    exa
    git
    python
    tmux
  ];
}
