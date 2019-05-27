# Copyright 2019 Intelligent Systems SIA.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit git-r3

DESCRIPTION="Get hostname based on IP address or IP address based on hostname."
HOMEPAGE="https://github.com/skyfms/resolveip"
SRC_URI=""
EGIT_REPO_URI="https://github.com/skyfms/resolveip.git"
EGIT_BRANCH="master"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=""
RDEPEND="
	${DEPEND}
	app-shells/bash
	sys-libs/glibc
"

src_install() {
	dobin resolveip.sh
}
