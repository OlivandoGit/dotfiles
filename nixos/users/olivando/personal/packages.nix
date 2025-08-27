{ pkgs, ... }:
{
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    home.packages = with pkgs; [
        # Hyprland specific
        kitty
        ( waybar.overrideAttrs (oldAttrs: { esonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ]; }))
        mako
        libnotify
        hyprpaper
        rofi-wayland
        hyprlock
        hyprshot

        # UI apps
        discord
        youtube-music
        bitwarden
        stow
        vscode

        # CLI
        flavours

        # Fonts
        nerd-fonts.symbols-only
        nerd-fonts.fira-code
        nerd-fonts.fira-mono
    ];
}
