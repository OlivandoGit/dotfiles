{ nixpkgs, hostSettings, ... }:
let

  # Build a network interface from the function arguments
  makeInterface = { interface, addresses }: {
    "${interface}" = {
      ipv4.addresses = addresses;
    };
  };

  makeNetworking = {
    # Build network interface options from provided list in hosts.nix
    interfaces = builtins.foldl' (
      intf: interface : intf // makeInterface interface
    ) {} hostSettings.networking.ipv4;

    defaultGateway = hostSettings.networking.defaultGateway;

    # Use dns config from hosts.nix if provided, otherwiseset to default [9.9.9.9 8.8.8.8]
    nameservers = if (builtins.hasAttr "dns" hostSettings.networking) then hostSettings.networking.dns else ["9.9.9.9" "8.8.8.8"];
  };

in

{
  # Configure network settings in hosts.nix if provided, otherwise enable networkmanager
  networking = if (builtins.hasAttr "networking" hostSettings) then makeNetworking else { networkmanager.enable = true; };
}
