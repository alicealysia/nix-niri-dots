{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    nixos-cli.url = "github:nix-community/nixos-cli";
    quickshell = {
      # add ?ref=<tag> to track a tag
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-defaults = {
      url = "github:alicealysia/home-defaults";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { 
    self, 
    niri, 
    nixpkgs,
    nixos-cli,
    quickshell, 
    dankMaterialShell,
    nix-vscode-extensions,
    home-manager,
    home-defaults,
    ... 
  }@inputs: 
  {
    nixosConfigurations = { 
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./hardware-configuration.nix
          ./configuration.nix
          home-manager.nixosModules.default
          dankMaterialShell.nixosModules.greeter
          nixos-cli.nixosModules.nixos-cli
          ({pkgs, ...}: 
          {
            nixpkgs.overlays = [
              niri.overlays.niri
              nix-vscode-extensions.overlays.default
              quickshell.overlays.default
            ];
            
            programs.niri.package = pkgs.niri-unstable;
            programs.niri.enable = true;
            programs.dankMaterialShell.greeter = {
                enable = true;
                compositor.name = "niri";
            };
            home-manager.sharedModules = [
              home-defaults.homeConfigurations.default
            ];
            users.users.alice = {
              isNormalUser = true;
              name = "alice";
              extraGroups = ["wheel" "networkmanagers"];
              home = "/home/alice";
            };
          })
          ./apps.nix
        ];
      };
    };
  };
}
