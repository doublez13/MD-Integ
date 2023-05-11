#!/bin/bash

INTEGRITY=0

#Create four file-backed devices to use in the RAID array
dd if=/dev/zero of=/tmp/disk1.blk bs=1MB count=1000 status=none
losetup /dev/loop1 /tmp/disk1.blk
dd if=/dev/zero of=/tmp/disk2.blk bs=1MB count=1000 status=none
losetup /dev/loop2 /tmp/disk2.blk
dd if=/dev/zero of=/tmp/disk3.blk bs=1MB count=1000 status=none
losetup /dev/loop3 /tmp/disk3.blk
dd if=/dev/zero of=/tmp/disk4.blk bs=1MB count=1000 status=none
losetup /dev/loop4 /tmp/disk4.blk

if [ -f /dev/md36 ]; then
  echo "Bailing..."
  exit
fi

if [[ $INTEGRITY -eq 1 ]]; then
  echo "Creating integrity taget on each loop device."
  integritysetup format /dev/loop1 -q
  integritysetup format /dev/loop2 -q
  integritysetup format /dev/loop3 -q
  integritysetup format /dev/loop4 -q
  integritysetup open /dev/loop1 integ1
  integritysetup open /dev/loop2 integ2
  integritysetup open /dev/loop3 integ3
  integritysetup open /dev/loop4 integ4
  echo "Creating RAID 5 composed of the integrity devices"
  mdadm --create /dev/md36 --level=5 --raid-devices=4 /dev/mapper/integ1 /dev/mapper/integ2 /dev/mapper/integ3 /dev/mapper/integ4 --quiet
else
  echo "Creating RAID 5 composed of the loop devices"
  mdadm --create /dev/md36 --level=5 --raid-devices=4 /dev/loop1 /dev/loop2 /dev/loop3 /dev/loop4 --quiet
fi

mkfs.btrfs -q /dev/md36

mkdir /tmp/mount
mount /dev/md36 /tmp/mount
lsblk -s /dev/md36

#Write a file to the raid array
dd if=/dev/random of=/tmp/mount/file1.bin bs=1MB count=200 status=none
sync

echo; echo Causing damage to the underlying disk of the integrity target
dd if=/dev/random of=/dev/loop1 status=none
sync

#Perform a BTRFS scrub
btrfs scrub start /dev/md36
sleep 3
echo; echo;
btrfs scrub status /dev/md36

#Clean up
umount /tmp/mount
mdadm --stop /dev/md36
if [[ $INTEGRITY -eq 1 ]]; then
  integritysetup close integ1
  integritysetup close integ2
  integritysetup close integ3
  integritysetup close integ4
fi
losetup -d /dev/loop1
losetup -d /dev/loop2
losetup -d /dev/loop3
losetup -d /dev/loop4
rm /tmp/disk*.blk
