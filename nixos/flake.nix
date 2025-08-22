{
  inputs = {

    nixpkgs.url = "nixpkgs/nixos-25.05";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = {self, nixpkgs, home-manager, ...}@inputs:

    let
      system = "x86_64-linux";
      timezone = "Europe/London";
      locale = "en_GB.UTF-8";

      hosts = import [ ./hosts.nix ];
    in
 
    {
      nixosConfigurations = {
        "olivando-desktop" = nixpkgs.lib.nixosSystem {

          specialArgs = {

            inherit inputs;
            inherit system;
            inherit timezone;
            inherit locale;

          };

          modules = [ ./system/olivando-desktop/configuration.nix ];

        };
      };

      homeConfigurations = {

        "olivando@olivando-desktop" = home-manager.lib.homeManagerConfiguration {

          pkgs = nixpkgs.legacyPackages.${system};

          modules = [ ./home-manager/olivando/home.nix ];

      };
    };
  };
}
