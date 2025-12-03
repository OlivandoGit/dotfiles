{ pkgs, ... }:
{
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
    ];

    programs.steam = {
        enable = true;
        gamescopeSession.enable = true;
    };

    virtualisation.docker.enable = true;
}
