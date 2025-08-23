# { pkgs, userSettings, ... }:
# {
#   users = {
#     defaultUserShell = pkgs.bash;

#     users."olivando" = {
#       isNormalUser = true;
#       extraGroups = [
#         "networkmanager"
#         "wheel"
#       ];
#     };
#   };
# }

{ pkgs, hostSettings, userSettings, ... }:
let
    makeUser =  user: {
        "${user}" = userSettings.${user};
    };
in
{
    users.users = builtins.foldl' (
        usr: user: usr // makeUser user
    ) {} hostSettings.users;
} 










#   # Build a network interface from the function arguments
#   makeInterface = { interface, addresses }: {
#     "${interface}" = {
#       ipv4.addresses = addresses;
#     };
#   };

#   makeNetworking = {
#     # Build network interface options from provided list in hosts.nix
#     interfaces = builtins.foldl' (
#       intf: interface : intf // makeInterface interface
#     ) {} hostSettings.networking.ipv4;