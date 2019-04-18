# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author: root
# Purpose: 
#

EXPORT_FUNCTIONS src_prepare src_compile src_install

# @ECLASS-VARIABLE: HHVM_EXT_NAME
# @DESCRIPTION:
# The extension name. This must be set, otherwise the eclass dies.
[[ -z "${HHVM_EXT_NAME}" ]] && die "No module name specified for the hhvm-ext-source eclass"

# @ECLASS-VARIABLE: HHVM_MIN_VERSION
# @DESCRIPTION:
# Specify the minimum required HHVM version.
: ${HHVM_MIN_VERSION:=3.2.0}

DEPEND="
	${DEPEND}
	>=dev-php/hhvm-${HHVM_MIN_VERSION}
"

# @FUNCTION: hhvm-ext-source_src_prepare
hhvm-ext-source_src_prepare() {
	default_src_prepare
	hphpize
}

# @FUNCTION: hhvm-ext-source_src_compile
hhvm-ext-source_src_compile() {
	cmake . && make
}

# @FUNCTION: hhvm-ext-source_src_install
hhvm-ext-source_src_install() {
	EXT_DIR="/usr/local/lib/hhvm/extensions/"

	exeinto "${EXT_DIR}"
	doexe "${HHVM_EXT_NAME}.so" || die "Unable to install extension"

	elog "To enable the extension, you need to have the following line in your HHVM config file:"
	elog "    hhvm.dynamic_extensions[${HHVM_EXT_NAME}] = ${HHVM_EXT_NAME}.so"
}

