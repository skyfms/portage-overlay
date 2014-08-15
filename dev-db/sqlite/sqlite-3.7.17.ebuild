# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/sqlite/Attic/sqlite-3.7.17.ebuild,v 1.11 2014/01/26 18:37:39 floppym dead $

EAPI="5"

inherit autotools eutils flag-o-matic multilib versionator

SRC_PV="$(printf "%u%02u%02u%02u" $(get_version_components))"
DOC_PV="${SRC_PV}"
# DOC_PV="$(printf "%u%02u%02u00" $(get_version_components $(get_version_component_range 1-3)))"

DESCRIPTION="A SQL Database Engine in a C Library"
HOMEPAGE="http://sqlite.org/"
SRC_URI="doc? ( http://sqlite.org/2013/${PN}-doc-${DOC_PV}.zip )
	tcl? ( http://sqlite.org/2013/${PN}-src-${SRC_PV}.zip )
	!tcl? (
		test? ( http://sqlite.org/2013/${PN}-src-${SRC_PV}.zip )
		!test? ( http://sqlite.org/2013/${PN}-autoconf-${SRC_PV}.tar.gz )
	)"

LICENSE="public-domain"
SLOT="3"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="debug doc +extensions icu +readline secure-delete static-libs tcl test"

RDEPEND="icu? ( dev-libs/icu:= )
	readline? ( sys-libs/readline )
	tcl? ( dev-lang/tcl:= )"
DEPEND="${RDEPEND}
	doc? ( app-arch/unzip )
	tcl? ( app-arch/unzip )
	test? (
		app-arch/unzip
		dev-lang/tcl
	)"

amalgamation() {
	use !tcl && use !test
}

pkg_setup() {
	if amalgamation; then
		S="${WORKDIR}/${PN}-autoconf-${SRC_PV}"
	else
		S="${WORKDIR}/${PN}-src-${SRC_PV}"
	fi
}

src_prepare() {
	# At least ppc-aix, x86-interix and *-solaris need newer libtool.
	use prefix && eautoreconf

	if amalgamation; then
		epunt_cxx
	fi
}

src_configure() {
	# `configure` from amalgamation tarball does not add -DSQLITE_DEBUG or -DNDEBUG flag.
	if amalgamation; then
		if use debug; then
			append-cppflags -DSQLITE_DEBUG
		else
			append-cppflags -DNDEBUG
		fi
	fi

	# Support column metadata functions.
	# http://sqlite.org/c3ref/column_database_name.html
	# http://sqlite.org/c3ref/table_column_metadata.html
	append-cppflags -DSQLITE_ENABLE_COLUMN_METADATA

	# Support Full-Text Search versions 3 and 4.
	# http://sqlite.org/fts3.html
	append-cppflags -DSQLITE_ENABLE_FTS3 -DSQLITE_ENABLE_FTS3_PARENTHESIS -DSQLITE_ENABLE_FTS4 -DSQLITE_ENABLE_FTS4_UNICODE61

	# Support R*Trees.
	# http://sqlite.org/rtree.html
	append-cppflags -DSQLITE_ENABLE_RTREE

	# Support soundex() function.
	# http://sqlite.org/lang_corefunc.html#soundex
	append-cppflags -DSQLITE_SOUNDEX

	# Support unlock notification.
	# http://sqlite.org/unlock_notify.html
	append-cppflags -DSQLITE_ENABLE_UNLOCK_NOTIFY

	if use icu; then
		append-cppflags -DSQLITE_ENABLE_ICU
		if amalgamation; then
			sed -e "s/LIBS = @LIBS@/& -licui18n -licuuc/" -i Makefile.in || die "sed failed"
		else
			sed -e "s/TLIBS = @LIBS@/& -licui18n -licuuc/" -i Makefile.in || die "sed failed"
		fi
	fi

	# Enable secure_delete pragma by default.
	# http://sqlite.org/pragma.html#pragma_secure_delete
	if use secure-delete; then
		append-cppflags -DSQLITE_SECURE_DELETE -DSQLITE_CHECK_PAGES -DSQLITE_CORE
	fi

	local extensions_option
	if amalgamation; then
		extensions_option="dynamic-extensions"
	else
		extensions_option="load-extension"
	fi

	# Starting from 3.6.23, SQLite has locking strategies that are specific to
	# OSX. By default they are enabled, and use semantics that only make sense
	# on OSX. However, they require gethostuuid() function for that, which is
	# only available on OSX starting from 10.6 (Snow Leopard). For earlier
	# versions of OSX we have to disable all this nifty locking options, as
	# suggested by upstream.
	if [[ "${CHOST}" == *-darwin[56789] ]]; then
		append-cppflags -DSQLITE_ENABLE_LOCKING_STYLE="0"
	fi

	if [[ "${CHOST}" == *-mint* ]]; then
		append-cppflags -DSQLITE_OMIT_WAL
	fi

	# `configure` from amalgamation tarball does not support
	# --with-readline-inc and --(enable|disable)-tcl options.
	econf \
		--enable-threadsafe \
		$(use_enable extensions ${extensions_option}) \
		$(use_enable readline) \
		$(use_enable static-libs static) \
		$(amalgamation || echo --with-readline-inc="-I${EPREFIX}/usr/include/readline") \
		$(amalgamation || use_enable debug) \
		$(amalgamation || echo --enable-tcl)
}

src_compile() {
	emake TCLLIBDIR="${EPREFIX}/usr/$(get_libdir)/${P}"
}

src_test() {
	if [[ "${EUID}" -eq 0 ]]; then
		ewarn "Skipping tests due to root permissions"
		return
	fi

	emake $(use debug && echo fulltest || echo test)
}

src_install() {
	emake DESTDIR="${D}" HAVE_TCL="$(usex tcl 1 "")" TCLLIBDIR="${EPREFIX}/usr/$(get_libdir)/${P}" install
	prune_libtool_files

	doman sqlite3.1

	if use doc; then
		find "${WORKDIR}/${PN}-doc-${DOC_PV}" -name ".[_~]*" -delete
		dohtml -A ico,odg,pdf,svg -r "${WORKDIR}/${PN}-doc-${DOC_PV}/"
	fi
}
