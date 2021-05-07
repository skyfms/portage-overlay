# Copyright 2020-2021 Intelligent Systems SIA.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

inherit verify-sig

DESCRIPTION="Advanced client and code editor for MySQL Server."
HOMEPAGE="https://dev.mysql.com/doc/mysql-shell/8.0/en/"
SRC_URI="
	https://dev.mysql.com/get/Downloads/MySQL-Shell/mysql-shell-${PV}-linux-glibc2.12-x86-64bit.tar.gz
	verify-sig? ( https://dev.mysql.com/downloads/gpg/?file=mysql-shell-${PV}-linux-glibc2.12-x86-64bit.tar.gz&p=43 -> mysql-shell-${PV}-linux-glibc2.12-x86-64bit.tar.gz.asc )
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND="
	verify-sig? ( app-crypt/openpgp-keys-mysql )
"

VERIFY_SIG_OPENPGP_KEY_PATH=${BROOT}/usr/share/openpgp-keys/mysql_pubkey.asc

S="${WORKDIR}/mysql-shell-${PV}-linux-glibc2.12-x86-64bit"

src_install() {
	exeinto /usr/bin
	doexe bin/*
	dodir /usr/lib/mysqlsh
	insinto /usr/lib/mysqlsh
	doins -r lib/mysqlsh/*
	dodir /usr/share/mysqlsh
	insinto /usr/share/mysqlsh
	doins -r share/mysqlsh/*
}
