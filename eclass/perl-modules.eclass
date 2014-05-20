# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# http://forums.gentoo.org/viewtopic-p-1252352.html?sid=47a4b0f1cf3f88abd22e7b2a6e227939#1252352

perl_module_installed() {
    local PERL_MOD=$1
    local VERSION
    VERSION=`perl -M${PERL_MOD} -e "print \\$${PERL_MOD}::VERSION" 2>&1`
    if [ $? -eq 0 ]; then
        einfo "  ${PERL_MOD} version ${VERSION} installed"
        return 0
    fi
    ewarn "  ${PERL_MOD} is NOT installed"
    return 1
}

install_perl_module() {
    local PERL_MOD=$1
    einfo "Installing ${PERL_MOD}"
    perl -M${AUTOINS_PERL_MODS} -e "install('${PERL_MOD}')"
    [ $? -eq 0 ] && return 0
    return 1
}

check_perl_modules() {
    einfo "Probing perl modules."
    PERL_MODS_NEEDED=""
    for PERL_MOD in ${PERL_MODULE_DEPEND}; do
        perl_module_installed ${PERL_MOD} ||
            PERL_MODS_NEEDED="${PERL_MODS_NEEDED} ${PERL_MOD}"
    done
    if [ -z "${PERL_MODS_NEEDED}" ]; then
        einfo "All needed perl modules installed."
        return 0
    fi
    if [ -z "${AUTOINS_PERL_MODS}" ]; then
        eerror "Missing perl modules but AUTOINS_PERL_MODS not set."
        eerror "Set it to CPAN or CPANPLUS to have modules automatically"
        eerror "installed or install the modules manually."
        die
    fi
    for PERL_MOD in ${PERL_MODS_NEEDED}; do
        if ! install_perl_module ${PERL_MOD}; then
            eerror "Could not install ${PERL_MOD}"
            die
        fi
    done
    return 0
}

