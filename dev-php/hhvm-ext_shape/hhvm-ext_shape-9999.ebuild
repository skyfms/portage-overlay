# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

HHVM_EXT_NAME="shp"

inherit hhvm-ext-source git-2

DESCRIPTION="libshape wrapper for HHVM"
HOMEPAGE="https://github.com/skyfms/hhvm-ext_shape"
SRC_URI=""
EGIT_REPO_URI="git://github.com/skyfms/hhvm-ext_shape.git"
EGIT_BRANCH="master"

LICENSE="PHP-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=dev-php/hhvm-3.10.0
	sci-libs/shapelib
"
RDEPEND="${DEPEND}"

