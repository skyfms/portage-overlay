# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils java-pkg-2 java-ant-2 multilib

MY_P=${P/-cdt-/_}

DESCRIPTION="An integration of Eclipse CDT and Vim"
HOMEPAGE="http://eclim.org/"
SRC_URI="mirror://sourceforge/eclim/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X"

DEPEND=">=dev-util/eclipse-cdt-bin-4.3.0
	>=virtual/jdk-1.6"
RDEPEND="|| ( >=app-editors/vim-1.7 >=app-editors/gvim-1.7 )
	X? ( >=app-editors/gvim-1.7[netbeans] )
	>=virtual/jre-1.6"

S=${WORKDIR}/${MY_P}
eclipse_home="${ROOT}/opt/eclipse-cdt-bin"

pkg_setup() {
	EANT_BUILD_TARGET="build"
	EANT_EXTRA_ARGS="-Declipse.home=${eclipse_home} \
		-Dplugins=cdt"
	EANT_EXTRA_ARGS_INSTALL="-Declipse.home=${D}${eclipse_home} \
		-Dplugins=cdt \
		-Dvim.files=${D}/usr/share/vim/vimfiles"
}

src_prepare() {
	chmod +x org.eclim/nailgun/configure
	epatch "${FILESDIR}"/fix_build_gant.patch
}

src_install() {
	eant ${EANT_EXTRA_ARGS_INSTALL} deploy

	dosym "${eclipse_home}"/plugins/org.${MY_P}/bin/eclimd \
		/usr/bin/eclimd || die "symlink failed"
	dosym "${eclipse_home}"/plugins/org.${MY_P}/bin/eclim \
		"${eclipse_home}"/eclim || die "symlink failed"
}
