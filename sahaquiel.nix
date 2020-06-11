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
    (import "${home-manager}/nixos")
    <modules/consul>
    <modules/nomad>
    <modules/terraria>
    <modules/monitoring>
    <modules/djanatyn>
    <modules/sourcehut>
    <modules/factorio>
  ];

  # system state is from 18.08
  system.stateVersion = "18.08";

  # latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # flowercluster services
  # ======================
  flowercluster.services.sourcehut.enable = true;
  flowercluster.services.monitoring.enable = true;
  flowercluster.services.factorio.enable = true;

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
