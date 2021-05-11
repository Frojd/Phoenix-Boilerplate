#!/bin/sh

# Bumps the version number to relevant files at the end of any release and hotfix start
#
# Positional arguments:
# $1 The version (including the version prefix)
# $2 The origin remote
# $3 The full branch name (including the release prefix)
# $4 The base from which this release is started
#
# The following variables are available as they are exported by git-flow:
#
# MASTER_BRANCH - The branch defined as Master
# DEVELOP_BRANCH - The branch defined as Develop

VERSION=$1

# Remove v prefix (if present)
VERSION=${VERSION#"v"}

ROOTDIR=$(git rev-parse --show-toplevel)

# Bump package.version
sed -i.bak 's/^\( *\)version: .*/\1version: "'$VERSION'",/' $ROOTDIR/src/mix.exs
rm $ROOTDIR/src/mix.exs.bak

# Commit changes
git commit -a -m "Version bump $VERSION"

exit 0
