let
  sources = import ./nix/sources.nix;

  nixpkgs = import sources.nixpkgs { };

in
nixpkgs.mkShell rec {
  buildInputs = with nixpkgs.haskellPackages; [
    ghcid
    ormolu
    hlint
    fast-tags
    stack
    haskell-language-server

    # https://github.com/commercialhaskell/stack/issues/2130
    zlib
    nixpkgs.pkgconfig
  ];

  # https://github.com/commercialhaskell/stack/issues/2130
  LD_LIBRARY_PATH = nixpkgs.lib.makeLibraryPath buildInputs;
}
