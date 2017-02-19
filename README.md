[![license](https://img.shields.io/badge/license-BSD--3--Clause-blue.svg)](https://img.shields.io/badge/license-BSD--3--Clause-blue.svg)

# Intro

This text will be used to provide a gentle introduction to video technology, although it's aimed to software developers / engineering we want to make it easy for anyone to learn.

The idea is to introduce some video subjects with an ease to understand text (at least for developers), visual element and practical examples where is possible. Also, feel free to send error corrections, suggestions, grammar fixes, and etc via PRs.

There will be hands-on sections which requires you to have docker installed and this repo cloned.

```bash
git clone https://github.com/leandromoreira/introduction_video_technology.git
cd introduction_video_technology
./setup.sh
```
All the hands-on should be performed from the folder you cloned this repository.

# Index

- [Intro](#intro)
- [Index](#index)
- [Basic video/image terminology](#basic-videoimage-terminology)
      - [Other ways to encode a color image](#other-ways-to-encode-a-color-image)
      - [Play around with image and color](#play-around-with-image-and-color)
      - [DVD is DAR 4:3](#dvd-is-dar-43)
      - [Hands-on: Check video properties](#hands-on-check-video-properties)
- [Image capture](#image-capture)
- [Redundancy removal](#redundancy-removal)
- [How does a video codec work?](#how-does-a-video-codec-work)
  * [A little bit of the past and present](#a-little-bit-of-the-past-and-present)
  * [1st step - picture partitioning](#1st-step---picture-partitioning)
  * [2nd step - predictions](#2nd-step---predictions)
  * [3rd step - transform](#3rd-step---transform)
  * [4th step - quantization](#4th-step---quantization)
  * [5th step - entropy coding](#5th-step---entropy-coding)
    + [Delta coding:](#delta-coding)
    + [VLC coding:](#vlc-coding)
    + [Arithmetic coding:](#arithmetic-coding)
    + [Hands-on: CABAC vs CAVLC](#hands-on-cabac-vs-cavlc)
  * [6th step - bitstream format](#6th-step---bitstream-format)
- [How H265 can achieve better compression ratio than H264](#how-h265-can-achieve-better-compression-ratio-than-h264)
- [Adaptive streaming](#adaptive-streaming)
- [Encoding parameters the whys](#encoding-parameters-the-whys)
- [Audio codec](#audio-codec)
- [How to use jupyter](#how-to-use-jupyter)
- [References](#references)

# Basic video/image terminology

An **image** can be thought as a **2D matrix** and if we think about **colors**, we can extrapolate this idea seeing this image as a **3D matrix** where the **additional dimensions** are used to provide **color info**.

If we chose to represent these colors using the [primary colors (red, green and blue)](https://en.wikipedia.org/wiki/Primary_color), we then can define the tree planes: the first one **red**, the second **green** and the last the **blue** color.

![an image is a 3d matrix RGB](/i/image_3d_matrix_rgb.png "An image is a 3D matrix")

Each point in this matrix, we'll call it **a pixel** (picture element), will hold the **intensity** (usually a numeric value) of that given color. A **total red color** means 0 of green, 0 of blue and max of red, the **pink color** can be formed with (using 0 to 255 as the possible range) with **Red=255, Green=192 and Blue=203**.

> #### Other ways to encode a color image
> There are much more models to represent an image with colors. We could use a indexed palette where we'd spend only a byte for each pixel instead of 3, comparing it to RGB model. In this model instead of a 3D matrix we'd use a 2D matrix, saving memory but having much less color options.
> ![NES palette](/i/nes-color-palette.png "NES palette")

For instance, look at the first Super Mario's picture down bellow, we can see that it has a lots of red and few blue colors therefore the **red color** will be the one that **contributes more** (the brightest parts) to the final color while the **blue color** contribution can be mostly **only seen in Mario's eyes** and part of his clothes.

![RGB channels intensity](/i/rgb_channels_intensity.png "RGB channels intensity")

And each color intensity requires a certain amount of bits, this quantity is know as **bit depth**. Let's say we spend **8 bits** (accepting values from 0 to 255) per color (plane), therefore we have a **color depth** of **24 (8 * 3) bits** and we can also infer that we could use 2 to the power of 24 different colors.

An image has also another property such as **resolution** which is the number of pixels in each dimension. It is often presented as width × height,  for example the **4×4** image bellow.

![image resolution](/i/resolution.png "image resolution")

> #### Play around with image and color
> You can [play around with image and colors](/image_as_3d_array.ipynb) using [jupyter](#how-to-use-jupyter) (python, numpy, matplotlib and etc).
>
> You also can learn [how image filters (edge detection, sharpen, blur...) work](/filters_are_easy.ipynb).

Another property we can see while working with images or video is **aspect ratio** which is simple describes the proportional relationship between width and height of an image or pixel.

When people says this movie or picture is **16x9** they usually are referring to the **Display Aspect Ratio (DAR)** and we also can have different shapes of a pixel, we call this **Pixel Aspect Ratio (PAR)**.

![display aspect ratio](/i/DAR.png "display aspect ratio")

![pixel aspect ratio](/i/PAR.png "pixel aspect ratio")

> #### DVD is DAR 4:3
> Although the real resolution of a DVD is 704x480 it still keeps a 4:3 aspect ratio because it has a PAR of 10:11 (704x10/480x11)

Finally we can define a **video** as a **succession of *n* frames** in **time** which can be seen as another dimension, *n* is the frame rate or frames per second(FPS).

![video](/i/video.png "video")

The amount of bits per second needed to show a video is its **bit rate**. For example, a video with 30 frames per second, 24 bits per pixel, resolution of 480x240 will need **82,944,000 bits per second** or 82.944 Mbps (30x480x240x24) if we don't employ any kind of compression.

When the **bit rate** is constant it's called constant bit rate (**CBR**) but it also can vary then called variable bit rate (**VBR**).

![constrained vbr](/i/vbr.png "constrained vbr")

In the early days engineering come up with a technique for doubling the perceived frame rate of a video display **without consuming extra bandwidth**, this technique is known as **interlaced video**. It basically sends half of the screen in 1 "frame" and the next "frame" they send the other half.

Today screens render mostly using **progressive scan technique**, progressive is a way of displaying, storing, or transmitting moving images in which all the lines of each frame are drawn in sequence.

![interlaced vs progressive](/i/interlaced_vs_progressive.png "interlaced vs progressive")

Now we have an idea about what is an **image**, how its **colors** are arranged, how many **bits per second** do we spend to show a video, if it's constant (CBR)  or variable (VBR), with a given **resolution** using a given **frame rate** and many other terms such as interlaced, PAR and others.

> #### Hands-on: Check video properties
> You can [check most of the  explained properties with ffmpeg or mediainfo.](https://github.com/leandromoreira/introduction_video_technology/blob/master/enconding_pratical_examples.md#inspect-stream)

# Image capture

[WIP]

# Redundancy removal

[WIP]

# How does a video codec work?

[WIP]

## A little bit of the past and present

## 1st step - picture partitioning

## 2nd step - predictions

## 3rd step - transform

## 4th step - quantization

## 5th step - entropy coding

After we quantized the data (image blocks/slices/frames) we still can compress it in a lossless way. There are many ways (algorithms) to compress data. We're going to briefly experience some of them, for a deeper understanding you can read the amazing book [Understanding Compression: Data Compression for Modern Developers](https://www.amazon.com/Understanding-Compression-Data-Modern-Developers/dp/1491961538/).

### Delta coding:

I love the simplicity of this method (it's amazing), let's say we need to compress the following numbers `[0,1,2,3,4,5,6,7]` and if we just decrease the current number to its previous and we'll get the `[0,1,1,1,1,1,1,1]` array which is highly compressible.

Both encoder and decoder **must know** the rule of delta formation.

### VLC coding:

Let's suppose we have a stream with the symbols: **a**, **e**, **r** and **t** and their probability (from 0 to 1) is represented by this table.

|             | a   | e   | r    | t   |
|-------------|-----|-----|------|-----|
| probability | 0.3 | 0.3 | 0.2 |  0.2 |

We can assign unique binary codes (preferable small) to the most probable and bigger codes to the least probable ones.

|             | a   | e   | r    | t   |
|-------------|-----|-----|------|-----|
| probability | 0.3 | 0.3 | 0.2 | 0.2 |
| binary code | 0 | 10 | 110 | 1110 |

Let's compress the stream **eat**, assuming we would spend 8 bits for each symbol, we would spend **24 bits** without any compression. But in case we replace each symbol for its code we can save space.

The first step is to encode the symbol **e** which is `10` and the second symbol is **a** which is added (not in the mathematical way) `[10][0]` and finally the third symbol **t** which makes our final compressed bitstream to be `[10][0][1110]` or `1001110` which only requires **7 bits** (3.4 times less space than the original).

Notice that each code must be a unique prefixed code [Huffman can help you to find these numbers](https://en.wikipedia.org/wiki/Huffman_coding). Though it has some issues there are [video codecs that still offers](https://en.wikipedia.org/wiki/Context-adaptive_variable-length_coding) this method and it's the  algorithm for many application which requires compression.

Both encoder and decoder **must know** the symbol table with its code therefore you need to send the table too.

### Arithmetic coding:

Let's suppose we have a stream with the symbols: **a**, **e**, **r**, **s** and **t** and their probability is represented by this table.

|             | a   | e   | r    | s    | t   |
|-------------|-----|-----|------|------|-----|
| probability | 0.3 | 0.3 | 0.15 | 0.05 | 0.2 |

With this table in mind we can build ranges containing all the possible symbols sorted by the most frequents.

![initial arithmetic range](/i/range.png "initial arithmetic range")

Now let's encode the stream **eat**, we pick the first symbol **e** which is located within the subrange **0.3 to 0.6** (but not included) and we take this subrange and split it again using the same proportions used before but within this new range.

![second sub range](/i/second_subrange.png "second sub range")

Let's continue to encode our stream **eat**, now we take the second symbol **a** which is within the new subrange **0.3 to 0.39** and then we take our last symbol **t** and we do the same process again and we get the last subrange **0.354 to 0.372**.

![final arithmetic range](/i/arithimetic_range.png "final arithmetic range")

We just need to pick a number within the last subrange **0.354 to 0.372**, let's chose **0.36** but we could chose any number within this subrange. With **only** this number we'll be able to recovery our original stream **eat**. If you think about it, it's like if we were drawing a line within ranges of ranges to encode our stream.

![final range traverse](/i/range_show.png "final range traverse")

The **reverse process** (A.K.A. decoding) is equally easy, with our number **0.36** and our original range we can run the same process but now using this number to reveal the stream encoded behind this number.

With the first range we notice that our number fits at the **e** slice therefore it's our first symbol, now we split this subrange again, doing the same process as before, and we'll notice that **0.36** fits the symbol **a** and after we repeat the process we came to the last symbol **t** (forming our original encoded stream *eat*).

Both encoder and decoder **must know** the symbol probability table, therefore you need to send the table.

Pretty neat isn't? People are damm smart to come up with such solution, some [video codec uses](https://en.wikipedia.org/wiki/Context-adaptive_binary_arithmetic_coding) (or at least offers as an option) this technique.

The idea is to lossless compress the quantized bitstream, for sure this article is missing tons of details, reasons, trade-offs and etc. But [you should learn more](https://www.amazon.com/Understanding-Compression-Data-Modern-Developers/dp/1491961538/) as a developer.

> ### Hands-on: CABAC vs CAVLC
> You can [generate two streams, one with CABAC and other with CAVLC](https://github.com/leandromoreira/introduction_video_technology/blob/master/enconding_pratical_examples.md#cabac-vs-cavlc) and **compare the time** it took to generate each of them as well as **the final size**.

## 6th step - bitstream format

# How H265 can achieve better compression ratio than H264

[WIP]

# Adaptive streaming

[WIP]

# Encoding parameters the whys

[WIP]

# Audio codec

[WIP]

# How to use jupyter

Make sure you have **docker installed** and just run `./s/start_jupyter.sh` and follow the instructions on the terminal.

# References

* https://www.coursera.org/learn/digital/
* https://www.amazon.com/Understanding-Compression-Data-Modern-Developers/dp/1491961538/ref=sr_1_1?s=books&ie=UTF8&qid=1486395327&sr=1-1
* https://www.amazon.com/Practical-Guide-Video-Audio-Compression/dp/0240806301/ref=sr_1_3?s=books&ie=UTF8&qid=1486396914&sr=1-3&keywords=A+PRACTICAL+GUIDE+TO+VIDEO+AUDIO
* https://storage.googleapis.com/downloads.webmproject.org/docs/vp9/vp9-bitstream-specification-v0.6-20160331-draft.pdf
* https://www.amazon.com/Video-Encoding-Numbers-Eliminate-Guesswork/dp/0998453005/ref=sr_1_1?s=books&ie=UTF8&qid=1486396940&sr=1-1&keywords=jan+ozer
* https://arxiv.org/pdf/1702.00817v1.pdf
* http://www.cambridgeincolour.com/tutorials/camera-sensors.htm
* https://en.wikipedia.org/wiki/Intra-frame_coding
* https://en.wikipedia.org/wiki/Inter_frame
* http://stackoverflow.com/questions/38094302/how-to-understand-header-of-h264
* http://gentlelogic.blogspot.com.br/2011/11/exploring-h264-part-2-h264-bitstream.html
* https://trac.ffmpeg.org/wiki/Encode/H.264
* http://www.itu.int/ITU-T/recommendations/rec.aspx?rec=12904&lang=en
* https://cardinalpeak.com/blog/worlds-smallest-h-264-encoder/
* https://cardinalpeak.com/blog/the-h-264-sequence-parameter-set/
* https://codesequoia.wordpress.com/category/video/
* https://ffmpeg.org/ffprobe.html
* https://en.wikipedia.org/wiki/Presentation_timestamp
* https://www.linkedin.com/pulse/video-streaming-methodology-reema-majumdar
* https://leandromoreira.com.br/2016/10/09/how-to-measure-video-quality-perception/
* https://www.linkedin.com/pulse/brief-history-video-codecs-yoav-nativ
* http://www.slideshare.net/vcodex/a-short-history-of-video-coding
* https://en.wikibooks.org/wiki/MeGUI/x264_Settings
* http://www.slideshare.net/vcodex/introduction-to-video-compression-13394338
* https://www.lifewire.com/cmos-image-sensor-493271
* https://www.youtube.com/watch?v=9vgtJJ2wwMA
* https://developer.android.com/guide/topics/media/media-formats.html
* https://www.encoding.com/android/
* http://www.nintendo.com/switch/
* https://developer.apple.com/library/content/technotes/tn2224/_index.html
* http://www.lighterra.com/papers/videoencodingh264/
* http://www.slideshare.net/ManoharKuse/hevc-intra-coding
* http://www.slideshare.net/mwalendo/h264vs-hevc
* http://www.slideshare.net/rvarun7777/final-seminar-46117193
* http://x265.org/hevc-h265/
* http://www.compression.ru/video/codec_comparison/h264_2012/mpeg4_avc_h264_video_codecs_comparison.pdf
* http://vanseodesign.com/web-design/color-luminance/
* https://en.wikipedia.org/wiki/AOMedia_Video_1
* http://www.hkvstar.com
* http://www.hometheatersound.com/
* https://www.vcodex.com/h264avc-intra-precition/
* http://bbb3d.renderfarming.net/download.html
* http://www.slideshare.net/vcodex/a-short-history-of-video-coding
* https://sites.google.com/site/linuxencoding/x264-ffmpeg-mapping
* https://www.encoding.com/http-live-streaming-hls/
* https://en.wikipedia.org/wiki/Adaptive_bitrate_streaming
* http://www.adobe.com/devnet/adobe-media-server/articles/h264_encoding.html
* https://www.youtube.com/watch?v=Lto-ajuqW3w&list=PLzH6n4zXuckpKAj1_88VS-8Z6yn9zX_P6
* https://www.youtube.com/watch?v=LFXN9PiOGtY
* https://github.com/leandromoreira/encoding101
* https://people.xiph.org/~jm/daala/revisiting/
* https://cardinalpeak.com/blog/the-h-264-sequence-parameter-set/
* https://cardinalpeak.com/blog/worlds-smallest-h-264-encoder/
* https://people.xiph.org/~tterribe/pubs/lca2012/auckland/intro_to_video1.pdf
* https://tools.ietf.org/html/draft-fuldseth-netvc-thor-03
* https://prezi.com/8m7thtvl4ywr/mp3-and-aac-explained/
* http://www.slideshare.net/MadhawaKasun/audio-compression-23398426
* http://techblog.netflix.com/2016/08/a-large-scale-comparison-of-x264-x265.html
* http://yumichan.net/video-processing/video-compression/introduction-to-h264-nal-unit/
* http://www.springer.com/cda/content/document/cda_downloaddocument/9783642147029-c1.pdf
* http://iphome.hhi.de/wiegand/assets/pdfs/2012_12_IEEE-HEVC-Overview.pdf
* http://www.red.com/learn/red-101/video-chroma-subsampling
* http://www.streamingmedia.com/Articles/Editorial/Featured-Articles/A-Progress-Report-The-Alliance-for-Open-Media-and-the-AV1-Codec-110383.aspx
* http://www.explainthatstuff.com/digitalcameras.html
* https://www.youtube.com/watch?v=LWxu4rkZBLw
* http://www.csc.villanova.edu/~rschumey/csc4800/dct.html
* https://en.wikipedia.org/wiki/File:H.264_block_diagram_with_quality_score.jpg
* https://softwaredevelopmentperestroika.wordpress.com/2014/02/11/image-processing-with-python-numpy-scipy-image-convolution/
* http://stackoverflow.com/a/24890903
* https://xiph.org/video/vid1.shtml
* https://xiph.org/video/vid2.shtml
* http://web.ece.ucdavis.edu/cerl/ReliableJPEG/Cung/jpeg.html
* https://en.wikipedia.org/wiki/Pixel_aspect_ratio
