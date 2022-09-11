all:
	make -C src all

clean:
	make -C src clean

workflow/linux/arch/x86/boot/bzImage:
	make -C workflow/linux -j8

workflow/buildroot/output/images/rootfs.ext4:
	make -C workflow/buildroot -j8

vm: workflow/linux/arch/x86/boot/bzImage workflow/buildroot/output/images/rootfs.ext4
	qemu-system-x86_64 \
-kernel workflow/linux/arch/x86/boot/bzImage \
-boot c \
-m 2049M \
-hda workflow/buildroot/output/images/rootfs.ext4 \
-append "root=/dev/sda rw console=ttyS0,115200 acpi=off nokaslr" \
-serial stdio \
-display none \
-enable-kvm \
-virtfs local,path=$(shell pwd),mount_tag=host0,security_model=mapped,id=host0