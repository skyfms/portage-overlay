# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-2

DESCRIPTION="Convert HTML to PDF using Webkit (QtWebKit)"
HOMEPAGE="http://wkhtmltopdf.org/"
SRC_URI=""
EGIT_REPO_URI="git://github.com/wkhtmltopdf/wkhtmltopdf.git"

if [[ ${PV} == 9999 ]]; then
	EGIT_BRANCH="master"
else
	EGIT_COMMIT="${PV}"
fi

LICENSE="LGPL3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	git submodule update --init --recursive
}

src_compile() {
	cd ${WORKDIR}/${P}
	scripts/build.py posix-local || die
}

src_install() {
	cd ${WORKDIR}/${P}/static-build
	tar xvJf wkhtmltox\-${PV}_local-`hostname`.tar.xz || die
	cd wkhtmltox\-${PV}/bin
	dobin wkhtmltoimage wkhtmltopdf || die
}

