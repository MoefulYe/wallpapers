{
  description = "ashenye's wallpapers";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      forAllSystems =
        function:
        nixpkgs.lib.genAttrs supportedSystems (system: function (import nixpkgs { inherit system; }));
    in
    {
      formatter = forAllSystems (pkgs: pkgs.alejandra);

      packages = forAllSystems (pkgs: {
        default = self.packages.${pkgs.system}.wallpapers;

        wallpapers = pkgs.stdenv.mkDerivation {
          pname = "nord-wallpapers";
          version = self.shortRev or "dev";
          src = ./.;
          installPhase = ''
            cp -r $src/swww $out/swww
            cp -r $src/swaylock.jpg $out/swaylock
          '';
        };
      });
    };
}
