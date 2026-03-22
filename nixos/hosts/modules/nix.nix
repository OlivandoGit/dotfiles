{
	system.stateVersion = "25.05"; # DO NOT CHANGE

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings = { 
		experimental-features = [
						"nix-command"
						"flakes"
				];
		
		substituters = [ 
			"https://cache.nixos.org"
			"https://cache.nixos-cuda.org" 
		];

		trusted-public-keys = [ 
			"cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
			"cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M=" 
		];

			};
}
