# Copyright 2017 Intelligent Systems SIA.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils

DESCRIPTION="Standard Template Library for Extra Large Data Sets."
HOMEPAGE="http://stxxl.org/"
SRC_URI="mirror://sourceforge/stxxl/${P}.tar.gz"

LICENSE="boost"
SLOT="0"
KEYWORDS="~amd64"
IUSE="boost +c++11 examples gcov openmp test valgrind"

REQUIRED_USE="
	test? ( examples )
"

DEPEND="
	app-arch/bzip2
	c++11? ( >=sys-devel/gcc-4.8.1 )
	boost? ( >=dev-libs/boost-1.34.1[threads] )
	openmp? ( >=sys-devel/gcc-4.2[openmp] )
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use boost BOOST)
		$(cmake-utils_useno c++11 CXX11)
		$(cmake-utils_use_build examples EXAMPLES)
		$(cmake-utils_use gcov GCOV)
		$(cmake-utils_use openmp GNU_PARALLEL)
		$(cmake-utils_use_build test TESTS)
		$(cmake-utils_use valgrind VALGRIND)
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	dosym /usr/lib/libstxxl_gentoo.a /usr/lib/libstxxl.a
}
