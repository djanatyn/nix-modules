{ config, lib, pkgs, options, ... }:
with lib;
let
  home-manager = builtins.fetchGit {
    url = "https://github.com/rycee/home-manager.git";
    rev = "8bbefa77f7e95c80005350aeac6fe425ce47c288";
    ref = "master";
  };
in {
  imports = [
    /etc/nixos/hardware-configuration.nix
    (import "${home-manager}/nixos")
    ./modules/djanatyn
    ./modules/monitoring
    ./modules/dotfiles
  ];

  # prometheus + grafana
  # TODO: rename (flowercluster)
  flowercluster.services.monitoring.enable = true;

  # dotfiles
  dotfiles.enable = true;
  dotfiles.username = "djanatyn";

  # (don't update unless you know what you're doing)
  system.stateVersion = "19.09";

  # nix configuration
  # =================
  nix.package = pkgs.nix;

  services.lorri.enable = true;

  # nixpkgs configuration
  # =====================
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      # required for lutris package
      "p7zip-16.02"
    ];
  };

  # user account
  users.users.djanatyn = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "video" "audio" ];
  };

  home-manager.users.djanatyn = {
    services.gpg-agent = {
      enable = true;
      enableSshSupport = true;
    };
  };

  # use the latest kernel available
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # enable kvm kernel modules
  boot.kernelModules = [ "kvm-amd" "kvm" ];
  boot.extraModulePackages = with pkgs; [ linuxPackages_latest.v4l2loopback ];

  # boot options
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;

  # grub UEFI config
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.grub.device = "nodev";
  boot.loader.systemd-boot.enable = true;

  # LUKS config
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/nvme0n1p2";
      preLVM = true;
    };
  };

  # opengl
  hardware.opengl.enable = true;
  hardware.opengl.driSupport = true;

  # support 32-bit steam application
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];

  # use amdgpu driver
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.enableRedistributableFirmware = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "ctrl:nocaps";

  # desktopManager
  services.xserver.displayManager.defaultSession = "none+xmonad";
  services.xserver.desktopManager.xterm.enable = false;

  # xmonad (nixos managed)
  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
  };

  # networking
  networking.hostName = "voidheart";

  # no DHCP on any interface but enp5s0
  networking.useDHCP = false;
  networking.interfaces.enp5s0.useDHCP = true;

  # traceroute
  programs.mtr.enable = true;

  # sshd service
  services.sshd.enable = true;

  # openvpn
  services.openvpn.servers = {
    expressvpn = { config = "config /root/nixos/openvpn/expressvpn.conf"; };
  };

  # console config
  console.font = "Lat2-Terminus16";
  console.keyMap = "us";

  # locale
  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "America/New_York";

  security.sudo.wheelNeedsPassword = false;

  # gamecube adapter support
  services.udev.extraRules = ''
    # gamecube wii u usb adapter
    ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="666", SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device" TAG+="uaccess"
  '';

  systemd.coredump.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;

  environment.systemPackages = with pkgs; [
    # network
    networkmanagerapplet

    # for finding SHA256 hashes
    nix-prefetch-scripts

    # browser
    firefox
    tor-browser-bundle-bin

    # nix
    nixfmt
    nox
    patchelf
    morph

    # system
    zsh
    htop
    which
    file
    dnsutils
    whois
    mtr
    binutils
    rxvt_unicode
    rsync
    exa
    tmux

    # virtualisation.xen.trace
    qemu_kvm

    # fonts
    terminus_font
    terminus_font_ttf

    # java
    openjdk11

    # archives
    unzip
    unrar

    # utilities
    unrar
    xclip
    aspell
    silver-searcher
    bat
    fzy

    # hashicorp
    terraform
    packer
    nomad

    # music
    spotify

    # ansible
    ansible
    ansible-lint

    # chat
    discord-ptb
    spectral

    # torrent
    rtorrent

    # media
    vlc
    pavucontrol

    # environment
    chezmoi

    # editor
    emacs
    vim

    # development
    direnv
    gdb
    git
    gist
    git-lfs
    gitAndTools.pre-commit
    gitAndTools.diff-so-fancy
    google-cloud-sdk
    cloc

    # haskell
    stack
    ormolu

    # secrets
    gnupg
    diceware
    pass
    sshpass
    keybase

    # ssh
    assh
    sshuttle

    # games
    runelite
    (retroarch.override {
      cores = [
        libretro.dosbox
        libretro.desmume
        libretro.mupen64plus
        libretro.nestopia
        libretro.snes9x
        libretro.dolphin
        libretro.prboom
        libretro.vba-m
      ];
    })
    lutris
    (pkgs.wine.override { wineBuild = "wineWow"; })
    steam
    lutris
    sgtpuzzles
    multimc
    eidolon

    # streaming
    obs-studio

    # window management
    nitrogen
    arandr
    xmobar
    compton
    maim
    xscreensaver
    rofi
    wmctrl
  ];
}
