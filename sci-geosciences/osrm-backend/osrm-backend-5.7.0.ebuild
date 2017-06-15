# Copyright 2017 Intelligent Systems, SIA.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils

DESCRIPTION="Open Source Routing Machine - C++ backend."
HOMEPAGE="http://map.project-osrm.org/"
SRC_URI="https://github.com/Project-OSRM/osrm-backend/archive/v${PV}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="ccache debug fuzzing gcov gold lto nodejs sanitize tools"

REQUIRED_USE="
	sanitize? ( debug )
"

DEPEND="
	app-arch/bzip2
	dev-cpp/tbb
	|| ( =dev-lang/lua-5.1* =dev-lang/lua-5.2* )
	>=dev-libs/boost-1.54[threads]
	dev-libs/expat
	dev-libs/stxxl
	>=sys-devel/gcc-4.9
	sys-libs/zlib

	ccache? ( dev-util/ccache )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_enable ccache CCACHE)
		$(cmake-utils_use_enable gcov COVERAGE)
		$(cmake-utils_use_enable fuzzing FUZZING)
		$(cmake-utils_use_enable gold GOLD_LINKER)
		$(cmake-utils_use_enable lto LTO)
		$(cmake-utils_use_enable nodejs NODE_BINDINGS)
		$(cmake-utils_use_enable sanitize SANITIZER)
		$(cmake-utils_use_build tools TOOLS)
	)

	cmake-utils_src_configure
}
