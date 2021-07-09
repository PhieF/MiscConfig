I work at /e/, I'm doing this document for /e/

# Useful things to read or watch

most of this document is based on:

https://www.youtube.com/watch?list=PLRJ9-cX1yE1nnhWBrZtuVz5YC2OPfQVVp

## Tools

Extract and edit boot, and other images https://github.com/cfig/Android_boot_image_editor

Same kind of tools but advised by the video 

http://www.mediafire.com/download/zl80gh0t310trla/unpack-bootimg.pl

http://www.mediafire.com/download/xdmd278n17gm58h/unmkbootimg

http://www.mediafire.com/download/byf0tw4ga2mqtw0/repack-bootimg.pl

http://www.mediafire.com/download/7cmi548pzetc6c4/mkbootimg

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


One good thing to try now on your computer, is mounting /system and /vendor since you will need to grab files from these partitions

If you've extracted vendor and system, you can try to mount them directly, but perhaps you will need to use simg2img on these images to convert them to mountable images

If you hesitate or can't mount these partitions, try to adb pull /system ./ You might need to be su, then 

```
adb shell
su
cp /system /sdcard/ -R
exit
exit
adb pull /sdcard/system ./
```


## Breaking Down Boot Images 
https://www.youtube.com/watch?v=_0KjhGEbWZY&list=PLRJ9-cX1yE1nnhWBrZtuVz5YC2OPfQVVp&index=10

I personnally don't use the same tools as the video but this one specific https://github.com/cfig/Android_boot_image_editor

Git clone this project somewhere, then put the previously retrieved boot.img in the same folder, execute

```
./gradlew unpack
```
it should unpack the boot.img, you should see the result in build/unzip_boot. In there you will have the kernel, the dtb, the commandline, the ramdisk (both compressed and extracted)
in the extracted ramdisk you should see the fstab, sometimes init.rc files, I would recommand you to read a bit about these files before goint further

In my specific case, I don't have init files inside the boot.img, instead they are in vendors, /vendor/etc/init

To repack, simply run a 
```
./gradlew pack
```
but that's not necessary here since we haven't modified anything. If you want to reflash the repacked boot.img, in case you've modified something, just flash the newly generated boot.img.signed (be aware that this could brick your phone)

```
fastboot version 30.0.5
fastboot flash --disable-verity --disable-verification boot boot.img.signed
```


## Extracting Vendor Files

Watch https://www.youtube.com/watch?v=ivyrq_aDf58&list=PLRJ9-cX1yE1nnhWBrZtuVz5YC2OPfQVVp&index=11

The purpose of this part is to create the vendor tree

It can be tricky to know which vendor files we need and whoch ones we don't. I guess that comes with experience. 
One thing I'd like to add is to make sure to extract init files

If you use an already made proprietary_files, I would recommand to put the the output of ./extract-files.sh somewhere so as you could remember which files failed to copy

```
./extract-files.sh > output-extract-files
```

