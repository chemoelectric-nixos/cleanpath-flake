#
# Copyright © 2025 Barry Schwartz
#
# This program is free software: you can redistribute it and/or
# modify it under the terms of the GNU General Public License, as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received copies of the GNU General Public License
# along with this program. If not, see
# <https://www.gnu.org/licenses/>.
#

{
  description = "A Nix flake for cleanpath";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.05";
  };

  outputs =
    { self, nixpkgs, ... }:
    let
      lib = nixpkgs.lib;
      pkgs = import nixpkgs { system = "x86_64-darwin"; };
      xz = "${pkgs.xz}/bin/xz";
      pax = "${pkgs.pax}/bin/pax";
      dmd = "${pkgs.dmd}/bin/dmd";
      strip = "${pkgs.binutils}/bin/strip";
      install = "${pkgs.coreutils}/bin/install";
    in
    {
      packages."x86_64-darwin" = rec {

        default = cleanpath;

        cleanpath = pkgs.stdenv.mkDerivation {
          name = "cleanpath";
          src = ./cleanpath.tar.xz;
          nativeBuildInputs = [
            pkgs.xz
            pkgs.pax
            pkgs.dmd
            pkgs.binutils
            pkgs.coreutils
          ];
          unpackPhase = ''
            ${xz} -d < $src | ${pax} -r
          '';
          configurePhase = '':'';
          buildPhase = ''
            ${dmd} -of=cleanpath -O src/cleanpath.d \
                   -L-static -L-lphobos2
            ${strip} cleanpath
          '';
          installPhase = ''
            ${install} -d -m 755 $out/bin
            ${install} -m 755 cleanpath $out/bin
          '';
        };
      };
    };
}
