{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };
  };

  systemd.tmpfiles.rules = [
    "L /sbin/docker - - - - /run/current-system/sw/bin/docker" # may has to be put in by hand
  ];

  networking = {
    hostName = "kaiserP1"; # Define your hostname.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    networkmanager.enable = true;  # Easiest to use and most distros use this by default.
  };

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_GB.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound = {
    enable = true;
    mediaKeys.enable = true;
  };

  hardware = {
    pulseaudio.enable = true;
    opengl = {
    	enable = true;
    	driSupport = true;
    	extraPackages = with pkgs; [ intel-media-driver ];
    };
    bluetooth = {
      # hsphfpd.enable = true;
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
  };

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  nixpkgs.config = {
    pulseaudio = true;
    allowUnfree = true; 
  };
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
     tom = {
       createHome = true;
       isNormalUser = true;
       extraGroups = [ "wheel" "docker" "video" "audio" "networkmanager" "lp" "scanner" "adbusers" ]; # Enable ‘sudo’ for the user.
       initialPassword = "password";
    };
    root = {
      extraGroups = [ "wheel" ];
    };
  };
  users.defaultUserShell = pkgs.zsh;

  # Install software
  environment = {
  systemPackages = with pkgs; [
    alacritty
    asdf-vm
    bc
    bluez
    brightnessctl
    capitaine-cursors
    chromium
    clipman
    python3
    networkmanager_dmenu
    font-awesome
    git
    glib
    glxinfo
    gtk3
    htop
    jetbrains.phpstorm
    jq
    keepassxc
    keepmenu
    kora-icon-theme
    leafpad
    libnotify
    mako
    mesa
    nodejs
    neofetch
    neovim
    nordic
    pavucontrol
    pciutils
    playerctl
    pulseaudio
    qutebrowser
    ranger
    signal-desktop
    spotifywm
    sway-contrib.grimshot
    teams-for-linux
    thunderbird
    tmux
    vim
    vlc
    waybar
    wdisplays
    wget
    wine
    wine64
    wl-clipboard
    wofi
    zim
    zsh
  #  steam
  ];
  variables = {
    MOZ_ENABLE_WAYLAND = "1"; # For Firefox
    _JAVA_AWT_WM_NONREPARENTING = "1";
    XDG_SESSION_TYPE = "wayland";
    GDK_BACKEND = "wayland";
    GTK_THEME = "Nordic";
    QT_QPA_PLATFORM = "wayland-egl"; # For Qt applications
    ZDOTDIR = "/home/tom/.config/zsh";
    CAPACITOR_ANDROID_STUDIO_PATH = "/sbin/android-studio";
    ANDROID_SDK_ROOT = "/home/tom/Android/Sdk";
    CLUTTER_BACKEND = "wayland";
    LIBVA_DRIVER_NAME = "iHD";
  };
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override {fonts = [ "Lilex" ]; })
  ];

  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };


  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs = {
    zsh = {
	enable = true;
    };
    sway.enable = true;
    nano.syntaxHighlight = false; #Remove once issue 195795 is fixed
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };
    adb.enable = true;
  };
  xdg.portal.wlr.enable = true;

  # List services that you want to enable:

  # Enable

  # Enable the OpenSSH daemon.
  services = {
    openssh.enable = true;
    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
          user = "tom";
        };
      };
    };
  };
  system.stateVersion = "24.05";
}
