{
  inputs = {

    nixpkgs.url = "nixpkgs/nixos-25.05";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:

    let
      system = "x86_64-linux";
      timezone = "Europe/London";
      locale = "en_GB.UTF-8";

      hosts = import ./hosts.nix;
      userSettings = import ./users.nix;

      makeSystem =
        { hostname, hostSettings }:
        nixpkgs.lib.nixosSystem {
          system = system;

          specialArgs = {
            inherit
              inputs
              system
              timezone
              locale
              hostSettings
              userSettings
              ;
          };

          modules = [ ./hosts/${hostname}/configuration.nix ];

        };
    in
    {
      nixosConfigurations = nixpkgs.lib.foldl' (
        configs: host:
        configs
        // {
          "${host.hostname}" = makeSystem { inherit (host) hostname hostSettings; };
        }
      ) { } hosts;

      homeConfigurations = {

        "olivando@olivando-desktop" = home-manager.lib.homeManagerConfiguration {

          pkgs = nixpkgs.legacyPackages.${system};

          modules = [ ./users/olivando/olivando-desktop/home.nix ];

        };
      };
    };
}
