{
inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

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
                discoveredModules = builtins.filter (name: builtins.match ".*\\.nix" name != null) (builtins.attrNames (builtins.readDir moduleDir));
                availableModuleNames = map (name: nixpkgs.lib.removeSuffix ".nix" name) discoveredModules;
                
                explicitModulesNames = hostSettings.modules or [];

                # Throw error for unknown explicit modules
                unknownExplicitModules = builtins.filter(name: !(builtins.elem name availableModuleNames)) explicitModulesNames;
                _1 = if unknownExplicitModules != [] then
                        builtins.throw ''
                            Unknown explicit modules: ${builtins.concatStringsSep ", " unknownExplicitModules}
                            Available modules: ${builtins.concatStringsSep ", " availableModuleNames}
                        ''
                    else null;
                
                configModulesNames = builtins.attrNames (hostSettings.configModules or {});

                # Throw error for unknown config modules
                unknownConfigModules = builtins.filter(name: !(builtins.elem name availableModuleNames)) configModulesNames;
                _2 = if unknownConfigModules != [] then
                        builtins.throw ''
                            Unknown config modules: ${builtins.concatStringsSep ", " unknownConfigModules}
                            Available modules: ${builtins.concatStringsSep ", " availableModuleNames}
                        ''
                    else null;

                explicitModules = builtins.filter (name: builtins.elem name explicitModulesNames) availableModuleNames;
                configModules = builtins.filter (name: builtins.elem name configModulesNames) availableModuleNames;
                selectedModules = builtins.sort builtins.lessThan (explicitModules ++ configModules);

                selectedModulePaths = map (name: "${moduleDir}/${name}.nix") selectedModules;

                enabledModules = [
                    ./hosts/modules/system.nix
                    ./hosts/${hostname}/hardware-configuration.nix
                ] ++ selectedModulePaths;

            in
                # Evaluate the errors
                assert _1 == null && _2 == null;

                nixpkgs.lib.nixosSystem {
                    system = hostSettings.system;

                    specialArgs = {
                        inherit hostname hostSettings;

                        # Limit usersettings to only the users for this host
                        userSettings = builtins.listToAttrs (map (u: {
                            name = u.username;
                            value = userSettings.${u.username};
                            }) hostSettings.users);
                    };
                
                    modules = enabledModules;
                };

        # Make homeConfiguration for each user on each host in host.nix
        makeHomeConfigs = host: 
            let 
                pkgs = import nixpkgs { system = host.hostSettings.system; };
            in
            nixpkgs.lib.foldl' (
                config: user: config // {
                    "${user.username}@${host.hostname}" = home-manager.lib.homeManagerConfiguration {
                        inherit pkgs;
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