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

  nixpkgs.config = {
    pulseaudio = true;
    allowUnfree = true; 
  };
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
     tom = {
       createHome = true;
       isNormalUser = true;
       extraGroups = [ "wheel" "docker" "video" "audio" "networkmanager" "lp" "scanner" ]; # Enable ‘sudo’ for the user.
       initialPassword = "password";
    };
    root = {
      extraGroups = [ "wheel" ];
    };
  };

  # Install software
  environment.systemPackages = with pkgs; [
    alacritty
    bluez
    brightnessctl
    clipmenu
    playerctl
    git
    htop
    keepassxc
    keepmenu
    neofetch
    neovim
    libnotify
    qutebrowser
    chromium
    ranger
    spotifywm
    tmux
    vim
    vlc
    waybar
    wdisplays
    wget
    wofi
    zsh
    pavucontrol
    pulseaudio
    thunderbird
    sway-contrib.grimshot
    leafpad
  #  steam
  ];

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
    sway.enable = true;
    nano.syntaxHighlight = false; #Remove once issue 195795 is fixed
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };
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
