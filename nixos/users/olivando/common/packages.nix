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
        tldr
        bat
        zip
        unzip
	unrar
        vlc
        trash-cli
        htop
	nvtopPackages.nvidia
	nmap
        tcpdump
    ];
}
