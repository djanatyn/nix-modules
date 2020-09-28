{ config, ... }:
let
  sources = import ./nix/sources.nix { };
  overlay = import ./overlay.nix { inherit sources; };

  pkgs = import sources.nixpkgs {
    overlays = [ overlay.voidheart (import sources.nixpkgs-mozilla) ];
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
      virtualisation

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
      study

      # trust
      secrets

      # packaging
      nix
      archives
      patches

      # languages
      haskell
      java
      dhall

      # internet
      network
      ssh
      browser
      torrents
      mail

      # cloud
      google

      # disk
      filesystem

      # social
      chat
      streaming

      # ui
      xorg

      # audio
      music
      sound

      # voidheart-specific rituals
      voidheart
    ];
}
