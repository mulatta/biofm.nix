_final: prev: {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (py-final: _py-prev: {
      biotite = py-final.callPackage ../packages/biotite/package.nix { };
      fair-esm = py-final.callPackage ../packages/esm2/package.nix { };
    })
  ];
}
