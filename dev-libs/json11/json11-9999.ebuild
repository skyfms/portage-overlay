# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils git-2

DESCRIPTION="A tiny JSON library for C++11"
HOMEPAGE="https://github.com/dropbox/json11"
SRC_URI=""
EGIT_REPO_URI="git://github.com/dropbox/json11.git"
EGIT_BRANCH="master"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=dev-util/cmake-3.2
	>=sys-devel/gcc-4.7
"
RDEPEND="${DEPEND}"

src_install() {
	doheader json11.hpp
	pushd "${BUILD_DIR}" > /dev/null || die
	dolib.a libjson11.a
	popd > /dev/null || die
}
