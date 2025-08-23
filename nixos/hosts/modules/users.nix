{ pkgs, ... }:
{
  users = {
    defaultUserShell = pkgs.bash;

    users.olivando = {
      isNormalUser = true;
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
    };
  };
}
