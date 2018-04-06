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

LICENSE="
    !jsonc? ( JSON )
    PHP-3
    ZEND-2
"
SLOT="0"
KEYWORDS="~amd64"
IUSE="
	apache2 +async_mysql bcmath bzip2 cotire crypt +ctype curl 
	debug domdocument enum factparse fb +filter +freetype
	fribidi +gd gmp +hash +iconv imagemagick imap
	intl +jemalloc +jpeg jsonc ldap libedit libressl lz4 +mail mailparse
	mcrouter memcache memcached +mysql mysqli numa objprof odbc +png
	+password pdo +phar +posix postgres +random readline scrypt
	server +session sharedmem snappy soap +spl +sqlite sysvipc ssl
	+thread thrift unicode watchman wddx webp xdebug xen xhprof
	+xml xmlreader xmlwriter xslt +zend-compat zip zlib
	cpu_flags_x86_avx2
"

DEPEND="
	app-arch/lz4
	dev-cpp/glog
	dev-cpp/tbb
	>=dev-lang/ocaml-4.03[ocamlopt] 
	>=dev-libs/boost-1.51[context(+)]
	dev-libs/cyrus-sasl:2
	dev-libs/double-conversion
	>=dev-libs/icu-4.2
	dev-libs/libdwarf
	dev-libs/libevent
	dev-libs/libmcrypt
	dev-libs/libmemcached
	>=dev-libs/libzip-0.11
	dev-libs/libpcre[jit]
	dev-libs/libxml2
	dev-libs/libxslt
	=dev-libs/oniguruma-5.9.5[-parse-tree-node-recycle]
	dev-ml/ocamlbuild
	>=dev-util/cmake-2.8.7
	net-misc/curl
	net-nds/openldap
	sys-devel/binutils[static-libs]
	>=sys-devel/gcc-4.8[-hardened]
	sys-libs/libcap
	sys-libs/zlib
	!async_mysql? (
		virtual/mysql
	)
	crypt? (
		dev-libs/libmcrypt
	)
	freetype? (
		media-libs/freetype
	)
	fribidi? (
		=dev-libs/fribidi-0.19.6
		dev-libs/glib
	)
	gd? (
		virtual/libiconv
	)
	gmp? (
		dev-libs/gmp
	)
	iconv? (
		virtual/libiconv
	)
	imagemagick? (
		media-gfx/imagemagick
	)
	imap? (
		>=net-libs/c-client-2007[kerberos]
	)
	intl? (
		virtual/libintl
	)
	jemalloc? (
		>=dev-libs/jemalloc-3.0.0[-hardened(-),stats]
	)
	jpeg? (
		virtual/jpeg
	)
	jsonc? (
		dev-libs/json-c
	)
	ldap? (
		net-nds/openldap
	)
	libedit? (
		|| ( dev-libs/libedit sys-freebsd/freebsd-lib )
	)
	!libressl? ( dev-libs/openssl:0 )
	libressl? ( dev-libs/libressl )
	lz4? (
		app-arch/lz4
	)
	memcache? (
		dev-libs/libmemcached
	)
	memcached? (
		dev-libs/bareos-fastlzlib
		>=dev-libs/libmemcached-0.39
	)
	numa? (
		sys-process/numactl
	)
	odbc? (
		dev-db/unixODBC
	)
	png? (
		media-libs/libpng
	)
	postgres? (
		dev-db/postgresql
	)
	readline? (
		sys-libs/readline
	)
	snappy? (
		app-arch/snappy
	)
	watchman? (
		app-misc/watchman
	)
	webp? (
		media-libs/libvpx
	)
	xslt? (
		dev-libs/libxslt
	)
"
RDEPEND="
	${DEPEND}
	sys-process/lsof
	virtual/mailx
"
REQUIRED_USE="
	async_mysql? ( mysql )
	freetype? ( gd )
	jpeg? ( gd )
	png? ( gd )
	readline? ( !libedit )
	webp? ( gd )
"

pkg_setup() {
    ebegin "Creating hhvm user and group"
    enewgroup hhvm
    enewuser hhvm -1 -1 "/usr/lib/hhvm" hhvm
    eend $?
}

src_prepare() {
	git submodule update --init --recursive

	epatch "${FILESDIR}/7449.patch"
	
	export CMAKE_PREFIX_PATH="${D}/usr/lib/hhvm"

	CMAKE_BUILD_TYPE="Release"
	if use debug; then
		CMAKE_BUILD_TYPE="Debug"
	fi
	export CMAKE_BUILD_TYPE

	if ! use async_mysql; then
		cd third-party/squangle
		ln -s src/squangle/mysql_client/ mysql_client
		ln -s src/squangle/logger/ logger
		ln -s src/squangle/base/ base
		cd ../..
		ln -s third-party/re2/src/re2 re2
	fi
}

src_configure() {
    export HPHP_HOME="${S}"
    ADDITIONAL_MAKE_DEFS=""

	if ! use apache2; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_APACHE=OFF"
	fi

	if ! use async_mysql; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_ASYNC_MYSQL=OFF"
	fi

	if ! use bcmath; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_BCMATH=OFF"
	fi

	if ! use bzip2; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_BZ2=OFF"
	fi

	if use cotire; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_COTIRE=ON"
	fi

	if ! use crypt; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_MCRYPT=OFF"
	fi

	if ! use ctype; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_CTYPE=OFF"
	fi

    if use cpu_flags_x86_avx2; then
        ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_AVX2=ON"
    fi

#	if use hardened; then
#		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_SSP=ON"
#	fi

	if ! use debug; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_DEBUGGER=OFF"
	fi

	if ! use domdocument; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_DOMDOCUMENT=OFF"
	fi

	if ! use enum; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_ENUM=OFF"
	fi

	if ! use factparse; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_FACTPARSE=OFF"
	fi

	if ! use fb; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_FB=OFF"
	fi

	if ! use fileinfo; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_FILEINFO=OFF"
	fi

	if ! use filter; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_FILTER=OFF"
	fi

	if use fribidi; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_FRIBIDI=ON"
	fi

	if ! use gd; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_GD=OFF"
	fi

	if ! use gmp; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_GMP=OFF"
	fi

	if ! use hash; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_HASH=OFF"
	fi

	if ! use iconv; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_ICONV=OFF"
	fi

	if ! use imagemagick; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_IMAGICK=OFF"
	fi

	if ! use imap; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_IMAP=OFF"
	fi

	if ! use intl; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_GETTEXT=OFF"
	fi

	if use jsonc; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DUSE_JSONC=ON"
	fi

	if use ldap; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_LDAP=ON"
	fi

	if ! use libedit && ! use readline; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_READLINE=OFF"
	fi

	if ! use lz4; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_LZ4=OFF"
	fi

	if ! use mail; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_MAIL=OFF"
	fi

	if ! use mailparse; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_MAILPARSE=OFF"
	fi

	if ! use mcrouter; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_MCROUTER=OFF -DENABLE_EXTENSION_MCROUTER=OFF"
	fi

	if ! use memcache; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_MEMCACHE=OFF"
	fi

	if ! use memcached; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_MEMCACHED=OFF"
	fi

	if ! use mysql; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_MYSQL=OFF"
	fi

	if ! use mysqli; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_MYSQLI=OFF"
	fi

	if ! use objprof; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_OBJPROF=OFF"
	fi

	if use odbc; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_ODBC=ON"
	fi

	if ! use password; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_PASSWORD=OFF"
	fi

	if ! use pdo; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_PDO=OFF"
	else
		if ! use mysql; then
			ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_PDO_MYSQL=OFF"
		fi
		if ! use sqlite; then
			ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_PDO_SQLITE=OFF"
		fi
	fi

	if ! use phar; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_PHAR=OFF"
	fi

	if ! use posix; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_POSIX=OFF"
	fi

	if use postgres; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_PGSQL=ON"
	fi

	if ! use random; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_RANDOM=OFF"
	fi

	if ! use scrypt; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_SCRYPT=OFF"
	fi

	if ! use server; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_SERVER=OFF"
	fi

	if ! use session; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_SESSION=OFF"
	fi

	if ! use sharedmem; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_SHMOP=OFF"
	fi

	if ! use snappy; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_SNAPPY=OFF"
	fi

	if ! use soap; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_SOAP=OFF"
	fi

	if ! use spl; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_SPL=OFF"
	fi

	if ! use sqlite; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_SQLITE3=OFF"
	fi

	if ! use ssl; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_OPENSSL=OFF"
	fi

	if ! use sysvipc; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_IPC=OFF"
	fi

	if ! use thread; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_THREAD=OFF"
	fi

	if ! use thrift; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_THRIFT=OFF"
	fi

	if ! use unicode; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_MBSTRING=OFF"
	fi

	if use watchman; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_WATCHMAN=ON"
	fi

	if ! use wddx; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_WDDX=OFF"
	fi

	if ! use xdebug; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_XDEBUG=OFF"
	fi

	if use xen; then
        ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DDISABLE_HARDWARE_COUNTERS=ON"
    else
		if [ "${RC_SYS}" == "XENU" ]; then
			eerror "Under XenU, xen USE flag is required! See https://github.com/facebook/hhvm/issues/981"
			die
		fi
	fi

	if ! use xhprof; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_XHPROF=OFF"
	fi

	if ! use xml; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -ENABLE_EXTENSION_LIBXML=OFF -DENABLE_EXTENSION_XML=OFF"
	fi

	if ! use xmlreader; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_XMLREADER=OFF"
	fi

	if ! use xmlwriter; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_XMLWRITER=OFF"
	fi

	if ! use xslt; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_XSL=OFF"
	fi

	if ! use zend-compat; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_ZEND_COMPAT=OFF"
	fi

	if ! use zip; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_ZIP=OFF"
	fi

	if ! use zlib; then
		ADDITIONAL_MAKE_DEFS="${ADDITIONAL_MAKE_DEFS} -DENABLE_EXTENSION_ZLIB=OFF"
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

