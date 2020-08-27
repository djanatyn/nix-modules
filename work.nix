{ config, ... }:
let
  sources = import ./niv/sources.nix { };
  username = "stricklanj";
  checkout = "/Users/${username}/repos/nix-modules";

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

  macos.username = username;
  djanatyn.username = username;
  djanatyn.email = "stricklanj@ae.com";

  # prefer zsh + emacs
  environment.loginShell = pkgs.zsh;
  environment.darwinConfig = "${checkout}/work.nix";
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
    broot

    # browser
    brotab

    # nushell???
    nushell

    # searching
    fd
    sd
    ripgrep
    fzf

    # shell
    starship
    tmux
    tmuxp

    # config
    dhall
    dhall-bash
    dhall-json

    # development
    entr
    clang
    cloc
    tokei
    hyperfine
    gitAndTools.diff-so-fancy
    gitAndTools.pre-commit
    gitAndTools.git-annex
    gitAndTools.git-annex-utils
    tig

    # secrets
    gnupg
    pass
    pwgen
    diceware

    # ssh
    assh
    sshpass
    sshuttle

    # mail
    davmail

    # nix
    nixfmt
    nix-prefetch-scripts
    niv
    direnv
  ];
}
