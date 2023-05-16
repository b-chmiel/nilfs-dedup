import os

path = "workflow/linux/fs/nilfs2"
for file in os.listdir(path):
	if '.c' == file[-2:]:
		print(f"rbreak {file}:.*")
