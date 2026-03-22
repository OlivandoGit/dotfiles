{
inputs = {

    nixpkgs.url = "nixpkgs/nixos-25.11";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

};

outputs = { self, nixpkgs, home-manager, ... } @inputs:
    let
        hosts = import ./hosts.nix;
        userSettings = import ./users.nix;

        # Make specified system from passed arguments
        makeSystem = { hostname, hostSettings }: 
            let
                moduleDir = ./hosts/modules;
                discoveredFiles = builtins.attrNames (builtins.readDir moduleDir);
                discoveredModules = map (file: builtins.replaceStrings [".nix"] [""] file) discoveredFiles;
                
                explicitModules = builtins.filter (name: builtins.elem name (hostSettings.modules or [])) discoveredModules;
                implicitModules = builtins.filter (name: builtins.hasAttr name hostSettings.configModules or {}) discoveredModules;
                selectedModules = explicitModules ++ implicitModules;

                modulePaths = map (name: "${moduleDir}/${name}.nix") selectedModules;

                enabledModules = [
                    ./hosts/modules/default.nix
                    ./hosts/${hostname}/hardware-configuration.nix
                ] ++ modulePaths;

            in
                nixpkgs.lib.nixosSystem {
                    system = hostSettings.system;

                    specialArgs = {
                        inherit hostname hostSettings userSettings;
                    };

                    modules = enabledModules;
                };

        # Make homeConfiguration for each user on each host in host.nix
        makeHomeConfigs = host: nixpkgs.lib.foldl' (
            config: user: config // {
                "${user.username}@${host.hostname}" = home-manager.lib.homeManagerConfiguration {
                    pkgs = nixpkgs.legacyPackages.${host.hostSettings.system};

                    modules = [ ./users/home.nix ];

                    extraSpecialArgs = { username = user.username; userSettings = userSettings.${user.username}; profile = user.profile; };
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