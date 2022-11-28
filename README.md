# FS kernel dev setup

## Usage

Makefile commands:

- `make modules` - build module located in folder `workflow/linux/fs/ext2-inc
- `make linux` - compile linux kernel
- `make buildroot` - compile buildroot and build rootfs with rootfs-overlay
- `make vm` - launch qemu vm running on previously compiled kernel
  and rootfs
- `make gdb-debug` - launch gdb with presseding in `gdbcmd`
- `make vm-debug` - launch qemu with kernel debug support

## Debugging

In one terminal:
`make vm-debug`

In the second one:
`make gdb-debug`

Then build modules on host system:
`make modules`

Then set breakpoint in gdb, for ex. `b ext2_fill_super`
and input `continue`

In qemu terminal install modules: `sh modules.sh`
In case of null pointer dereference; do not panic, run this command again.

## Development

Launch qemu with: `make vm`

After each change in module code:
`make modules`

And inside vm: `sh modules.sh`

## Buildroot and kernel configuration

If any configuration changed, remember to replace `./.config-*` files
with changed ones.

### Buildroot

`modules.sh` script is located at `workflow/buildroot/board/incvis/rootfs-overlay`
`post-build.sh` script is located at `workflow/buildroot/`
