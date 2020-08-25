{ config, ... }:
let
  sources = import ./niv/sources.nix { };

  overlay = self: super:
    with super; {
      work-rebuild = writeScriptBin "work-rebuild" ''
        #!${stdenv.shell}
        exec darwin-rebuild \
          -I "darwin-config=''${HOME}/repos/nix-modules/work.nix" \
          "$@"
      '';
    };

  pkgs = import sources.nixpkgs {
    overlays = [ overlay (import sources.nixpkgs-mozilla) ];
    config = { allowUnfree = true; };
  };
in {
  imports = [
    (import "${sources.home-manager}/nix-darwin")
    ./modules/macos
    ./modules/djanatyn
  ];

  macos.username = "stricklanj";
  djanatyn.username = "stricklanj";
  djanatyn.email = "stricklanj@ae.com";

  # prefer zsh + emacs
  environment.loginShell = pkgs.zsh;
  environment.variables.EDITOR = "emacsclient";

  environment.systemPackages = with pkgs; [
    # overlay packages
    work-rebuild

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
