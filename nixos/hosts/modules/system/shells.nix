{ pkgs, ... }:
{
    programs = {
        bash.enable = true;
        zsh.enable = true;
    };

    users.defaultUserShell = pkgs.bash;
}