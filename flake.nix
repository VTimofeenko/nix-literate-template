# [[file:project.org::*Flake intro][Flake intro:1]]
{
  description = "Description for the project";
  # Flake intro:1 ends here
  # [[file:project.org::*Inputs][Inputs:1]]
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.11";
    home-manager.url = "github:rycee/home-manager/release-22.11";
    devshell.url = "github:numtide/devshell";
  };
  # Inputs:1 ends here
  # [[file:project.org::*Outputs intro][Outputs intro:1]]
  outputs = inputs@{ flake-parts, home-manager, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      # Outputs intro:1 ends here
      # [[file:project.org::*Imports][Imports:1]]
      imports =
        [
          inputs.devshell.flakeModule
        ];
      # Imports:1 ends here
      # [[file:project.org::*systems setting][systems setting:1]]
      systems = [ "x86_64-linux" "aarch64-darwin" ];
      # systems setting:1 ends here
      # [[file:project.org::*perSystem output][perSystem output:1]]
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        # Per-system attributes can be defined here. The self' and inputs'
        # module parameters provide easy access to attributes of the same
        # system.

        formatter = pkgs.nixpkgs-fmt; # (ref:formatter)
        legacyPackages.homeConfigurations = {
          user = home-manager.lib.homeManagerConfiguration {
            inherit pkgs;
            modules = [ ];
          };
        };
        devshells.default = {
          env = [ ];
          commands = [
            {
              help = "preview README.md";
              name = "preview";
              command = "${pkgs.python310Packages.grip}/bin/grip .";
            }
          ];
        };
      };
      # perSystem output:1 ends here
      # [[file:project.org::*flake output][flake output:1]]
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.

      };
      # flake output:1 ends here
      # [[file:project.org::*Flake outro][Flake outro:1]]
    };
}
# Flake outro:1 ends here
