{ hostname, ... }:

{
  networking.hostName = "${hostname}";

  system.stateVersion = "25.05"; # DO NOT CHANGE

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

}