{ pkgs }:
pkgs.poetry2nix.mkPoetryEnv {
  projectDir = ../integration_tests;
  python = pkgs.python39;
  overrides = pkgs.poetry2nix.overrides.withDefaults (self: super: {
    eth-bloom = super.eth-bloom.overridePythonAttrs {
      preConfigure = ''
        substituteInPlace setup.py --replace \'setuptools-markdown\' ""
      '';
    };

    pystarport = super.pystarport.overridePythonAttrs (
      old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ self.poetry ];
      }
    );

    cprotobuf = super.cprotobuf.overridePythonAttrs (
      old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ self.cython ];
      }
    );
  });
}
