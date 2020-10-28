{ config, sources, checkout, ... }:
let
  overlay = import "${checkout}/pkgs/overlay.nix" { inherit sources; };

  pkgs = import sources.nixpkgs {
    overlays = [ overlay.macbook ];
    config = { allowUnfree = true; };
  };

  categories = import "${checkout}/pkgs/categories.nix" { inherit pkgs; };
in {
  inherit pkgs categories;
  toInstall = with categories;
    builtins.concatLists [
      # work macbook
      system
      work
      organization

      # creation
      terminal
      tmux
      editor
      (pkgs.lib.remove pkgs.yq transform)
      git
      development

      # discovery
      search

      # trust
      secrets

      # packaging
      nix
      archives

      # internet
      network
      ssh
      mail

      # cloud
      google

      # disk
      filesystem

      # tools
      hashicorp

      # extras
      [ pkgs.firefox ]
    ];
}
