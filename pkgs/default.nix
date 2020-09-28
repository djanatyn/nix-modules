{ pkgs }:

let categories = import ./categories.nix { inherit pkgs; };
in { voidheart = import ./voidheart.nix { inherit categories; }; }
