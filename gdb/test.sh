#!/bin/sh

###############################################################################
# GENERATE
###############################################################################

export SIZE=1015809
export MNT_DIR=/mnt/nilfs2
VALIDATION_ID=0

function dir_size {
directory=$1
df | grep $directory
}

function validate_fs {
size=$(dir_size $MNT_DIR)
echo "BEGIN_SIZE $MNT_DIR SIZE $VALIDATION_ID $size END_SIZE"
lssu
lscp

validate_f1=$(sha512sum -c f1.sha512sum)
validate_f2=$(sha512sum -c f2.sha512sum)
echo "CHECKSUM VALIDATION $VALIDATION_ID $validate_f1 $validate_f2"
VALIDATION_ID=$(($VALIDATION_ID + 1))
}


sh mount_nilfs.sh

validate_fs

gen_file --size=$SIZE --type=0 --seed=420 $MNT_DIR/f1
gen_file --size=$SIZE --type=0 --seed=420 $MNT_DIR/f2

sha512sum $MNT_DIR/f1 > f1.sha512sum
sha512sum $MNT_DIR/f2 > f2.sha512sum

validate_fs

umount /mnt/nilfs2


###############################################################################
# DEDUPLICATE
###############################################################################

export FS_BIN_FILE=/nilfs2.bin
export LOOP_INTERFACE=/dev/loop0
VALIDATION_ID=0

losetup -P $LOOP_INTERFACE $FS_BIN_FILE
mkdir -p $MNT_DIR
mount -t nilfs2 $LOOP_INTERFACE $MNT_DIR

validate_fs

dedup /dev/loop0

validate_fs

umount /mnt/nilfs2

###############################################################################
# VALIDATE
###############################################################################

losetup -P $LOOP_INTERFACE $FS_BIN_FILE
mkdir -p $MNT_DIR
mount -t nilfs2 $LOOP_INTERFACE $MNT_DIR

validate_fs

umount /mnt/nilfs2