{ config, ... }:
let
  checkout = "/Users/stricklanj/repos/nix-modules";

  sources = import "${checkout}/nix/sources.nix" { };
  packages = import ./pkgs.nix { inherit config sources checkout; };

  inherit (packages) pkgs;
in {
  imports = [
    (import "${sources.home-manager}/nix-darwin")
    "${checkout}/modules/macos"
  ];

  macos.trustedUsers = [ "stricklanj" ];

  # darwin nix
  environment.darwinConfig = "${checkout}/macbook-work/configuration.nix";

  # prefer zsh + emacs
  environment.loginShell = pkgs.zsh;
  environment.variables.EDITOR = "emacsclient";

  environment.systemPackages = packages.toInstall;
}
