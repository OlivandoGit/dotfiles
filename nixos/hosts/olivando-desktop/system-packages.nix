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

    hardware.nvidia-container-toolkit.enable = true;

    services.ollama = {
  	enable = true;
  	package = pkgs.ollama-cuda;
    };
}
