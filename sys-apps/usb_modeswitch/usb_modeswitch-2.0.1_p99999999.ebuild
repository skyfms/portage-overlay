# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/usb_modeswitch/usb_modeswitch-2.0.1_p20130807.ebuild,v 1.1 2013/09/10 06:36:35 ssuominen Exp $

EAPI=5
inherit eutils linux-info toolchain-funcs udev systemd

MY_PN=${PN/_/-}
MY_P=${MY_PN}-${PV/_p*}
DATA_VER=${PV/*_p}

DESCRIPTION="USB_ModeSwitch is a tool for controlling 'flip flop' (multiple devices) USB gear like UMTS sticks"
HOMEPAGE="http://www.draisberghof.de/usb_modeswitch/ http://www.draisberghof.de/usb_modeswitch/device_reference.txt"

if [[ ${DATA_VER} == 99999999 ]]; then
	inherit git-2
	SRC_URI="http://www.draisberghof.de/${PN}/${MY_P}.tar.bz2"
	EGIT_REPO_URI="https://github.com/kristapsk/usb-modeswitch-data"
	EGIT_SOURCEDIR="${S}/../${MY_PN}-data-${DATA_VER}"
else
	SRC_URI="http://www.draisberghof.de/${PN}/${MY_P}.tar.bz2
		http://www.draisberghof.de/${PN}/${MY_PN}-data-${DATA_VER}.tar.bz2"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="jimtcl"

COMMON_DEPEND="virtual/udev
	virtual/libusb:1"
RDEPEND="${COMMON_DEPEND}
	jimtcl? ( dev-lang/jimtcl )
	!jimtcl? ( dev-lang/tcl )" # usb_modeswitch script is tcl
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

CONFIG_CHECK="~USB_SERIAL"

src_prepare() {
	sed -i -e '/install.*BIN/s:-s::' Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		SYSDIR="${D}/$(systemd_get_unitdir)" \
		UDEVDIR="${D}/$(get_udevdir)" \
		$(usex jimtcl install-shared install)

	# Even if we set SYSDIR above, the Makefile is causing automagic detection of `systemctl` binary,
	# which is why we need to force the .service file to be installed:
	systemd_dounit ${PN}@.service

	dodoc ChangeLog README

	pushd ../${MY_PN}-data-${DATA_VER} >/dev/null
	emake \
		DESTDIR="${D}" \
		RULESDIR="${D}/$(get_udevdir)/rules.d" \
		files-install db-install
	docinto data
	dodoc ChangeLog README
	popd >/dev/null
}
