{ config, lib, pkgs, ... }:
let
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "8bbefa77f7e95c80005350aeac6fe425ce47c288";
    ref = "master";
  };
in {
  imports = [
    (import "${home-manager}/nix-darwin")
    ./modules/macos
    ./modules/djanatyn
  ];

  macos.username = "stricklanj";
  djanatyn.username = "stricklanj";
  djanatyn.email = "djanatyn@gmail.com";

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

    # searching
    ag
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
