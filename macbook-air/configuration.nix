{ config, ... }:
let
  checkout = "/Users/jonathanstrickland/repos/nix-modules";

  sources = import "${checkout}/nix/sources.nix" { };
  packages = import ./pkgs.nix { inherit config sources checkout; };

  inherit (packages) pkgs;
in {
  imports = [
    (import "${sources.home-manager}/nix-darwin")
    "${checkout}/modules/macos"
  ];

  macos.trustedUsers = [ "jonathanstrickland" ];

  # darwin nix
  environment.darwinConfig = "${checkout}/macbook-air/configuration.nix";

  # prefer zsh + emacs
  environment.loginShell = pkgs.zsh;

  # services
  services.nix-daemon.enable = true;

  environment.systemPackages = packages.toInstall;
}
