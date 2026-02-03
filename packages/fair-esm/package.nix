{
  lib,
  buildPythonPackage,
  callPackage,
  fetchFromGitHub,
  # build-system
  setuptools,
  torch,
  # optional: inverse folding (ESM-IF)
  withInverseFolding ? false,
  biotite ? (callPackage ../biotite/package.nix { }),
  scipy,
  torch-geometric,
  # optional: ESMFold (requires openfold, not yet in nixpkgs)
  withEsmfold ? false,
  dm-tree ? null,
  einops ? null,
  ml-collections ? null,
  omegaconf ? null,
  pandas ? null,
  pytorch-lightning ? null,
  # dependencies
  biopython,
  requests,
  tqdm,
}:
buildPythonPackage {
  pname = "fair-esm";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "esm";
    tag = "v2.0.0";
    hash = "sha256-dFjn40maCYf6HjnFoyArk9q6GlDpe+0yyQJasNRAc4E=";
  };

  build-system = [ setuptools ];

  postPatch = ''
    # Fix PyTorch 2.6+ compatibility (weights_only default changed to True)
    substituteInPlace esm/pretrained.py \
      --replace-fail 'map_location="cpu"' 'map_location="cpu", weights_only=False'
  ''
  + lib.optionalString withInverseFolding ''
    # Replace torch_scatter with torch_geometric.utils.scatter
    # (torch_scatter is a legacy C++ extension not in nixpkgs;
    #  torch_geometric.utils.scatter uses native PyTorch scatter_add_ as fallback)
    substituteInPlace esm/inverse_folding/gvp_modules.py \
      --replace-fail 'from torch_scatter import scatter_add, scatter' \
        'from torch_geometric.utils import scatter as _scatter
    def scatter_add(src, index, dim=0, dim_size=None):
        return _scatter(src, index, dim=dim, dim_size=dim_size, reduce="sum")
    def scatter(src, index, dim=0, dim_size=None, reduce="sum"):
        return _scatter(src, index, dim=dim, dim_size=dim_size, reduce=reduce)'
  '';

  dependencies = [
    biopython
    requests
    torch
    tqdm
  ]
  ++ lib.optionals withInverseFolding [
    biotite
    scipy
    torch-geometric
  ]
  ++ lib.optionals withEsmfold [
    dm-tree
    einops
    ml-collections
    omegaconf
    pandas
    pytorch-lightning
    scipy
  ];

  # No upstream tests (all require network for model downloads)
  doCheck = false;

  pythonImportsCheck = [
    "esm"
  ]
  ++ lib.optionals withInverseFolding [
    "esm.inverse_folding"
  ]
  ++ lib.optionals withEsmfold [
    "esm.esmfold.v1"
  ];

  passthru = {
    inherit withInverseFolding withEsmfold;
    category = "Protein Language Models";
  };

  meta = {
    description = "Evolutionary Scale Modeling (esm): Pretrained language models for proteins";
    homepage = "https://github.com/facebookresearch/esm";
    changelog = "https://github.com/facebookresearch/esm/releases/tag/v2.0.0";
    license = lib.licenses.mit;
    # openfold is not yet packaged in nixpkgs
    broken = withEsmfold;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
