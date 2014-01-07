# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit rpm

DESCRIPTION="Citrix XenServer Tools (xe-guest-utilities) for Gentoo"
HOMEPAGE="http://www.citrix.com"
SRC_URI=""
SRCPATH="/mnt/cdrom"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

case $ARCH in
	x86)
		XEARCH=i386
	;;
	amd64)
		XEARCH=x86_64
	;;
esac

S=$WORKDIR

src_unpack() {
	if (( $(find $SRCPATH -maxdepth 2 -name "xe-guest-utilities-*.$XEARCH.rpm" | wc -l) < 2 )); then
		eerror "Can't find the needed .rpm files."
		eerror "Check that ${SRCPATH} is mounted with XenServer Tools (xs-tools.iso)."
		die 
	fi

	for f in $(find $SRCPATH -maxdepth 2 -name "xe-guest-utilities-*.$XEARCH.rpm"); do
		if [[ $f =~ xenstore ]]; then
			TARGETDIR=xe-guest-utilities-xenstore
		else
			TARGETDIR=xe-guest-utilities
		fi
		mkdir ${TARGETDIR}
		pushd ${TARGETDIR} > /dev/null
		rpm_unpack $f
		popd > /dev/null
	done

	epatch "${FILESDIR}/xe-linux-distribution.patch" 
}

src_install() {
	einfo "Processing xe-guest-utilities"
	pushd ./xe-guest-utilities > /dev/null
	procdirs=( /etc/udev/rules.d /usr )
	for dir in ${procdirs[@]}; do
		dodir ${dir} 
		cp --parents -r * "${D}"
	done
	popd > /dev/null

	einfo "Processing xe-guest-utilities-xenstore"
	pushd xe-guest-utilities-xenstore > /dev/null
	dodir /usr
	cp --parents -r ./usr/* "${D}"
	popd > /dev/null

	newconfd "${FILESDIR}"/xe-daemon.confd xe-daemon
	newinitd "${FILESDIR}"/xe-daemon.initd xe-daemon
}

pkg_postinst() {
	einfo "Successfully installed xe-guest-utilities."
	einfo "You can start the xe-daemon by entering /etc/init.d/xe-daemon start"
	einfo ""
	einfo "If you want xe-daemon to automatically run on boot, enter the command:"
	einfo "rc-update add xe-daemon default"
	einfo ""
	einfo "(Verify that xe-daemon indeed starts on boot by rebooting afterwards and"
	einfo " check the daemon's status using pgrep xe-daemon"
}

