# Useful things to read or watch

https://www.youtube.com/watch?list=PLRJ9-cX1yE1nnhWBrZtuVz5YC2OPfQVVp



/!\ need to be rooted /!\

# Rooting

I guess it depends on device, first, try to find out if somebody already did it.

On GS290, I managed to extract firmware with SP Flash Tool (for MTK)

from there I could get a working boot.img

When you have a stock boot.img, you can then try this tutorial

https://www.droidwin.com/root-android-devices-without-twrp-recovery/

## Note on video "making a vendor file"

We don't seem to be using add_lunch_combo anymore and vendorsetup.sh

Instead, in AndroidProduct.mk, add
```
COMMON_LUNCH_CHOICES += \
    lineage_device-userdebug \
    lineage_device-user \
    lineage_device-eng \
 ```
    
    
    

Some files and info
```
mkdir my_new_device
cd my_new_device
mkdir device_tree
mkdir files_needed_to_work
cd files_needed_to_work
adb shell
mkdir /sdcard/files_to_pull
su
getprop > /sdcard/files_to_pull/all_prop
cp /proc/config.gz /sdcard/files_to_pull/kernel_build_config.gz #contains config file for kernel
cp /sdcard/cmdline /sdcard/files_to_pull/kernel_commandline #contains commandline for booting kernel
```


## keep last log:

cp /cache/recovery/last_log /sdcard/files_to_pull/

## Partitionniong, file system, etc


sometimes 
/proc/mtd useful for filesystem

when mtd not available

https://youtu.be/UmVAQ1YFfRc?t=441

cp /proc/partitions /sdcard/files_to_pull/

to find out which partition is which

ls -l /dev/block/by-name > /sdcard/files_to_pull/ls_block_by_name

for example

boot -> /dev/block/mmcblk0p21

fdisk -l /dev/block/mmcblk0 | tee /sdcard/files_to_pull/fdisk.txt

adb pull /fstab* ./

get Size of partitions:

blockdev --getsize64 /dev/block/by-name/partition

For all:

for i in /dev/block/by-name/* ; do echo $i >> /sdcard/partition_size; blockdev --getsize64 ./"$i" >> /sdcard/files_to_pull/partition_size_bytes; done 

This is the size in bytes, we will need to convert them into number of blocks, to do so we will need the block size

## grab partitions

we are going to save some partitions

adb shell
```
dd if=/dev/block/by-name/boot of=/sdcard/files_to_pull/boot.img
```

I would also add
```

dd if=/dev/block/by-name/system /sdcard/files_to_pull/system.img

dd if=/dev/block/by-name/product /sdcard/files_to_pull/product.img

dd if=/dev/block/by-name/vendor /sdcard/files_to_pull/vendor.img
```

Then, retrieve all these files:

```
adb shell
su
chmod 700 /sdcard/files_to_pull -R
exit
exit
cd files_needed_to_work
adb pull /sdcard/files_to_pull/* ./
```
