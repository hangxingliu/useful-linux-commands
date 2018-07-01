# Raspberry Pi
# The Raspberry Pi is a tiny and affordable computer that you can use to learn programming through fun, practical projects.



# Install Operating System Images for Raspberry Pi (为树莓派安装系统镜像)
## 1. Insert your SD card into computer (插入SD卡)
## 2. List all device:
lsblk
## 3. Unmount SD card:
umount /dev/sdX1 # replace "X" to sepcial char (替换字符 X 到实际的字符)
umount /dev/sdX2 # ...
## Copy image to SD card:
sudo dd bs=4M if=2018-04-18-raspbian-stretch.img of=/dev/sdX conv=fsync



# Raspberry Pi can't launch, throuble shooting: (树莓派无法启动)

## Trouble:
##     Kernel panic-not syncing: VFS: unable to mount root fs on unknown- block(179,2)
## Resolve:
## 1. Insert your SD card into your other computer (插入SD卡到其他电脑)
## 2. Example commands:
fdisk -l
fsck.fat -y /dev/sdX1
fsck.ext4 -y /dev/sdX2
## 3. Details:
## https://raspberrypi.stackexchange.com/questions/81516/kernel-panic-not-syncing-vfs-unable-to-mount-root-fs-on-unknown-block179-6


# Connect Raspberry Pi over USB-TTL cable (通过USB-TTL线连接树莓派)

# Sketch: (示意图)
# Environment: Raspberry Pi 3B + PL2303 HXD USB Cable (树莓派3B+PL2303 USB线)
# **WARNING!!! 警告!!!**
# DON'T connect external power if VCC is connected!!!
# 如果你接上了 VCC (红色) PIN 口, 请不要再连接额外的电源, 否则树莓派有可能被损坏!
# -----------
#         O  \
#            |
#    [ ] [x] |  <-- 2: VCC (Red)    5V
#    [ ] [ ] |
#    [ ] [x] |  <-- 6: GND (Black)  Ground 地线
#    [ ] [x] |  <-- 8: RXD (White)  GPIO14
#    [ ] [x] |  <-- 10: TXD (Green) GPIO15
#    [ ] [ ] |
#    [ ] [ ] |
#            |
#    ......  |
#            |
# USB   USB  |
#            /
# -----------

# Then input commands on your computer: 然后输入命令:
# Please install `screen` before (sudo apt install screen)
ls /dev/ttyUSB*
sudo screen /dev/ttyUSBX 115200
# replace 'X' to special character you can get it in output of last command.
# 请替换 'X' 到具体的字符 (你可以通过前一条命令获得)



# Setting WIFI up via the command line (命令行连接WIFI)

## 1. scan visiable WIFI: 扫描可见WIFI:
sudo iwlist wlan0 scan # youn can get name of WIFI in output looks like:  ESSID: "name"

## 2. add network details to Raspberry Pi
sudo nano /etc/wpa_supplicant/wpa_supplicant.conf
## append config:
network={
	ssid="WIFI_Name"
	psk=131e1e221f6e06e3911a2d11ff2fac9182665c004de85300f9cac208a6a80531
}
## You can get network config by following command:
wpa_passphrase "WIFI_Name" "WIFI_Password"
## If your WIFI is hidden, add option `scan_ssid` into network config:
scan_ssid=1

## 3. Apply changes 确认更改
wpa_cli -i wlan0 reconfigure

