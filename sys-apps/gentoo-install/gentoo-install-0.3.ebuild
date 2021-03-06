# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

DESCRIPTION="Gentoo Linux install process automatization."
HOMEPAGE="https://github.com/kristapsk/gentoo-install"

if [[ ${PV} != 9999 ]]; then
	SRC_URI="https://github.com/kristapsk/gentoo-install/archive/v${PV}.tar.gz -> ${P}.tar.gz"
else
	SRC_URI=""
	inherit git-r3
	EGIT_REPO_URI="https://github.com/kristapsk/gentoo-install.git"
	EGIT_BRANCH="master"
fi

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+cron"

DEPEND="
	app-portage/portage-utils
"
RDEPEND="${DEPEND}"

install_cron_file() {
	exeinto /etc/cron.daily
	newexe config-gen.cron config-gen
}

src_install() {
	dodir /opt/gentoo-install
	exeinto /opt/gentoo-install
	doexe gentoo-install.sh
	doexe config-gen.sh
	insinto /opt/gentoo-install
	doins inc.config.sh
	doins chroot-part.sh
	docinto /opt/gentoo-install
	dodoc README.txt
	dodoc TODO.txt

	use cron && install_cron_file
}

