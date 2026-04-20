
{
  description = "dotfiles";

  inputs = {
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    home-manager = {
      # url-unstable = "github:nix-community/home-manager";
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
    url = "github:sodiboo/niri-flake";
    inputs.nixpkgs.follows = "nixpkgs";
    };
    xwayland-satellite = {
      url = "github:Supreeeme/xwayland-satellite";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dgop = {
      url = "github:AvengeMedia/dgop";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };


  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      niri,
      ...
    }@inputs:
    let 
    system = "x86_64-linux";
    pkgs = import nixpkgs { 
     inherit system;
      config.allowUnfree = true;
      };
   in
    {
      nixosConfigurations = {
        vis = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
          };
          modules = [
            {
            imports = [ inputs.niri.nixosModules.niri ];
            nixpkgs.overlays = [
              inputs.niri.overlays.niri
              inputs.xwayland-satellite.overlays.default
              ];
            }
            ./hosts/vis/configuration.nix
          ];
        };
      };
      homeConfigurations = {
        vis = home-manager.lib.homeManagerConfiguration  { 
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs;
            };
            modules = [ 
            { 
              nixpkgs.overlays = [
                 (_: _: {
                   dgop = inputs.dgop.packages.${system}.default;    
                 })    
              ];
              }
                ./home/vis/home.nix
                ];
        };
      };
    };
}
