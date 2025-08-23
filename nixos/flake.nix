{
inputs = {

    nixpkgs.url = "nixpkgs/nixos-25.05";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

};

outputs = { self, nixpkgs, home-manager, ... } @inputs:
    let
        hosts = import ./hosts.nix;
        userSettings = import ./users.nix;

        # Make specified system from passed arguments
        makeSystem = { hostname, hostSettings }: nixpkgs.lib.nixosSystem {
            system = hostSettings.system;

            specialArgs = {
                inherit hostSettings userSettings;
            };

            modules = [ ./hosts/${hostname}/configuration.nix ];
        };

        # Make homeConfiguration for each user on each host in host.nix
        makeHomeConfigs = host: nixpkgs.lib.foldl' (
            config: user: config // {
                "${user.username}@${host.hostname}" = home-manager.lib.homeManagerConfiguration {
                    pkgs = nixpkgs.legacyPackages.${host.hostSettings.system};

                    modules = [ ./users/${user.username}/${user.profile}/home.nix ];

                    extraSpecialArgs = { userSettings = userSettings.${user.username}; };
                };
            }
        ) {} host.hostSettings.users;
    in
    {
        # Build host configurations based on list of hosts from hosts.nix
        nixosConfigurations = nixpkgs.lib.foldl' (
            configs: host: configs // {
                "${host.hostname}" = makeSystem { inherit (host) hostname hostSettings; };
            }
        ) {} hosts;

        # Build home configurations for each host
        homeConfigurations = nixpkgs.lib.foldl' (
            configs: host: configs // makeHomeConfigs host
        ) {} hosts;
    };
}
