# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils

DESCRIPTION="An IDE for C/C++ developers with Mylyn integration."
HOMEPAGE="http://www.eclipse.org/cdt/"
SRC_URI="amd64? ( http://download.eclipse.org/technology/epp/downloads/release/kepler/SR1/eclipse-cpp-kepler-SR1-linux-gtk-x86_64.tar.gz )
	x86? ( http://download.eclipse.org/technology/epp/downloads/release/kepler/SR1/eclipse-cpp-kepler-SR1-linux-gtk.tar.gz )"

S=${WORKDIR}/eclipse

LICENSE="EPL-1.0"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND=">=virtual/jre-1.5"
RDEPEND="${DEPEND}"

src_install() {
	declare ECLIPSE_HOME=/opt/${PN}

	# Install eclipse in /opt
	dodir ${ECLIPSE_HOME%/*}
	mv "${S}" "${D}"${ECLIPSE_HOME} || die

	# Create desktop entry
	newicon icon.xpm eclipse-cdt.xpm
	make_desktop_entry ${ECLIPSE_HOME}/eclipse "Eclipse CDT" eclipse-cdt "Development"
}

