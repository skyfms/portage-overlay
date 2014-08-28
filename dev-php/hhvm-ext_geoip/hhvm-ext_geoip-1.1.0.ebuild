# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

HHVM_EXT_NAME="geoip"

inherit hhvm-ext-source git-2

DESCRIPTION="GeoIP extension for HipHop VM"
HOMEPAGE="https://github.com/skyfms/hhvm-ext_geoip"
SRC_URI=""
EGIT_REPO_URI="git://github.com/skyfms/hhvm-ext_geoip.git"
EGIT_BRANCH="master"
if [[ ${PV} != 9999 ]]; then
	EGIT_COMMIT="${PV}"
fi

LICENSE="PHP-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-libs/geoip[city]
"
RDEPEND="${DEPEND}"

