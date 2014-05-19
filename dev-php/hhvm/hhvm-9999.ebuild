# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils git-2 user versionator

DESCRIPTION="Virtual Machine, Runtime, and JIT for PHP and Hack"
HOMEPAGE="http://www.hhvm.com"
SRC_URI=""
EGIT_REPO_URI="git://github.com/facebook/hhvm.git"

if [[ ${PV} == 9999 ]]; then
	EGIT_BRANCH="master"
else
	EGIT_BRANCH="HHVM-$(get_version_component_range 1-2 )"
    if [[ $(get_version_component_range 3 ) != 9999 ]]; then
        EGIT_COMMIT="HHVM-${PV}"
    fi
fi

LICENSE="PHP-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug devel emacs +freetype hack imagemagick +jemalloc +jpeg +png vim-plugin webp xen zend-compat"
REQUIRED_USE="
	emacs? ( hack )
	vim-plugin? ( hack )
"

RDEPEND="
	sys-process/lsof
	virtual/mailx
"
DEPEND="${RDEPEND}
	dev-cpp/glog
	dev-cpp/tbb
	hack? ( >=dev-lang/ocaml-3.12[ocamlopt] )
	>=dev-libs/boost-1.49
	jemalloc? ( >=dev-libs/jemalloc-3.0.0[stats] )
	dev-libs/icu
	dev-libs/libdwarf
	dev-libs/libevent
	dev-libs/libmcrypt
	dev-libs/libmemcached
	>=dev-libs/oniguruma-5.9.5[-parse-tree-node-recycle]
	dev-libs/libxslt
	>=dev-util/cmake-2.8.7
	imagemagick? ( media-gfx/imagemagick )
	freetype? ( media-libs/freetype )
	png? ( media-libs/libpng )
	webp? ( media-libs/libvpx )
	net-libs/c-client[kerberos]
	net-misc/curl
	net-nds/openldap
	|| ( >=sys-devel/gcc-4.7 >=sys-devel/clang-3.4 )
	sys-libs/libcap
	jpeg? ( virtual/jpeg )
	virtual/mysql
"

pkg_setup() {
    ebegin "Creating hhvm user and group"
    enewgroup hhvm
    enewuser hhvm -1 -1 "/usr/lib/hhvm" hhvm
    eend $?
}

src_prepare() {
	git submodule update --init --recursive
	
	export CMAKE_PREFIX_PATH="${D}/usr/lib/hhvm"

	CMAKE_BUILD_TYPE="Release"
	if use debug; then
		CMAKE_BUILD_TYPE="Debug"
	fi
	export CMAKE_BUILD_TYPE
}

src_configure() {
    export HPHP_HOME="${S}"
    ADDITIONAL_MAKE_DEFS=""
    
	if use xen; then
        ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DDISABLE_HARDWARE_COUNTERS=ON"
    else
		if [ "${RC_SYS}" == "XENU" ]; then
			eerror "Under XenU, xen USE flag is required! See https://github.com/facebook/hhvm/issues/981"
			die
		fi
	fi

	if use zend-compat; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_ZEND_COMPAT=ON"
	fi

    econf -DCMAKE_BUILD_TYPE="${CMAKE_BUILD_TYPE}" ${ADDITIONAL_MAKE_DEFS}
}

src_install() {
	exeinto "/usr/lib/hhvm/bin"
	doexe hphp/hhvm/hhvm

	if use hack; then
		dobin hphp/hack/bin/hh_client
		dobin hphp/hack/bin/hh_server
		dobin hphp/hack/bin/hh_single_type_check
		dodir "/usr/share/hhvm/hack"
		cp -a "${S}/hphp/hack/hhi" "${D}/usr/share/hhvm/hack/"
		if use emacs; then
			cp -a "${S}/hphp/hack/editor-plugins/emacs" "${D}/usr/share/hhvm/hack/"
		fi
		if use vim-plugin; then
			cp -a "${S}/hphp/hack/editor-plugins/vim" "${D}/usr/share/hhvm/hack/"
		fi
	fi

	if use devel; then
		cp -a "${S}/hphp/test" "${D}/usr/lib/hhvm/"
	fi

	dobin "${FILESDIR}/hhvm"
	newconfd "${FILESDIR}"/hhvm.confd hhvm
	newinitd "${FILESDIR}"/hhvm.initd-2 hhvm
	dodir "/etc/hhvm"
	insinto /etc/hhvm
	newins "${FILESDIR}"/config.hdf.dist-2 config.hdf.dist
	newins "${FILESDIR}"/php.ini php.ini
}

