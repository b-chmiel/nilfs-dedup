MODULE_PATH := fs/ext2-inc
JOBS = 8
CC = gcc

.PHONY: modules linux buildroot vm gdb-debug vm-debug clean

modules:
	make -C workflow/linux M=$(MODULE_PATH)

linux:
	cp config-kernel workflow/linux/.config
	make -C workflow/linux -j$(JOBS) CC=$(CC)
	make -C workflow/linux modules

buildroot:
	cp config-buildroot workflow/buildroot/.config
	make -C workflow/buildroot -j$(JOBS) CC=$(CC)

vm:
	qemu-system-x86_64 \
-kernel workflow/linux/arch/x86/boot/bzImage \
-boot c \
-m 2049M \
-hda workflow/buildroot/output/images/rootfs.ext4 \
-append "root=/dev/sda rw console=ttyS0,115200 acpi=off nokaslr noexec=off noexec32=off nosmep nosmap" \
-serial stdio \
-display none \
-enable-kvm \
-virtfs local,path=$(shell pwd),mount_tag=host0,security_model=mapped,id=host0

gdb-debug:
	gdb workflow/linux/vmlinux --command=gdbcmd

vm-debug:
	qemu-system-x86_64 \
-kernel workflow/linux/arch/x86/boot/bzImage \
-boot c \
-m 2049M \
-hda workflow/buildroot/output/images/rootfs.ext4 \
-append "root=/dev/sda rw console=ttyS0,115200 acpi=off nokaslr noexec=off noexec32=off nosmep nosmap" \
-serial stdio \
-display none \
-enable-kvm \
-virtfs local,path=$(shell pwd),mount_tag=host0,security_model=mapped,id=host0 \
-net nic,model=virtio \
-net user,hostfwd=tcp::10022-:22 \
-s

# nokaslr -> disables address randomization CONFIG_RANDOMIZE_BASE
# noexec=off -> disables NX execute protection

clean:
	make -C workflow/linux clean
	make -C workflow/buildroot clean
