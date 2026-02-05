_final: prev: {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (py-final: _py-prev: {
      ankh = py-final.callPackage ../packages/ankh/package.nix { };
      biotite_0_39 = py-final.callPackage ../packages/biotite/package.nix { };
      biotite = py-final.biotite_0_39;
      fair-esm = py-final.callPackage ../packages/fair-esm/package.nix { };
    })
  ];
}
