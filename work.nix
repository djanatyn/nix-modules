{ config, ... }:
let
  sources = import ./niv/sources.nix { };
  checkout = "/Users/stricklanj/repos/nix-modules";

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

  macos.trustedUsers = [ "stricklanj" ];
  djanatyn = {
    username = "stricklanj";
    email = {
      address = "stricklanj@ae.com";
      mbsync.enable = true;
    };
  };

  # darwin nix
  environment.darwinConfig = "${checkout}/work.nix";

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
    broot

    # browser
    brotab

    # email
    davmail
    isync
    notmuch

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

    # editor
    emacs26-nox

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

    # jira
    go-jira

    # nix
    nixfmt
    nix-prefetch-scripts
    niv
    direnv
  ];
}
