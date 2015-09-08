# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

HHVM_EXT_NAME="pgsql"

inherit hhvm-ext-source

DESCRIPTION="Postgres Extension for HHVM"
HOMEPAGE="https://github.com/PocketRent/hhvm-pgsql"
SRC_URI="https://github.com/skyfms/hhvm-ext_pgsql/archive/${PV}.tar.gz"

LICENSE="PHP-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-libs/libpqxx
"
RDEPEND="${DEPEND}"

#S="${WORKDIR}/hhvm-pgsql-${PV}"
