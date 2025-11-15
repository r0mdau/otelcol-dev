{
  description = "Development shell for otelcol-dev";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        go = pkgs.go_1_23;

        devShell = pkgs.mkShell {
          name = "otelcol-dev-shell";
          packages = with pkgs; [
            go
            go-tools
            golint
            gopls
            golangci-lint
            gotestsum
            delve
            git
            gnumake
            which
            pkg-config
            protobuf
            docker
            docker-compose
            openssl
            cacert
          ];

          shellHook = ''
            export GOPATH="$PWD/.gopath"
            export GOBIN="$GOPATH/bin"
            export PATH="$GOBIN:$PATH"
            export GO111MODULE=on
            export CGO_ENABLED=1
            echo "Loaded otelcol-dev nix shell (Go ${go.version})"
          '';
        };
      in {
        devShells.default = devShell;
        packages.default = devShell;
      });
}
