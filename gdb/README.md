# vm-debug debugging

## gdbcmd-tmux

Used for debugging nilfs-utils inside buildroot.
Steps:

1. Copy (modified) `test.sh` content and paste it in `make vm-debug`
2. In tmux launch `gdb --command=/mnt/work/gdb/gdbcmd-tmux`
3. In second window launch `nilfs-clean -p 0 -m 0 --speed 32`

Modify gdbcmd-tmux accordingly (it sets some arbitrary breakpoint and has
hardcoded nilfs-utils directory)
