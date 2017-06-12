# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-2

DESCRIPTION="Stack trace visualizer"
HOMEPAGE="http://www.brendangregg.com/flamegraphs.html"
SRC_URI=""
EGIT_REPO_URI="git://github.com/brendangregg/FlameGraph"
EGIT_BRANCH="master"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"

src_install() {
	insinto "/opt/FlameGraph"
	doins -r *
	fperms 755 /opt/FlameGraph/*.pl
}

