# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

HHVM_EXT_NAME="geoip"

inherit hhvm-ext-source

DESCRIPTION="GeoIP extension for HipHop VM"
HOMEPAGE="https://github.com/vipsoft/hhvm-ext-geoip"
SRC_URI="https://github.com/vipsoft/hhvm-ext-geoip/archive/${PV}.tar.gz"

LICENSE="PHP-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-libs/geoip
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/hhvm-ext-geoip-${PV}"

