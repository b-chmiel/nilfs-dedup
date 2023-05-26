# Workflow

## Integrating ZFS with Linux kernel

After cloning all submodules run in `zfs` folder:
```bash
sh autogen.sh
./configure --enable-linux-builtin --with-linux=../linux --with-linux-obj=../linux --with-config=kernel KERNEL_LLVM=1
./copy-builtin ../linux
```

This will add needed files in the Linux kernel tree.
Then add `CONFIG_ZFS=y` via menuconfig and compile kernel with zfs
support.

