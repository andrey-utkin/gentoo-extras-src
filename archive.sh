#!/bin/bash
set -e

[[ "$#" == 1 ]] || exit 1

DIR="$1"

[[ -d "$DIR" ]] || exit 1

# Strip trailing slash, if any
DIR="${DIR%%/}"

ARCHIVE_NAME="${DIR//\//_}_extras"

# $2, or, if not set, $DIR's last commit
COMMIT=${2:-$(git rev-list --all HEAD -- "$DIR")}
# $COMMIT's commit date
SOURCE_DATE_EPOCH=$(git show --format="format:%at" "$COMMIT" | head -n1)

rm -rf "$ARCHIVE_NAME"
mkdir "$ARCHIVE_NAME"
cp -a "$DIR"/* "$ARCHIVE_NAME"

# Create reproducible tarball
tar cvaf \
	"$ARCHIVE_NAME.tar.xz" \
	--mtime="@$SOURCE_DATE_EPOCH" \
	--sort=name \
	--owner=0 \
	--group=0 \
	--numeric-owner \
	"$ARCHIVE_NAME"
