# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/closure-compiler-bin/closure-compiler-bin-20130411.ebuild,v 1.1 2013/04/15 07:22:30 patrick Exp $

EAPI="4"

inherit java-pkg-2

DESCRIPTION="A JavaScript checker and optimizer."
HOMEPAGE="https://github.com/google/closure-compiler"
SRC_URI="http://dl.google.com/closure-compiler/compiler-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.6"

S=${WORKDIR}

src_install() {
	java-pkg_jarinto /opt/${PN}-${SLOT}/lib
	java-pkg_newjar closure-compiler-v${PV}.jar ${PN}.jar
	java-pkg_dolauncher \
		${PN%-bin} \
		--jar /opt/${PN}-${SLOT}/lib/${PN}.jar \
		-into /opt
	dodoc README.md

	dodir /usr/bin
	dosym /opt/bin/closure-compiler /usr/bin/closure-compiler
}

