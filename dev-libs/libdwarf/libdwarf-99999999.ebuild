# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit flag-o-matic

DESCRIPTION="Library to deal with DWARF Debugging Information Format"
HOMEPAGE="http://reality.sgiweb.org/davea/dwarf.html"

if [[ ${PV} == 99999999 ]]; then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="git://libdwarf.git.sourceforge.net/gitroot/libdwarf/libdwarf"
else
	SRC_URI="http://gentoo.skyfms.com/distfiles/${P}.tar.gz"
fi

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+static-libs"

DEPEND="
	virtual/libelf
"
RDEPEND="${DEPEND}"

if [[ ${PV} == 9999 ]]; then
	S=${WORKDIR}/dwarf-${PV}/${PN}/libdwarf
else
	S=${WORKDIR}/dwarf-${PV}/${PN}
fi

src_prepare() {
	append-cflags -fPIC || die
	eapply_user
}

src_configure() {
	econf --enable-shared $(use_enable static-libs nonshared)
}

src_install() {
	if [[ ${PV} == 9999 ]]; then
		pushd libdwarf > /dev/null
	fi

	dolib.a libdwarf.a || die
	dolib.so libdwarf.so || die

	insinto /usr/include
	doins libdwarf.h || die

	dodoc NEWS README CHANGES || die

	if [[ ${PV} == 9999 ]]; then
		popd > /dev/null
	fi
}
