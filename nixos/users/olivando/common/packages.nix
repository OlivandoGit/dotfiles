{ pkgs, ... }:
{
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    home.packages = with pkgs; [
        nano
        git
        wget
        file
        tree
        neofetch
        bind
        fzf
        thefuck
        tldr
        bat
        zip
        unzip
        vlc
        trash-cli
        htop
    ];
}
