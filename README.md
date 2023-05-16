# FS kernel dev setup

## Usage

Makefile commands:

- `make modules` - build module located in folder `workflow/linux/fs/ext2-inc
- `make linux` - compile linux kernel
- `make buildroot` - compile buildroot and build rootfs with rootfs-overlay
- `make gdb-debug` - launch gdb with presseding in `gdb/gdbcmd`
- `make vm-debug` - launch qemu with kernel debug support

## Debugging

In one terminal:
`make vm-debug`

In the second one:
`make gdb-debug`

Then set breakpoint in gdb, for ex. `b ext2_fill_super`
and input `continue`

## Development

Launch qemu with: `make vm-debug`

After each change in kernel code run
`make linux`

### Kernel stacktrace

There is a usefull utility: `workflow/linux/scripts/decode_stacktrace.sh` which
allows to decode generated kernel stacktrace. It can be invoked by:

```bash
sh scripts/decode_stacktrace.sh vmlinux < stacktrace.log
```

where `stacktrace.log` is file with copied stacktrace content.


## Buildroot and kernel configuration

If any configuration changed, remember to replace `./.config-*` files
with changed ones.
