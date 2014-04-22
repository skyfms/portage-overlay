# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-2

DESCRIPTION="Achieve tee <file> tail <file> without the overhead of writing to <file>."
HOMEPAGE="http://github.com/edgarsi/tailserver"
SRC_URI=""
EGIT_REPO_URI="git://github.com/edgarsi/tailserver.git"
EGIT_BRANCH="master"

if [[ ${PV} != 9999 ]]; then
	EGIT_COMMIT="v${PV}"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="
	dev-libs/libev
	dev-util/cmake
"
RDEPEND="${DEPEND}"

src_configure() {
	./configure
}

