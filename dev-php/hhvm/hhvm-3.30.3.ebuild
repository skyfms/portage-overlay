# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit eutils git-r3 user versionator

DESCRIPTION="Virtual Machine, Runtime, and JIT for PHP and Hack"
HOMEPAGE="http://www.hhvm.com"
SRC_URI=""
EGIT_REPO_URI="https://github.com/facebook/hhvm.git"

if [[ ${PV} == 9999 ]]; then
	EGIT_BRANCH="master"
else
	EGIT_BRANCH="HHVM-$(get_version_component_range 1-2 )"
    if [[ $(get_version_component_range 3 ) != 9999 ]]; then
        EGIT_COMMIT="HHVM-${PV}"
    fi
fi

LICENSE="
    !jsonc? ( JSON )
    PHP-3
    ZEND-2
"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+async_mysql cotire dbase debug +freetype gmp imagemagick +jemalloc +jpeg jsonc +mcrouter numa +png webp xen +zend-compat cpu_flags_x86_avx2"

DEPEND="
	app-arch/lz4
	dev-cpp/glog
	dev-cpp/tbb
	dev-db/postgresql
	>=dev-libs/boost-1.51[context(+)]
	dev-libs/cyrus-sasl:2
	dev-libs/double-conversion
	gmp? ( dev-libs/gmp )
	jemalloc? ( >=dev-libs/jemalloc-3.0.0[-hardened(-),stats] )
	dev-libs/icu
	jsonc? ( dev-libs/json-c )
	dev-libs/libdwarf
	dev-libs/libevent
	dev-libs/libmcrypt
	dev-libs/libmemcached
	dev-libs/libzip
	=dev-libs/oniguruma-5.9.6[-parse-tree-node-recycle]
	dev-libs/libpcre[jit]
	dev-libs/libxslt
	>=dev-util/cmake-2.8.7
	imagemagick? ( media-gfx/imagemagick )
	freetype? ( media-libs/freetype )
	png? ( media-libs/libpng )
	webp? ( media-libs/libvpx )
	net-libs/c-client[kerberos]
	net-misc/curl
	net-nds/openldap
	sys-devel/binutils[static-libs]
	>=sys-devel/gcc-4.8[-hardened]
	sys-libs/libcap
	numa? ( sys-process/numactl )
	jpeg? ( virtual/jpeg )
	virtual/mysql
"
RDEPEND="
	${DEPEND}
	sys-process/lsof
	virtual/mailx
"

pkg_setup() {
    ebegin "Creating hhvm user and group"
    enewgroup hhvm
    enewuser hhvm -1 -1 "/usr/lib/hhvm" hhvm
    eend $?
}

src_prepare() {
	epatch "${FILESDIR}/7449.patch"
	if ! use async_mysql; then
		epatch "${FILESDIR}/hhvm-3.15-enable_async_mysql-off.patch"
	fi

	eapply_user
	
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

	if ! use async_mysql; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_ASYNC_MYSQL=OFF"
	fi

	if use cotire; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_COTIRE=ON"
	fi

    if use cpu_flags_x86_avx2; then
        ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_AVX2=ON"
    fi

#	if use hardened; then
#		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_SSP=ON"
#	fi

	if ! use imagemagick; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_IMAGICK=OFF"
	fi

	if use jsonc; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DUSE_JSONC=ON"
	fi

	if ! use mcrouter; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_MCROUTER=OFF"
	fi

	if use xen; then
        ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DDISABLE_HARDWARE_COUNTERS=ON"
    else
		if [ "${RC_SYS}" == "XENU" ]; then
			eerror "Under XenU, xen USE flag is required! See https://github.com/facebook/hhvm/issues/981"
			die
		fi
	fi

	if ! use zend-compat; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_ZEND_COMPAT=OFF"
	fi

    econf -DCMAKE_BUILD_TYPE="${CMAKE_BUILD_TYPE}" ${ADDITIONAL_MAKE_DEFS}
}

src_install() {
	emake DESTDIR="${D}" install

	newconfd "${FILESDIR}"/hhvm.confd-2 hhvm
	newinitd "${FILESDIR}"/hhvm.initd-4 hhvm
	dodir "/etc/hhvm"
	insinto /etc/hhvm
	newins "${FILESDIR}"/hhvm.ini hhvm.ini
	newins "${FILESDIR}"/php.ini php.ini

	insinto /etc/logrotate.d
	newins "${FILESDIR}"/hhvm.logrotate hhvm

	dodir "/usr/local/lib/hhvm/extensions"
}

