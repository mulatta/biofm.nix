_final: prev: {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (py-final: _py-prev: {
      ankh = py-final.callPackage ../packages/ankh/package.nix { };
      fair-esm = py-final.callPackage ../packages/fair-esm/package.nix { };
    })
  ];
}
