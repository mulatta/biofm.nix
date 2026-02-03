{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  # build-system
  cython,
  oldest-supported-numpy,
  setuptools,
  wheel,
  # dependencies
  msgpack,
  networkx,
  numpy,
  requests,
}:
buildPythonPackage (finalAttrs: {
  pname = "biotite";
  version = "0.39.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "biotite-dev";
    repo = "biotite";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4kC4FYuw/HMhJI6a20N62O5nE5t4EDTli/NhrmrpuLg=";
  };

  build-system = [
    cython
    oldest-supported-numpy
    setuptools
    wheel
  ];

  dependencies = [
    msgpack
    networkx
    numpy
    requests
  ];

  # numpy<=2.0 constraint is overly strict; biotite works with numpy 2.x
  pythonRelaxDeps = [ "numpy" ];

  # No tests (require network and large test data)
  doCheck = false;

  pythonImportsCheck = [
    "biotite"
    "biotite.sequence"
    "biotite.structure"
  ];

  meta = {
    description = "A comprehensive library for computational molecular biology";
    homepage = "https://www.biotite-python.org";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
