{ pkgs, hostSettings, userSettings, ... }:

let
    # Set the user attributes using the data from users.nix
    makeUser =  user: {
        "${user}" = userSettings.${user};
    };
in
{
    # Create all users from hosts.nix
    users.users = builtins.foldl' (
        usr: user: usr // makeUser user
    ) {} hostSettings.users;
} 
