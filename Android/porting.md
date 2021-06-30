# Useful things to read or watch

https://www.youtube.com/watch?list=PLRJ9-cX1yE1nnhWBrZtuVz5YC2OPfQVVp



/!\ need to be rooted /!\

# Rooting

I guess it depends on device, first, try to find out if somebody already did it.

On GS290, I managed to extract firmware with SP Flash Tool (for MTK)

from there I could get a working boot.img

When you have a stock boot.img, you can then try this tutorial

https://www.droidwin.com/root-android-devices-without-twrp-recovery/


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


## keep last log:

adb pull /cache/recovery/last_log

## Partitionniong, file system, etc


sometimes 
/proc/mtd useful for filesystem

when mtd not available

https://youtu.be/UmVAQ1YFfRc?t=441


adb pull /proc/partitions ./

to find out which partition is which

ls -l /dev/block/by-name

for example

boot -> /dev/block/mmcblk0p21

adb shell fdisk -l /dev/block/mmcblk0 | tee fdisk.txt

adb pull /fstab* ./

get Size of partitions:

blockdev --getsize64 /dev/block/by-name/partition

For all:

for i in /dev/block/by-name/* ; do echo $i >> /sdcard/partition_size; blockdev --getsize64 ./"$i" >> /sdcard/partition_size; done 

## grab partitions

we are going to save some partitions

adb shell

dd if=/dev/block/by-name/boot /sdcard/boot.img

I would also add

dd if=/dev/block/by-name/system /sdcard/system.img

dd if=/dev/block/by-name/product /sdcard/product.img

dd if=/dev/block/by-name/vendor /sdcard/vendor.img


