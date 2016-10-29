# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

HHVM_EXT_NAME="mongodb"
HHVM_MIN_VERSION="3.6.0"

inherit hhvm-ext-source eutils

DESCRIPTION="MongoDB HHVM driver"
HOMEPAGE="https://github.com/mongodb/mongo-hhvm-driver"
SRC_URI="https://github.com/mongodb/mongo-hhvm-driver/releases/download/${PV}/hhvm-mongodb-${PV}.tgz"

LICENSE="Apache-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=dev-libs/cyrus-sasl-2
	dev-libs/openssl
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/hhvm-mongodb-${PV}"

src_compile() {
	cmake .
	make configlib
	make
}

