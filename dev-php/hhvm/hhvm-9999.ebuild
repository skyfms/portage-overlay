# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit eutils

DESCRIPTION="Virtual Machine, Runtime, and JIT for PHP"
HOMEPAGE="http://www.hhvm.com"

if [[ ${PV} == 9999 ]]; then
	SRC_URI=""
	inherit git-2
	EGIT_REPO_URI="git://github.com/facebook/hhvm.git"
	EGIT_BRANCH="master"
else
	SRC_URI="https://github.com/facebook/hhvm/archive/HHVM-${PV}.tar.gz"
	S="${WORKDIR}/hhvm-HHVM-${PV}"
fi

LIBEVENT_P="libevent-1.4.14b-stable"

SRC_URI="${SRC_URI}
	https://github.com/downloads/libevent/libevent/${LIBEVENT_P}.tar.gz
"

LICENSE="PHP-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug devel +jemalloc xen"

RDEPEND="
	dev-cpp/glog
	dev-cpp/tbb
	>=dev-libs/boost-1.37
	jemalloc? ( dev-libs/jemalloc[stats] )
	dev-libs/icu
	=dev-libs/libdwarf-20120410
	dev-libs/libmcrypt
	dev-libs/libmemcached
	>=dev-libs/oniguruma-5.9.5[-parse-tree-node-recycle]
	media-libs/gd[jpeg,png]
	net-libs/c-client[kerberos]
	net-misc/curl
	net-nds/openldap
	sys-libs/libcap
	sys-libs/libunwind
	sys-process/lsof
	virtual/mysql
"
DEPEND="${RDEPEND}
	dev-util/cmake
	>=sys-devel/gcc-4.7
"

pkg_setup() {
    ebegin "Creating hhvm user and group"
    enewgroup hhvm
    enewuser hhvm -1 -1 "/usr/lib/hhvm" hhvm
    eend $?
}

src_prepare() {
	if [[ ${PV} == 9999 ]]; then
		git submodule init
		git submodule update
	fi

	export CMAKE_PREFIX_PATH="${D}/usr/lib/hhvm"

	einfo "Building custom libevent"
	export EPATCH_SOURCE="${S}/hphp/third_party"
	EPATCH_OPTS="-d ""${WORKDIR}/${LIBEVENT_P}" epatch libevent-1.4.14.fb-changes.diff
	pushd "${WORKDIR}/${LIBEVENT_P}" > /dev/null
	./autogen.sh
	./configure --prefix="${CMAKE_PREFIX_PATH}"
	emake
	emake -j1 install
	popd > /dev/null

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
        ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DNO_HARDWARE_COUNTERS=1"
    else
		if [ "${RC_SYS}" == "XENU" ]; then
			eerror "Under XenU, xen USE flag is required! See https://github.com/facebook/hhvm/issues/981"
			die
		fi
	fi
    econf -DCMAKE_BUILD_TYPE="${CMAKE_BUILD_TYPE}" ${ADDITIONAL_MAKE_DEFS}
}

src_install() {
	pushd "${WORKDIR}/${LIBEVENT_P}" > /dev/null
	emake -j1 install
	popd > /dev/null

	exeinto "/usr/lib/hhvm/bin"
	doexe hphp/hhvm/hhvm

	if use devel; then
		cp -a "${S}/hphp/test" "${D}/usr/lib/hhvm/"
	fi

	dobin "${FILESDIR}/hhvm"
	newconfd "${FILESDIR}"/hhvm.confd hhvm
	newinitd "${FILESDIR}"/hhvm.initd hhvm
	dodir "/etc/hhvm"
	insinto /etc/hhvm
	newins "${FILESDIR}"/config.hdf.dist config.hdf.dist
	newins "${FILESDIR}"/php.ini php.ini
}

