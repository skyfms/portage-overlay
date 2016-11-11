# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

HHVM_EXT_NAME="geoip"

inherit hhvm-ext-source eutils

DESCRIPTION="GeoIP extension for HipHop VM"
HOMEPAGE="https://github.com/vipsoft/hhvm-ext-geoip"
SRC_URI="https://github.com/vipsoft/hhvm-ext-geoip/archive/${PV}.tar.gz"

LICENSE="PHP-3"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="
	dev-libs/geoip
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/hhvm-ext-geoip-${PV}"

src_prepare() {
	if has_version ">=dev-php/hhvm-3.6.0"; then
		epatch "${FILESDIR}/hhvm-3.6.0.patch"
	fi
	epatch "${FILESDIR}/hhvm-ext_geoip-1.1.0-null_variant.patch"
	hhvm-ext-source_src_prepare
}
