{ pkgs, ... }:
{
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    home.packages = with pkgs; [
        kitty
        (waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
        }))
        mako
        libnotify
        hyprpaper
        rofi-wayland
        hyprlock
        hyprshot

        discord
        youtube-music
        bitwarden
        stow
        vscode
        nixfmt-rfc-style
        
        # Fonts
        nerd-fonts.symbols-only
        nerd-fonts.fira-code
        nerd-fonts.fira-mono
    ];
}
