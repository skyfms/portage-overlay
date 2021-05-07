# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenPGP keys used by MySQL Release Engineering"
HOMEPAGE="https://dev.mysql.com/doc/refman/8.0/en/checking-gpg-signature.html"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris ~x86-solaris"

src_install() {
	local files=(
		"${FILESDIR}"/mysql_pubkey.asc
	)

	insinto /usr/share/openpgp-keys
	newins - mysql_pubkey.asc < <(cat "${files[@]}" || die)
}
