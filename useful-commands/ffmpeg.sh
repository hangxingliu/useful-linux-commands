# FFmpeg
# useful FFmpeg snippets
# (FFmpeg is a free software project that produces libraries and programs for handling multimedia data.)

## Options 选项
-i input.mp4
-vcodec rawvideo # video encoder: "rawvideo"(same with input) in default
-acodec copy # audio encoder

## Media Info 媒体文件信息
ffmpeg -i input.mp4 -hide_banner # hide_banner for hidding gcc/configuration info (too long)

## Slice video 切割视频
## https://superuser.com/questions/138331/using-ffmpeg-to-cut-up-video
## -ss format: HH:MM:SS.xxx or s.msec
ffmpeg -i input.wmv -ss 00:00:30.0 -c copy -t 00:00:10.0 output.wmv
ffmpeg -i input.wmv -ss 30 -c copy -t 10 output.wmv
ffmpeg -i input.wmv -ss 30 -c copy -to 40 output.wmv # same with last command
