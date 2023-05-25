#!/bin/bash

set -euo pipefail

rm -rf build
mkdir -pv build

git clone \
	--depth 1 \
	--branch nilfs2-dat-indirection-deduplication \
	file://$(pwd)/workflow/linux \
	build/linux

RELEASE_NAME=nilfsdedup-$(git rev-list --max-count=1 --abbrev-commit HEAD)
KRELEASE_NAME=$(make -C build/linux LLVM=1 kernelversion)
echo $RELEASE_NAME
echo $KVERSION

cp config-kernel-debian build/linux/.config
make \
	-C build/linux \
	deb-pkg \
	-j8 \
	LLVM=1 \
	DEB_BUILD_OPTIONS=nocheck \
	LOCALVERSION=-$KVERSION \
	KDEB_PKGVERSION=$KVERSION-l \
	V=1

gh release create --generate-notes $RELEASE_NAME build/linux-image* 