% 视频基本知识培训
% 汪立民
% 07/016/2017

# 基本概念 

------

### 三原色

* **红色(Red)**
* **绿色(Green)**
* **蓝色(Blue)**

-----

![an image is a 3d matrix RGB](/i/image_3d_matrix_rgb.png "An image is a 3D matrix")

-----

### 像素

* 三纬矩阵里的每一个点, 我们称为**像素**
* 每个像素是由不同强度的三原色(RGB)光组成）
    - **红色像素**: **红色 255， 绿色0， 蓝色0**
    - **粉色像素**: **红色 255、绿色 192、蓝色 203**

-----

![RGB channels intensity](/i/rgb_channels_intensity.png "RGB channels intensity")

------


### 位深

* 每个颜色的强度，采用一定数量的二进制位数来存储
* 位数大小被称为颜色深度
* 假如每个颜色的强度占用8bit，那么颜色深度就是24

--------

### 分辨率

* 一个平面内像素的数量
* 可以表示成宽 x 高，例如下面这张 **4x4** 的图像

------

![image resolution](/i/resolution.png "image resolution")

-----

### 宽高比

* 图像或像素的宽度和高度之间的一个比例关系。
* 当人们说这个电影或图像是 **16:9** 时，通常是指**显示纵横比（DAR)**
* 形状不同的单个像素，我们称为像素纵横比（PAR）。

------

![display aspect ratio](/i/DAR.png "display aspect ratio")


------

![pixel aspect ratio](/i/PAR.png "pixel aspect ratio")


------


### DVD 4:3 显示纵横比 

* DVD 的实际分辨率是704x480，但他的纵横比却为4:3
  - 它的像素纵横比是10:11（704x10／480x11)。

-------

### 帧率

* **视频**可以定义为在**单位时间**内**连续的 n 帧**

   - 时间可以视为另一个维度
   - n 即为帧率，或每秒帧数(FPS)。

------

![video](/i/video.png "video")


-----

### 比特率

* 播放一段视频每秒所需的比特数就是它的**比特率**
*  原始比特率 = 宽 * 高 * 位深 * 帧率 
    - 例如，帧率30，位深为24，分辨率为480x240的视频 
    - 未压缩数据量为82.944 Mbps (30x480x240x24)。
* CBR, 当**比特率**接近恒定时称为恒定比特率
* VBR, 当**比特率**是波动的，但最大码率和最小码率范围有限制

------

![constrained vbr](/i/vbr.png "constrained vbr")


------

### 隔行扫描 

* 一部分由奇数行组成，称为奇数场
* 另一部分就是偶数行组成，称为偶数行。
* 在隔行扫描中, 奇数行扫完后接着扫偶数行

-------

### 逐行扫描

* 一般黑白电视和老的彩色电视都采用隔行扫描
* 计算机显示器, 手机，pad, 新的4K电视都使用逐行扫描显示
* 电子束从显示屏的左上角一行接一行地扫到右下角


------

![interlaced vs progressive](/i/interlaced_vs_progressive.png "interlaced vs progressive")


# 结束，谢谢!
