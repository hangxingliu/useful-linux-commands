# ImageMagick 图像工具库

# 查看图像基本信息(格式,尺寸,...)
identify file.jpg # identify *.jpg

# 显示图片
display file.jpg
display *.png #一张一张地显示所有png文件
display -resize 50% file.jpg #缩放50%显示

# 转换图片
convert input [options] output # output可以是- 表示到标准输出
# 转换并显示
convert input.jpg ... - | display
# 转换格式
convert input.jpg output.png
# 转换尺寸
convert from.jpg -resize 64x64 to.jpg
convert from.jpg -resize 50% to.jpg
# 批量裁剪图片 (从(0,0)处裁剪出100x100的图像)
convert *.jpg -crop 100x100+0+0 cropped-%d.jpg
# 将一个图片分割成最大(100x100)的小图像
convert test.jpg -crop 100x100 small-%d.jpg
# canny算子的边缘检测 (反色)
convert test.jpg -canny 0x1 -negate to.jpg

# 截图
import screenshot.jpg # 截图(手动选择范围)
import -window root screenshot.jpg # 截取整个屏幕

# 合并图片
# 例子: 添加水印 (水印到图片右下方,偏移(x-10;y+5)的位置 )
composite -gravity SouthEast -geometry -10+5 watermark.png from.jpg to.jpg
# 指定 -compose 参数可以设置合并方法: multiply screen difference exclusion
# -gravity: North South East West Center 
