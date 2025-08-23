{ pkgs, ... }:
{
    programs = {
        bash.enable = true;
        zsh.enable = true;
        fish.enable = true;
    };

    users.defaultUserShell = pkgs.bashInteractive;
}