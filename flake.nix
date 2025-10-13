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
  };
  outputs = { 
    self, 
    niri, 
    nixpkgs,
    nixos-cli,
    quickshell, 
    dankMaterialShell,
    nix-vscode-extensions,
    ... 
  }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
      };
      modules = [
        ./hardware-configuration.nix
        ./cachix.nix
        ./configuration.nix
        ./users.nix
        dankMaterialShell.nixosModules.greeter
        nixos-cli.nixosModules.nixos-cli
        ({pkgs, ...}: {
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
        })
        ./apps.nix
      ];
    };
  };
}
