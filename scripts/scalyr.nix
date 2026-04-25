# scalyr-tool: CLI for querying Scalyr/DataSet logs
# https://github.com/scalyr/scalyr-tool
{pkgs}:
pkgs.stdenv.mkDerivation {
  pname = "scalyr";
  version = "0.4.73";

  src = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/scalyr/scalyr-tool/master/scalyr";
    hash = "sha256-bSrYyOXLTd3WJGaLxMDTs1FNWu6CWMn4UsG5wGl8smw=";
  };

  dontUnpack = true;

  nativeBuildInputs = [pkgs.makeWrapper];

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/scalyr
    chmod +x $out/bin/scalyr
    # Replace #!/usr/bin/env python with python3
    sed -i '1s|#!/usr/bin/env python|#!/usr/bin/env python3|' $out/bin/scalyr
    wrapProgram $out/bin/scalyr \
      --prefix PATH : ${pkgs.python3}/bin
  '';
}
