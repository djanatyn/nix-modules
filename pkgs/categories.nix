{ pkgs }:
with pkgs; {
  system = [
    # tools you can't live without
    rsync
    which
    file
    binutils
    moreutils
    pueue

    # classics get an upgrade
    htop
    glances
    bat
    procs
    exa

    # timer!
    termdown
    peaclock

    # conversions
    fend
  ];

  network = [
    # dns
    dnsutils
    whois

    # tls
    openssl
    gnutls
  ];

  terminal = [
    # urxvt
    rxvt_unicode

    # terminus font
    terminus_font
    terminus_font_ttf
  ];

  study = [
    # track documents
    zotero
  ];

  transform = [
    # streaming, filtering, and transforming data
    jq
    yq
    xmlstarlet
    zalgo
  ];

  nix = [
    # check hashes
    nix-prefetch-scripts

    # format code
    nixfmt

    # build binaries
    patchelf

    # home-manager!
    home-manager

    # version management
    niv

    # searching
    manix
  ];

  secrets = [
    # manage keys
    gnupg

    # managing passwords
    pass

    # generating passwords
    pwgen
    diceware

    # 2FA
  ] ++ (pkgs.lib.optional (pkgs.stdenv.system != "x86_64-darwin") oathToolkit);

  ssh = [
    # advanced ssh
    assh

    # when authorized_keys won't work
    sshpass

    # tunneling
    sshuttle
  ];

  patches = [
    # bps + ips
    flips

    # other formats
    xdelta
  ];

  haskell = [
    # curated package collection
    stack

    # best formatter :)
    ormolu
  ];

  google = [
    # still on gcloud
    google-cloud-sdk
  ];

  filesystem = [
    # checking space
    du-dust

    # managing files
    nnn
  ] ++ lib.optional (pkgs.stdenv.system != "x86_64-darwin") duf;

  chat = [
    # chat clients
    discord
    spectral
  ];

  virtualisation = [
    # qemu (no more virtualbox?)
    qemu
    qemu_kvm
  ];

  music = [
    # plays everything
    mpv

    # open source spotify client
    ncspot

    # music player daemon
    mpd
    mpdas
    ncmpcpp
  ];

  sound = [
    # pulse + alsa utilities
    pavucontrol
    pulsemixer
    alsaUtils
  ];

  mail = [
    # fetching
    isync

    # index + search
    notmuch
  ] ++ lib.optional (pkgs.stdenv.system == "x86_64-darwin") davmail;

  editor = [
    # emacs + tmux is powerful
    emacs26-nox

    # best of both worlds
    neovim
  ];

  search = [
    # rust rules
    fd
    sd
    ripgrep

    # fuzzy finding
    fzf
  ];

  torrents = [
    # cli client
    rtorrent
    qbittorrent-nox

    # straight from the source
    youtube-dl
    ytcc
  ];

  browser = [
    # latest firefox
    latest.firefox-nightly-bin

    # bookmarks!
    pinboard

    # contextual browsing!
    surf

    # not everything works in firefox
    chromium

    # native extensions
    brotab
    browserpass
  ];

  tmux = [
    # terminal multiplexer
    tmux

    # declarative session manager
    tmuxp
  ];

  development = [
    # run things
    entr

    # count code
    tokei
    cloc

    # benchmark
    hyperfine
    rtss

    # colors
    pastel

    # debug
    hexyl
    gdb

    # showing off
    glow
    silicon
    asciinema
  ];

  hacking = [
    # reverse engineering
    radare2
    radare2-cutter
  ];

  archives = [
    # compression!
    unrar
    unzip
    zip
  ];

  dhall = [
    # typed programmable config
    dhall
    dhall-bash
    dhall-json
  ];

  git = with gitAndTools; [
    # nicer diffs
    diff-so-fancy
    delta

    # run commit checks, declaratively
    pre-commit

    # manage files outside of git
    git-annex
    git-annex-utils

    # git large files
    git-lfs

    # github
    gist
    hub

    # trimming
    git-trim
  ];

  games = if (pkgs.stdenv.system == "x86_64-darwin") then
    [
      # tales of middle earth
      tome2
    ]
  else [
    # steam + lutris
    wine
    steam
    lutris

    # melee
    slippi.playback
    slippi.netplay
    wiimms-iso-tools

    # emulation
    retroarch

    # minecraft
    multimc

    # puzzles
    sgtpuzzles
  ];

  java = [
    # an open version
    openjdk11
  ];

  streaming = [
    # for twitch
    obs-studio
    screenkey
  ];

  xorg = [
    # wm managment
    wmctrl
    rofi
    arandr

    # style
    nitrogen
    compton
    xmobar

    # screenshots
    maim
    flameshot

    # clipboard
    xclip

    # screensaver
    xscreensaver
  ];

  voidheart = [
    # special voidheart rituals
    ritual

    # podcasts stay here
    podcast
  ];

  hashicorp = [
    # neat tools
    terraform
    packer
    nomad
  ];

  work = [
    # ansible...
    ansible
    ansible-lint

    # jira!
    go-jira
  ];

  organization = [
    # task warrior + shell
    taskwarrior
    tasksh

    # timetracking
    wakatime
  ];
}
