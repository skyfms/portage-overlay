# Copyright 2019 Intelligent Systems SIA.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

inherit acct-user

DESCRIPTION="HHVM program user"
ACCT_USER_ID=500
ACCT_USER_GROUPS=( hhvm )
ACCT_USER_HOME=/usr/lib/hhvm
acct-user_add_deps
