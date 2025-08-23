{ pkgs, ... }:
{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    wget
    kitty
    (waybar.overrideAttrs (oldAttrs: {
      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    }))
    mako
    libnotify
    hyprpaper
    rofi-wayland
    hyprlock

    discord
    file
    youtube-music
    bitwarden
    pulseaudioFull
    tree
    neofetch
    stow
    vscode
    nixfmt-rfc-style
    bind

    # Fonts
    nerd-fonts.fira-code
    nerd-fonts.fira-mono
  ];
}
