# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-2

DESCRIPTION="Script to send git commit email notifications"
HOMEPAGE="http://www.systutorials.com/1473/setting-up-git-commit-email-notification/"
SRC_URI=""
EGIT_REPO_URI="git://github.com/zma/usefulscripts.git"
EGIT_BRANCH="master"

LICENSE=""
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-vcs/git"
RDEPEND="${DEPEND}"

src_install() {
	exeinto "/usr/local/bin/"
	newexe script/post-receive git-post-receive
}

