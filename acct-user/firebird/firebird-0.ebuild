# Copyright 2019 Intelligent Systems SIA.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

inherit acct-user

DESCRIPTION="Firebird program user"
ACCT_USER_ID=450
ACCT_USER_GROUPS=( firebird )
ACCT_USER_HOME=/usr/lib64/firebird
ACCT_USER_SHELL=/bin/sh
acct-user_add_deps
