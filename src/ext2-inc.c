#include <linux/fs.h>
#include <linux/init.h>
#include <linux/kernel.h>
#include <linux/module.h>

static struct file_system_type fs_type = { .name = "ext2-inc" };

static int __init ext2_init(void)
{
	return register_filesystem(&fs_type);
}

static void __exit ext2_exit(void)
{
	unregister_filesystem(&fs_type);
}

module_init(ext2_init);
module_exit(ext2_exit);

MODULE_AUTHOR("Bartłomiej Chmiel <incvis@protonmail.com");
MODULE_LICENSE("GPL");