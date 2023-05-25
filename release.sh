#!/bin/bash

set -euo pipefail

rm -rf build
mkdir -pv build

git clone \
	--depth 1 \
	--branch nilfs2-dat-indirection-deduplication \
	file://$(pwd)/workflow/linux \
	build/linux

VERSION=nilfsdedup-$(git rev-list --max-count=1 --abbrev-commit HEAD)
KVERSION=$(make -C build/linux LLVM=1 kernelversion)-$(cd build/linux && git rev-list --max-count=1 --abbrev-commit HEAD)-l
echo $VERSION
echo $KVERSION

cp config-kernel-debian build/linux/.config
make \
	-C build/linux \
	deb-pkg \
	-j8 \
	LLVM=1 \
	DEB_BUILD_OPTIONS=nocheck \
	LOCALVERSION=-$VERSION \
	KDEB_PKGVERSION=$KVERSION

gh release create $VERSION build/linux-image*