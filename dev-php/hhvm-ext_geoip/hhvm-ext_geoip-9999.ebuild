# Copyright 2014-2020 Intelligent Systems SIA.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

HHVM_EXT_NAME="geoip"

inherit hhvm-ext-source eutils

DESCRIPTION="GeoIP extension for HipHop VM"
HOMEPAGE="https://github.com/vipsoft/hhvm-ext-geoip"
if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/vipsoft/hhvm-ext-geoip.git"
	EGIT_BRANCH="master"
else
	SRC_URI="https://github.com/vipsoft/hhvm-ext-geoip/archive/${PV}.tar.gz"
	S="${WORKDIR}/hhvm-ext-geoip-${PV}"
fi

LICENSE="PHP-3"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="
	dev-libs/geoip
"
RDEPEND="${DEPEND}"
