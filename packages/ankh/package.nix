{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # build-system
  poetry-core,
  # dependencies
  biopython,
  datasets,
  sentencepiece,
  torch,
  transformers,
}:
buildPythonPackage {
  pname = "ankh";
  version = "1.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "agemagician";
    repo = "Ankh";
    tag = "v1.10.0";
    hash = "sha256-TxL2Z6HoxkYe3osMqPVyFw8rbvXZwpvW0I8Ix03NMu0=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    biopython
    datasets
    sentencepiece
    # torch is not declared in pyproject.toml but imported directly in source
    torch
    transformers
  ];

  # poetry caret constraints are too strict for nixpkgs versions
  pythonRelaxDeps = [
    "datasets"
    "sentencepiece"
  ];

  # No upstream tests (requires model downloads)
  doCheck = false;

  pythonImportsCheck = [ "ankh" ];

  passthru.category = "Protein Language Models";

  meta = {
    description = "Ankh: Optimized Protein Language Model";
    homepage = "https://github.com/agemagician/Ankh";
    changelog = "https://github.com/agemagician/Ankh/releases/tag/v1.10.0";
    license = lib.licenses.cc-by-nc-sa-40;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
