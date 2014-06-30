# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit versionator

DESCRIPTION="Tool for dependency management in PHP."
HOMEPAGE="https://getcomposer.org"

MY_PV=$(replace_version_separator _ -)

if [[ "${MY_PV}" == "9999" ]]; then
	SRC_URI="http://getcomposer.org/composer.phar -> ${PN}-${MY_PV}.phar"
else
	SRC_URI="http://getcomposer.org/download/${MY_PV}/composer.phar -> ${PN}-${MY_PV}.phar"
fi

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/php-5.3.4[zip]"
RDEPEND="${DEPEND}"

src_unpack() {
	cp "${DISTDIR}/${A}" "${WORKDIR}"
	S=${WORKDIR}
}

src_install() {
	mv "${WORKDIR}/${A}" "${WORKDIR}/composer"
	dobin composer
}

