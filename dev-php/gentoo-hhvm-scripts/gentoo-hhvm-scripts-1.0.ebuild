# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Some useful scripts for HHVM"
HOMEPAGE="https://github.com/skyfms/gentoo-hhvm-scripts"
SRC_URI="http://gentoo.skyfms.com/distfiles/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="dev-php/hhvm"
RDEPEND="${DEPEND}"

src_install() {
	dodoc README.md
	dosbin check_and_start_hhvm.sh restart_hhvm.sh
}
