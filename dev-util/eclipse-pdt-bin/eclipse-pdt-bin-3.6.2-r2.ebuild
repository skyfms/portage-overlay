# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="Tools for PHP developers creating Web applications, including PHP Development Tools (PDT), Web Tools Platform, Mylyn and others."
HOMEPAGE="http://www.eclipse.org/cdt/"
SRC_URI="amd64? ( http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/helios/SR2/eclipse-php-helios-SR2-linux-gtk-x86_64.tar.gz )
	x86? ( http://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/helios/SR2/eclipse-php-helios-SR2-linux-gtk.tar.gz )"

S=${WORKDIR}/eclipse

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=virtual/jre-1.5"
RDEPEND="${DEPEND}"

src_install() {
	declare ECLIPSE_HOME=/opt/${PN}

	# Install eclipse in /opt
	dodir ${ECLIPSE_HOME%/*}
	mv "${S}" "${D}"${ECLIPSE_HOME} || die

	# Create desktop entry
	newicon icon.xpm eclipse-pdt.xpm
	make_desktop_entry ${ECLIPSE_HOME}/eclipse "Eclipse PDT" eclipse-pdt "Development"
}

