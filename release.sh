#!/bin/bash

set -euo pipefail

BUILD_DIR=build
LINUX_DIR=$BUILD_DIR/linux

rm -rf $BUILD_DIR
mkdir -pv $BUILD_DIR

git clone \
	--depth 1 \
	--branch nilfs2-dat-indirection-deduplication \
	file://$(pwd)/workflow/linux \
	$LINUX_DIR

RELEASE_NAME=nilfsdedup-$(git rev-list --max-count=1 --abbrev-commit HEAD)
KVERSION=$(make -C $LINUX_DIR LLVM=1 kernelversion)
echo $RELEASE_NAME
echo $KVERSION

cp config-kernel-debian $LINUX_DIR/.config
make -C $LINUX_DIR -j8 modules_prepare

make \
	-C $LINUX_DIR \
	deb-pkg \
	-j8 \
	LLVM=1 \
	DEB_BUILD_OPTIONS=nocheck \
	LOCALVERSION=-$(cd $LINUX_DIR && git rev-list --max-count=1 --abbrev-commit HEAD) \
	KDEB_PKGVERSION=$KVERSION-l

gh release create --generate-notes $RELEASE_NAME $BUILD_DIR/linux-image* $BUILD_DIR/linux-headers* $BUILD_DIR/linux-libc-dev*