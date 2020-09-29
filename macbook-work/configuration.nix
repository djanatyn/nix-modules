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
    "${checkout}/modules/djanatyn"
  ];

  macos.trustedUsers = [ "stricklanj" ];
  djanatyn = {
    username = "stricklanj";
    email = {
      address = "stricklanj@ae.com";
      mbsync.enable = true;
    };
  };

  # darwin nix
  environment.darwinConfig = "${checkout}/work-macbook/configuration.nix";

  # prefer zsh + emacs
  environment.loginShell = pkgs.zsh;
  environment.variables.EDITOR = "emacsclient";

  environment.systemPackages = packages.toInstall;
}
