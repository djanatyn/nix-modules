{ config, sources, checkout, ... }:
let
  overlay = import "${checkout}/pkgs/overlay.nix" { inherit sources; };

  pkgs = import sources.nixpkgs { config = { allowUnfree = true; }; };
  categories = import "${checkout}/pkgs/categories.nix" { inherit pkgs; };
in {
  inherit pkgs categories;
  toInstall = with categories;
    builtins.concatLists [
      # work macbook
      system
      work

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
