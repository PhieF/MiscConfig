# Useful things to read or watch

https://www.youtube.com/watch?list=PLRJ9-cX1yE1nnhWBrZtuVz5YC2OPfQVVp



Some files and info
```
mkdir my_new_device
cd my_new_device
mkdir device_tree
mkdir files_needed_to_work
cd files_needed_to_work

adb shell getprop > all_prop
adb pull /proc/config.gz ./kernel_build_config.gz #contains config file for kernel
adb pull /proc/cmdline ./kernel_commandline #contains commandline for booting kernel
```

Partitionniong, file system, etc


sometimes 
/proc/mtd useful for filesystem

when mtd not available

https://youtu.be/UmVAQ1YFfRc?t=441


adb pull /proc/partitions ./

to find out which partition is which

ls -l /dev/block/by-name

for example

boot -> /dev/block/mmcblk0p21



keep last log:

adb pull /cache/recovery/last_log

