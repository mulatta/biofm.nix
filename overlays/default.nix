_final: prev: {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (py-final: _py-prev: {
      fair-esm = py-final.callPackage ../packages/fair-esm/package.nix { };
    })
  ];
}
