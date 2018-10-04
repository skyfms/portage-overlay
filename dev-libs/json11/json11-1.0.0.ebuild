# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils git-2

DESCRIPTION="A tiny JSON library for C++11"
HOMEPAGE="https://github.com/dropbox/json11"

if [[ ${PV} != 9999 ]]; then
	SRC_URI="https://github.com/dropbox/json11/archive/v${PV}.tar.gz -> ${P}.tar.gz"
else
	SRC_URI=""
	EGIT_REPO_URI="git://github.com/dropbox/json11.git"
	EGIT_BRANCH="master"
fi

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

CMAKE_MIN_VERSION="3.2.0"

DEPEND="
	>=sys-devel/gcc-4.7
"
RDEPEND="${DEPEND}"

src_prepare() {
	cmake-utils_src_prepare
}

src_install() {
	doheader json11.hpp
	pushd "${BUILD_DIR}" > /dev/null || die
	dolib.a libjson11.a
	popd > /dev/null || die
}