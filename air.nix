{ config, ... }:
let
  sources = import ./nix/sources.nix { };
  packages = import ./pkgs/air.nix { inherit config sources; };
  inherit (packages) pkgs;

  checkout = "/Users/jonathanstrickland/repos/nix-modules";
in {
  imports = [
    (import "${sources.home-manager}/nix-darwin")
    "${checkout}/modules/macos"
    "${checkout}/modules/djanatyn"
  ];

  macos.trustedUsers = [ "jonathanstrickland" ];
  djanatyn = {
    username = "jonathanstrickland";
    groups = [ "wheel" "docker" ];
    email.address = "djanatyn@gmail.com";
  };

  # darwin nix
  environment.darwinConfig = "${checkout}/air.nix";

  # prefer zsh + emacs
  environment.loginShell = pkgs.zsh;
  environment.variables.EDITOR = "emacsclient";

  # services
  services.nix-daemon.enable = true;

  environment.systemPackages = packages.toInstall;
}
