#!/bin/bash

# NOTE Run the script in the folder where all the files located

# set card dev and boot partion size
card=/dev/sdb   # find the device with ls /dev/
#boot_size=150   # boot partion size in MB (default value = 150)
boot_size=64   # boot partion size in MB

bootimage=u-boot-sunxi-with-spl-ct-20140107.bin
bootpartion=bootfs-part1.tar.gz
rootpartion=rootfs-part2.tar.gz

# for all commands you need root access
# sudo -i

# to be on safe side erase the first part of your card
echo -e "\033[1;31mcleaning sd card...\033[0m"
#dd if=/dev/zero of=${card} bs=1M seek=544 count=100 (This line were made by original author, not me)
dd if=/dev/zero of=${card} bs=1024 seek=544 count=128

# copy bootimage
echo -e "\033[1;31mcopy bootimage to device...\033[0m"
dd if=${bootimage} of=${card} bs=1024 seek=8


# change card partions
echo -e "\033[1;31mpartion sd card... \033[0m"
cat <<EOT | sfdisk --in-order -uM ${card}
1,$boot_size,c
,,L
EOT

# format the boot partion
echo -e "\033[1;31mFormat boot partion with ext2...\033[0m"
mkfs.ext2 ${card}1

#format root partion
echo -e "\033[1;31mFormat root partion with ext4...\033[0m"
mkfs.ext4 ${card}2

#copy boot and root partion to card
echo -e "\033[1;31mcopy boot and root files to card...\033[0m"
mkdir /tmp/boot_part /tmp/root_part
mount -t ext2 ${card}1 /tmp/boot_part
mount -t ext4 ${card}2 /tmp/root_part
tar -C /tmp/boot_part -xvf ${bootpartion}
tar -C /tmp/root_part -xvf ${rootpartion}
echo "sync..."
sync
umount /tmp/boot_part
umount /tmp/root_part

echo -e "\033[1;31mDONE...\033[0m"
