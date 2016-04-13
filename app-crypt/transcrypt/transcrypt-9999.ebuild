# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils git-2 bash-completion-r1
EGIT_REPO_URI="https://github.com/elasticdog/${PN}.git"
KEYWORDS=""

DESCRIPTION="A script to configure transparent encryption of sensitive files stored in
a Git repository"
HOMEPAGE="https://github.com/elasticdog/transcrypt.git"

LICENSE="MIT"
SLOT="0"
IUSE="zsh-completion bash-completion"

RDEPEND="dev-libs/openssl"
DEPEND="${RDEPEND}"

src_install() {
	dobin transcrypt
	doman man/transcrypt.1

	if use bash-completion; then
		dobashcomp "contrib/bash/${PN}"
	fi

	if use zsh-completion; then
		insinto /usr/share/zsh/site-functions
		doins "contrib/zsh/${PN}"
	fi
}
