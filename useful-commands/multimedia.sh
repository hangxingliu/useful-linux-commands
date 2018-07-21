# Commands about multi-media
# Video, audio, images, camera, microphone, screen capture...

# Multi-media player (VLC)
# install vlc media player in ubuntu
# libavcodec-extra is support streaming or transcoding
sudo apt-get install vlc browser-plugin-vlc libavcodec-extra

# Screen GIF capture (Peek) 屏幕Gif录制工具
sudo add-apt-repository ppa:peek-developers/stable
sudo apt update && sudo apt install peek

# Virtual-Webcam from screen capture 从屏幕录像创建一个虚拟的摄像头
# (Streaming screen capture to camera) (将屏幕录像串流到摄像头)
## 1. Install v4l2loopback (for create "virtual video devices") 安装
sudo apt install v4l2loopback-dkms # or visit: https://github.com/umlaeute/v4l2loopback
## 2. Enable v4l2loopback module: 启用:
sudo modprobe v4l2loopback
## Example: enable 3 virtual devices:  sudo modprobe v4l2loopback devices=3
## Options example:
##  devices=3        enable 3 devices
##  video_nr=4,5,6   set device id to /dev/video4, /dev/video5 and /dev/video6
##  card_label="myCam1","myCam2","myCam3"
##
## 3. Streaming screen to virtual-device by ffmpeg: 串流(ffmpeg):
ffmpeg -f x11grab -r 15 -s 1920x1080 -i :0.0+0,0 -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/video0
## Command description:
##   -r 15           15 frame rate
##   -s 1920x1080    screen resolution
##   -i :0.0+0,0     x11 server 0; screen id 0; x offset: 0; y offset: 0
## 4. Optional(可选), unload v4l2loopback. 关闭v4l2loopback模块
modprobe -r v4l2loopback
