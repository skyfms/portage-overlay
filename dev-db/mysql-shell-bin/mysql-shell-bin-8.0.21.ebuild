# Copyright 2020 Intelligent Systems SIA.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

DESCRIPTION="Advanced client and code editor for MySQL Server."
HOMEPAGE="https://dev.mysql.com/doc/mysql-shell/8.0/en/"
SRC_URI="https://dev.mysql.com/get/Downloads/MySQL-Shell/mysql-shell-${PV}-linux-glibc2.12-x86-64bit.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

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
