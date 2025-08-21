{
  inputs = {
    utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, utils }: utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
      {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            uv
            cacert
          ];

          shellHook = ''
            export UV_PYTHON_PREFERENCE="managed"
            export SSL_CERT_FILE=$(nix eval --raw nixpkgs.cacert)/etc/ssl/certs/ca-bundle.crt
            '';
        };
      }
  );

}
