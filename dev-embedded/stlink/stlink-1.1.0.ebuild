# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="stm32 discovery line linux programmer"
HOMEPAGE="https://github.com/texane/stlink"
SRC_URI="https://github.com/texane/stlink/archive/${PV}.tar.gz -> stlink-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	virtual/libusb
	virtual/pkgconfig
"
RDEPEND="${DEPEND}"

src_configure() {
	./autogen.sh
	econf
}

src_compile() {
	emake || die "Make failed"
}

src_install() {
	emake DESTDIR="${D}" install
	insinto /lib/udev/rules.d/
	doins 49-stlinkv1.rules 49-stlinkv2.rules 49-stlinkv2-1.rules
}
