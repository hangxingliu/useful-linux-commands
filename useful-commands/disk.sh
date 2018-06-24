# Commands about disk/storage
# useful filesystem commands (mount disk ...)

# NTFS filesystem mount/unmount

sudo apt install ntfs-3g
# ntfs-3g support read and write
# Linux kernel only support read from NTFS
mount /dev/your_NTFS_partition /mount/point
# or add one rule(line) in /etc/fstab
/dev/NTFS_partition  /mnt/mount_to  ntfs-3g  uid=$USER,nofail,x-gvfs-show,rw 0 0
# uid=$USER    mount for $USER(full permission). for example: uid=1000 uid=admin
# x-gvfs-show  show disk icon in gnome(nautils file manager)
# rw      read and write permission
# nofail  ignore this volume if its hardware is not existed


# NTFS filesystem problem

## (Read-only) The disk contains an unclean file system ...
## Could not copy/create file inside even if it has write permission
## 磁盘虽然有可写权限, 但是任然不可写/创建文件(包括Root)
## REASON: >> It maybe caused by "fast startup" and "hibernate" in Windows
## Because Windows storage some meta data into NTFS disk after you shutdown or hibernate from Windows
## So you should disable fast startup in Windows for avoiding this bug:
powercfg /h off


# Safely remove USB drive 安全移除 USB 设备
udisksctl unmount -b /dev/sdXY # or /dev/disk/by-label/my-usb
udisksctl power-off -b /dev/sdX # or /dev/disk/by-label/my-usb
