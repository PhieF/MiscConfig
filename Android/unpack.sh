rm boot -R
mkdir boot
cd boot
abootimg -x ../boot.img
mkdir initrd
cd initrd
zcat ../initrd.img | cpio -idmv
