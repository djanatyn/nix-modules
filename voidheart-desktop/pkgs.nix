{ config, sources, checkout, ... }:
let
  overlay = import "${checkout}/pkgs/overlay.nix" { inherit sources; };

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

  categories = import "${checkout}/pkgs/categories.nix" { inherit pkgs; };
in {
  inherit pkgs categories;
  toInstall = with categories;
    builtins.concatLists [
      # desktop NixOS box
      system
      virtualisation

      # creation
      terminal
      organization
      tmux
      editor
      transform
      git
      development

      # discovery
      search

      # learning
      games
      gameboy
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
