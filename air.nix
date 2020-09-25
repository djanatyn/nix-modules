{ config, ... }:
let
  sources = import ./niv/sources.nix { };
  checkout = "/Users/jonathanstrickland/repos/nix-modules";

  pkgs = import sources.nixpkgs {
    overlays = [ (import sources.nixpkgs-mozilla) ];
    config = { allowUnfree = true; };
  };
in {
  imports = [
    (import "${sources.home-manager}/nix-darwin")
    "${checkout}/modules/macos"
    "${checkout}/modules/djanatyn"
  ];

  macos.trustedUsers = "jonathanstrickland";
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

  environment.systemPackages = with pkgs; [
    # system utilities
    bat
    exa
    jq
    tree
    moreutils
    procs

    # filesystem
    du-dust

    # searching
    fd
    sd
    ripgrep
    fzf

    # shell
    zsh
    tmux
    tmuxp

    # configuration
    chezmoi

    # development
    entr
    clang
    cloc
    tig

    # secrets
    gnupg
    pass
    pwgen
    diceware

    # ssh
    assh
    sshpass

    # nix
    nixfmt

    # music
    ncmpcpp
  ];
}
