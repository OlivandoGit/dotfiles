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
                discoveredModules = map (file: builtins.replaceStrings [".nix"] [""] file) (builtins.attrNames (builtins.readDir moduleDir));
                
                explicitModuleNames = hostSettings.modules or [];

                # Throw error for unknown explicit modules
                unknownExplicitModules = builtins.filter(name: !(builtins.elem name discoveredModules)) explicitModuleNames;
                _1 = if unknownExplicitModules != [] then
                        builtins.throw ''
                            Unknown explicit modules: ${builtins.concatStringsSep ", " unknownExplicitModules}
                            Available modules: ${builtins.concatStringsSep ", " discoveredModules}
                        ''
                    else null;
                
                configModulesNames = builtins.attrNames (hostSettings.configModules or {});

                # Throw error for unknown config modules
                unknownConfigModules = builtins.filter(name: !(builtins.elem name discoveredModules)) configModulesNames;
                _2 = if unknownConfigModules != [] then
                        builtins.throw ''
                            Unknown explicit modules: ${builtins.concatStringsSep ", " unknownConfigModules}
                            Available modules: ${builtins.concatStringsSep ", " discoveredModules}
                        ''
                    else null;

                explicitModules = builtins.filter (name: builtins.elem name explicitModuleNames) discoveredModules;
                configModules = builtins.filter (name: builtins.elem name configModulesNames) discoveredModules;
                selectedModules = explicitModules ++ configModules;

                modulePaths = map (name: "${moduleDir}/${name}.nix") selectedModules;

                enabledModules = [
                    ./hosts/modules/system.nix
                    ./hosts/${hostname}/hardware-configuration.nix
                ] ++ modulePaths;

            in
                # Evaluate the errors
                assert _1 == null && _2 == null;

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