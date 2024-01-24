{
  description = "NeuBank";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        # TODO remove unfree after removing Terraform
        # (Source: https://xeiaso.net/blog/notes/nix-flakes-terraform-unfree-fix)
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
      with pkgs;
      {
        devShells.default = mkShell {
          packages = [
            bash
            azure-cli
            terraform
            direnv
          ];
        };
      }
    );
}