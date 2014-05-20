# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit perl-modules

DESCRIPTION="A script that recodes a spreadsheet's charset and saves as CSV."
HOMEPAGE="http://search.cpan.org/~ken/xls2csv-1.07/script/xls2csv"
SRC_URI="http://search.cpan.org/CPAN/authors/id/K/KE/KEN/${P}.tar.gz"

LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND="
	dev-lang/perl
"
RDEPEND="${DEPEND}"

PERL_MODULE_DEPEND="
	Locale::Recode
	Unicode::Map
	Spreadsheet::ParseExcel
	Spreadsheet::ParseExcel::FmtUnicode
	Text::CSV_XS
"

pkg_setup() {
	check_perl_modules
}

src_install() {
	dobin script/xls2csv
}

