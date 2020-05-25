cd boot
rm initrd.img

cd initrd
find . | cpio -o -c | gzip -9 > ../initrd.img
cd ..
#abootimg --create ../new_boot.img  -f bootimg.cfg -k zImage -r initrd.img

python ../mkbootimg.py --ramdisk initrd.img --kernel zImage --dtb ../sun50i-a64-pinephone.dtb --second_offset 0x8800 --kernel_offset 0x88000 --ramdisk_offset 0x3300000  --dtb_offset 0x3000000 --header_version 2
