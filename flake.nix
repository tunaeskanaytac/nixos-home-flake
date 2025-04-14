{
  description = "Hello Cruel Beautiful World...";

  inputs = {
    # NixOS official package source, using the nixos-24.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ self, ... }: let
    system = "x86_64-linux";
    filepaths = {
      nixos = {
        configuration = "${self}" + "/nixos/configuration.nix";
      };
      home-manager = {
        home = "${self}" + "/home-manager/home.nix";
      };
      dotfiles = rec {
        root = "${self}" + "/dotfiles";
	    sway = "${root}" + "/sway";
    	nvim = "${root}" + "/nvim";
		alejandra = "${root}" + "/alejandra";
      };
    };
  in
  {
    # Please replace my-nixos with your hostname
    nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        filepaths.nixos.configuration

	inputs.home-manager.nixosModules.home-manager
	{
          home-manager.useGlobalPkgs = true;
	  home-manager.useUserPackages = true;
	  home-manager.users.xenonfandangon = filepaths.home-manager.home;
	  home-manager.extraSpecialArgs = {
            inherit filepaths;
	  };
	}
      ];
    };
  };
}
