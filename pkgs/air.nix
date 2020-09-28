{ config, sources, ... }:
let
  overlay = import ./overlay.nix { inherit sources; };

  pkgs = import sources.nixpkgs {
    overlays = [ (import sources.nixpkgs-mozilla) ];
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        # required for lutris package
        "p7zip-16.02"
      ];
    };
  };

  categories = import ./categories.nix { inherit pkgs; };
in {
  inherit pkgs categories;
  toInstall = with categories;
    builtins.concatLists [
      # desktop NixOS box
      system

      # creation
      terminal
      tmux
      editor
      transform
      git
      development

      # discovery
      search

      # learning
      games

      # trust
      secrets

      # packaging
      nix
      archives

      # internet
      network
      ssh
      torrents
      mail

      # cloud
      google

      # disk
      filesystem

      # audio
      music
    ];
}
