{ config, ... }:
let
  sources = import ./niv/sources.nix { };

  overlay = self: super:
    with super; {
      work-rebuild = writeScriptBin "work-rebuild" ''
        #!${stdenv.shell}
        exec darwin-rebuild \
          -I "$${HOME}/repos/nix-modules/work.nix" \
          "$@"
      '';
    };

  pkgs = import sources.nixpkgs {
    overlays = [ overlay ];
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

    # searching
    ag
    fzf

    # shell
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
