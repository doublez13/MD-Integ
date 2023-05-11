```
Creating RAID 5 composed of the loop devices.

NAME    MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
md36      9:36   0   2.8G  0 raid5 /tmp/mount
├─loop1   7:1    0 953.7M  0 loop  
├─loop2   7:2    0 953.7M  0 loop  
├─loop3   7:3    0 953.7M  0 loop  
└─loop4   7:4    0 953.7M  0 loop  

Causing damage to the underlying disk of the RAID array
dd: writing to '/dev/loop1': No space left on device

scrub started on /dev/md36, fsid ccc89b12-1b18-4b12-b200-50f5fde884cf (pid=1366683)
ERROR: there are uncorrectable errors

UUID:             ccc89b12-1b18-4b12-b200-50f5fde884cf
Scrub started:    Thu May 11 07:57:28 2023
Status:           finished
Duration:         0:00:00
Total to scrub:   191.43MiB
Rate:             0.00B/s
Error summary:    super=2 csum=12160
  Corrected:      0
  Uncorrectable:  12160
  Unverified:     0
```


```
Creating integrity taget on each loop device.
Creating RAID 5 composed of the integrity devices.

NAME      MAJ:MIN RM   SIZE RO TYPE  MOUNTPOINTS
md36        9:36   0   2.7G  0 raid5 /tmp/mount
├─integ1  253:1    0 938.9M  0 crypt 
│ └─loop1   7:1    0 953.7M  0 loop  
├─integ2  253:2    0 938.9M  0 crypt 
│ └─loop2   7:2    0 953.7M  0 loop  
├─integ3  253:3    0 938.9M  0 crypt 
│ └─loop3   7:3    0 953.7M  0 loop  
└─integ4  253:4    0 938.9M  0 crypt 
  └─loop4   7:4    0 953.7M  0 loop  

Causing damage to the underlying disk of the integrity target
dd: writing to '/dev/loop1': No space left on device

scrub started on /dev/md36, fsid 1d1300d8-f072-41bc-a0d2-d0c29843ab86 (pid=1367516)

UUID:             1d1300d8-f072-41bc-a0d2-d0c29843ab86
Scrub started:    Thu May 11 07:59:01 2023
Status:           finished
Duration:         0:00:01
Total to scrub:   191.43MiB
Rate:             191.43MiB/s
Error summary:    no errors found
```
