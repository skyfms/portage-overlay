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
	fperms 755 "${ROOT}/opt/FlameGraph/flamegraph.pl"
	fperms 755 "${ROOT}/opt/FlameGraph/stackcollapse.pl"
	fperms 755 "${ROOT}/opt/FlameGraph/stackcollapse-perf.pl"
	fperms 755 "${ROOT}/opt/FlameGraph/stackcollapse-pmc.pl"
	fperms 755 "${ROOT}/opt/FlameGraph/stackcollapse-stap.pl"
	fperms 755 "${ROOT}/opt/FlameGraph/stackcollapse-instruments.pl"
	fperms 755 "${ROOT}/opt/FlameGraph/stackcollapse-vtune.pl"
	fperms 755 "${ROOT}/opt/FlameGraph/stackcollapse-ljp.awk"
	fperms 755 "${ROOT}/opt/FlameGraph/stackcollapse-jstack.pl"
	fperms 755 "${ROOT}/opt/FlameGraph/stackcollapse-gdb.pl"
	fperms 755 "${ROOT}/opt/FlameGraph/stackcollapse-go.pl"
}

