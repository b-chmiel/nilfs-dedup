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

If error about dirty version mismatch occurs
while loading module, rebuild kernel and it's modules.

### Kernel stacktrace

There is a usefull utility: `workflow/linux/scripts/decode_stacktrace.sh` which
allows to decode generated kernel stacktrace. It can be invoked by:

```
sh scripts/decode_stacktrace.sh vmlinux < stacktrace.log
```

where stacktrace.log is file with copied stacktrace content.



## Buildroot and kernel configuration

If any configuration changed, remember to replace `./.config-*` files
with changed ones.

### Buildroot

`modules.sh` script is located at `workflow/buildroot/board/incvis/rootfs-overlay`
`post-build.sh` script is located at `workflow/buildroot/`
