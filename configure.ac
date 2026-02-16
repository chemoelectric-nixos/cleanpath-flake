#
# Copyright © 2025, 2026 Barry Schwartz
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

AC_PREREQ([2.72])
AC_INIT([cleanpath-flake],[1.0.3])

AC_CONFIG_SRCDIR([cleanpath.d])
AC_CONFIG_AUX_DIR([build-aux])

AC_PROG_MKDIR_P
AC_PROG_SED
AC_CHECK_PROGS([NIXFMT],[nixfmt])
AC_CHECK_PROGS([PAX],[pax])

nixpkgs_versions='release-25.05 release-25.11 nixos-unstable'
systems='x86_64-linux aarch64-linux x86_64-darwin aarch64-darwin'

AC_ARG_VAR([SYSTEM],[such as "x86_64-linux aarch64-linux" (space separated)])
if test "${ac_cv_env_SYSTEM_set}" != set; then
   SYSTEM="${systems}"
fi

AC_ARG_VAR([NIXPKGS_VERSION],[such as "release-25.05 release-25.11 nixos-unstable" (space separated)])
if test "${ac_cv_env_NIXPKGS_VERSION_set}" != set; then
   NIXPKGS_VERSION="${nixpkgs_versions}"
fi

AC_CONFIG_COMMANDS([flake-diversification],
[
  for system in ${system_list}; do
    for nixpkgs in ${nixpkgs_list}; do
      destdir="${builddir}/${system}/${nixpkgs}"
      ${MKDIR_P} "${destdir}"
      ${SED} < "${srcdir}"/flake.nix.in > "${destdir}"/flake.nix \
	     -e "s/@SYSTEM@/${system}/g" \
	     -e "s/@NIXPKGS_VERSION@/${nixpkgs}/g"
      ${NIXFMT} "${destdir}"/flake.nix
      ${MKDIR_P} "${destdir}"/src
      cp "${srcdir}"/cleanpath.d "${destdir}"/src
      (cd "${destdir}" &&
          rm -f cleanpath.tar.xz &&
          ${PAX} -w -x ustar -J src/cleanpath.d > cleanpath.tar.xz)
      rm -R "${destdir}"/src
    done
  done
],
[
  MKDIR_P="${MKDIR_P}"
  SED="${SED}"
  NIXFMT="${NIXFMT}"
  PAX="${PAX}"
  srcdir=`realpath "${srcdir}"`
  builddir=`realpath "$(pwd)"`
  system_list="${SYSTEM}"
  nixpkgs_list="${NIXPKGS_VERSION}"
])

AC_OUTPUT

# local variables:
# coding: utf-8
# end:
