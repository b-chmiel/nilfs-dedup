#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

resize_partition() {
    resize2fs /dev/sda1
}

apt_packages() {
    apt-get update && \
        export DEBIAN_FRONTEND=noninteractive && \
        apt-get install -y --allow-unauthenticated wget make g++ uuid-dev libblkid-dev libblkid1 libmount1 libmount-dev time
}

bonnie() {
    BONNIE_VERSION=2.00b
    DIR=./bonnie_install

    wget https://github.com/bachm44/bonnie-plus-plus/archive/refs/tags/$BONNIE_VERSION.tar.gz
    mkdir -pv $DIR
    tar -xf *.tar.gz -C $DIR --strip-components=1
    rm *.tar.gz
    pushd $DIR
        make install
    popd
}

fio_install() {
    FIO_VERSION=fio-3.33
    DIR=./fio_install

    wget https://github.com/axboe/fio/archive/refs/tags/$FIO_VERSION.tar.gz
    mkdir -pv $DIR
    tar -xf *.tar.gz -C $DIR --strip-components=1
    rm *.tar.gz
    pushd $DIR
        ./configure
        make
        make install
    popd
}

genfile_install() {
    GENFILE_VERSION=1.0.5-dev-09dfc220ea449a02f71f59dfd803e676a2db7905
    GENFILE=genfile.deb

    wget https://github.com/bachm44/genfile/releases/download/$GENFILE_VERSION/genfile.deb
    dpkg -i $GENFILE
}

nilfs_utils_install() {
	NILFS_UTILS_VERSION=2.3.0-dev-a729a63d394aab593ae93ccb98cb48b7d7131d34
    DIR=./nilfs_utils_install

	wget https://github.com/bachm44/nilfs-utils/releases/download/$NILFS_UTILS_VERSION/nilfs-utils-$NILFS_UTILS_VERSION.tar.bz2
    mkdir -pv $DIR
    tar -xf *.tar.bz2 -C $DIR --strip-components=1
    rm *.tar.bz2
    pushd $DIR
        ./configure
        make
        make install
    popd
}

kernel_install() {
    RELEASE=nilfsdedup-824bffe
    KERNEL_IMAGE=linux-image-6.1.0-09fddcac8_6.1.0-l_amd64.deb
    KERNEL_HEADERS=linux-headers-6.1.0-09fddcac8_6.1.0-l_amd64.deb
    KERNEL_LIBC=linux-libc-dev_6.1.0-l_amd64.deb

    wget https://github.com/bachm44/nilfs-dedup/releases/download/$RELEASE/$KERNEL_IMAGE
    wget https://github.com/bachm44/nilfs-dedup/releases/download/$RELEASE/$KERNEL_HEADERS
    wget https://github.com/bachm44/nilfs-dedup/releases/download/$RELEASE/$KERNEL_LIBC

    dpkg -i $KERNEL_IMAGE
    dpkg -i $KERNEL_HEADERS
    dpkg -i $KERNEL_LIBC
}

fix_keys() {
    wget --no-check-certificate https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub -O /home/vagrant/.ssh/authorized_keys  
    chmod 0700 /home/vagrant/.ssh  
    chmod 0600 /home/vagrant/.ssh/authorized_keys  
    chown -R vagrant /home/vagrant/.ssh  
}

main() {
    resize_partition
    apt_packages
    bonnie
    fio_install
    genfile_install
    kernel_install
	nilfs_utils_install
    fix_keys
}

main