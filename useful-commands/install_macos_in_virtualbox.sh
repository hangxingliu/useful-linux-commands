# Install macOS in VirtualBox(VM)
# Some commands and settings about how to install macOS High Sierra in VirtualBox on Ubuntu

# Warning!
# Personal Test, My Desktop's CPU is AMD Ryzen 1700. It seems not supported! (貌似不支持AMD的CPU)

# Step 1. Get macOS High Sierra ISO file 获得一个 macOS High Sierra ISO文件
# Google Drive? Create from macOS? ... search on Google
# 上网搜索一下, 从网盘获取, 自己从macOS系统中制作一个...


# Step 2. Create VM in VirtualBox 在VirtualBox中创建虚拟机
## Type: Mac OS X
## Version: Mac OS X (64-bit)
## Memory: >= 4096 MB
## Hard disk: VDI/Fixed Size/50GB
## Boot Order: disable "Floopy" 取消选择软盘
## CPU: >= 2
## Video Memory: 128MB 显存调到最大


# Step 3. Configure VM in terminal 在终端中配置虚拟机
VM_NAME="OSX1013"; # Your VM name
VBoxManage modifyvm "$VM_NAME" --cpuidset 00000001 000306a9 04100800 7fbae3ff bfebfbff
VBoxManage setextradata "$VM_NAME" "VBoxInternal/Devices/efi/0/Config/DmiSystemProduct" "MacBookPro11,3"
VBoxManage setextradata "$VM_NAME" "VBoxInternal/Devices/efi/0/Config/DmiSystemVersion" "1.0"
VBoxManage setextradata "$VM_NAME" "VBoxInternal/Devices/efi/0/Config/DmiBoardProduct" "Mac-2BD1B31983FE1663"
VBoxManage setextradata "$VM_NAME" "VBoxInternal/Devices/smc/0/Config/DeviceKey" "ourhardworkbythesewordsguardedpleasedontsteal(c)AppleComputerInc"
VBoxManage setextradata "$VM_NAME" "VBoxInternal/Devices/smc/0/Config/GetKeyFromRealSMC" 1


# Step 4. Start VM and Install 启动虚拟机并安装
## `Language` -> `Next` -> `macOS Utilies` -> `Disk Utilies` -> (menu)`View` -> `Show All Devices`
## `Erase` ->
## Name: Macintosh HD
## Format: Mac OS Extended (Journled)
## Scheme: GUID Partition Map
## -> `Reinstall macOS` -> `Continue` ...


# Step 5. Boot macOS VM 启动 macOS 虚拟机
## Remove macOS install ISO disk file in VirtualBox: `Settings` -> `Storage` -> Remove `xxxx.iso`
## Start VM, input commands:
cd "macOS Install Data"
cd "Locked Files"
cd "Boot Files"
boot.efi

