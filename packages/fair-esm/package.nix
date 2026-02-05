{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # build-system
  setuptools,
  # dependencies
  torch,
  # optional-dependencies: inverse-folding
  biotite,
  scipy,
  torch-geometric,
}:
buildPythonPackage {
  pname = "fair-esm";
  version = "2.0.0-unstable-2023-06-27";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "facebookresearch";
    repo = "esm";
    rev = "2b369911bb5b4b0dda914521b9475cad1656b2ac";
    hash = "sha256-p82UipKQYSFEuCiZijzUlInqwXhXrbiZwcNLBUzLXE0=";
  };

  build-system = [ setuptools ];

  postPatch = ''
    # Fix PyTorch 2.6+ compatibility (weights_only default changed to True)
    substituteInPlace esm/pretrained.py \
      --replace-fail 'map_location="cpu"' 'map_location="cpu", weights_only=False'
  '';

  dependencies = [ torch ];

  optional-dependencies = {
    inverse-folding = [
      biotite
      scipy
      torch-geometric
    ];
  };

  # No upstream tests (all require network for model downloads)
  doCheck = false;

  pythonImportsCheck = [ "esm" ];

  passthru.category = "Protein Language Models";

  meta = {
    description = "Evolutionary Scale Modeling (esm): Pretrained language models for proteins";
    homepage = "https://github.com/facebookresearch/esm";
    changelog = "https://github.com/facebookresearch/esm/releases/tag/v2.0.0";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
