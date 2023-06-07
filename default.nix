{...}:
let 
  oxalica_overlay = import (builtins.fetchTarball
  "https://github.com/oxalica/rust-overlay/archive/master.tar.gz");

  nixpkgs = import <nixpkgs> {
    overlays = [ oxalica_overlay ];
    system = builtins.currentSystem; 
  };
  rust_channel = nixpkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain;
in 
  with nixpkgs;

  rustPlatform.buildRustPackage rec {

    pname = "annepro2-tool";
    version = "0.1.0";

    src = fetchurl {
      url = "https://github.com/hitsmaxft/AnnePro2-Tools/archive/refs/tags/wsl2_build_676fa74.tar.gz";
      hash = "sha256-gV3ZnqSv0fuCGLoFTNcnDk2gkbH7pGAWsF1I1izoZuU=";
    };

    cargoSha256="sha256-tVY0fd63uWjxKf9f5o46Zzh+cSg5hr41exWXCURhYRA=";


    nativeBuildInputs = [
      pkg-config
      rust_channel
      (rust_channel.override{
        extensions = [ "rust-src" "rust-std" ];
      })
      llvmPackages.clang
      pkgconfig

    # tools
    codespell
  ];

  depsBuildBuild = [ ];


  cargoDeps = rustPlatform.fetchCargoTarball {
    inherit src;
  };

  buildInputs = [ 
    pkgs.cargo
    pkgs.rustc
    pkgs.libusb1
    gnumake
    pkgsCross.arm-embedded.buildPackages.gcc

  ];

  LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";

  configureFlags = [];

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/OpenAnnePro/AnnePro2-Tools";
    description = "";
    platforms = platforms.all;
    license = with licenses; [ mit ];
  };

  passthru = {
    tests = {
      package = annepro2-tool;
      command = "annepro2-tool -V";
      version= version;
    };
  };
}
