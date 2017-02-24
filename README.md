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
All the hands-on should be performed from the folder you cloned this repository, for the **jupyter examples** you must start the server `./s/start_jupyter.sh` and follow the instructions.

# Index

- [Intro](#intro)
- [Index](#index)
- [Basic video/image terminology](#basic-videoimage-terminology)
      - [Other ways to encode a color image](#other-ways-to-encode-a-color-image)
      - [Hands-on: play around with image and color](#hands-on-play-around-with-image-and-color)
      - [DVD is DAR 4:3](#dvd-is-dar-43)
      - [Hands-on: Check video properties](#hands-on-check-video-properties)
- [Image capture](#image-capture)
- [Redundancy removal](#redundancy-removal)
  * [Colors, Luminance and our eyes](#colors-luminance-and-our-eyes)
  * [Frame types](#frame-types)
    + [I Frame (intra, keyframe)](#i-frame-intra-keyframe)
    + [P Frame (predicted)](#p-frame-predicted)
    + [B Frame (bi-predictive)](#b-frame-bi-predictive)
  * [Temporal redundancy (inter prediction)](#temporal-redundancy-inter-prediction)
  * [Spatial redundancy (intra prediction)](#spatial-redundancy-intra-prediction)
- [How does a video codec work?](#how-does-a-video-codec-work)
  * [A little bit of the past and present](#a-little-bit-of-the-past-and-present)
    + [Past](#past)
    + [Present (AV1 vs HEVC)](#present-av1-vs-hevc)
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
    + [H264 bitstream](#h264-bitstream)
    + [Hands-on: Inspect the H264 bitstream](#hands-on-inspect-the-h264-bitstream)
- [How H265 can achieve better compression ratio than H264](#how-h265-can-achieve-better-compression-ratio-than-h264)
- [Adaptive streaming](#adaptive-streaming)
  * [What? Why? How?](#what-why-how)
  * [HLS and Dash](#hls-and-dash)
  * [Building a bit rate ladder](#building-a-bit-rate-ladder)
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
>
> ![NES palette](/i/nes-color-palette.png "NES palette")

For instance, look at the picture down bellow, the first face is full colored, the rest is the red, green and blue (but in gray tones) planes.

![RGB channels intensity](/i/rgb_channels_intensity.png "RGB channels intensity")

We can see that the **red color** will be the one that **contributes more** (the brightest parts in the second face) to the final color while the **blue color** contribution can be mostly **only seen in Mario's eyes** (last face) and part of his clothes.


And each color intensity requires a certain amount of bits, this quantity is know as **bit depth**. Let's say we spend **8 bits** (accepting values from 0 to 255) per color (plane), therefore we have a **color depth** of **24 (8 * 3) bits** and we can also infer that we could use 2 to the power of 24 different colors.

An image has also another property such as **resolution** which is the number of pixels in each dimension. It is often presented as width × height,  for example the **4×4** image bellow.

![image resolution](/i/resolution.png "image resolution")

> #### Hands-on: play around with image and color
> You can [play around with image and colors](/image_as_3d_array.ipynb) using [jupyter](#how-to-use-jupyter) (python, numpy, matplotlib and etc).
>
> You can also learn [how image filters (edge detection, sharpen, blur...) work](/filters_are_easy.ipynb).

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

## Colors, Luminance and our eyes

## Frame types

### I Frame (intra, keyframe)

### P Frame (predicted)

### B Frame (bi-predictive)

## Temporal redundancy (inter prediction)

## Spatial redundancy (intra prediction)


# How does a video codec work?

[WIP]

## A little bit of the past and present

### Past

### Present (AV1 vs HEVC)

## 1st step - picture partitioning

Each picture is partitioned in several images units

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

The idea is to lossless compress the quantized bitstream, for sure this article is missing tons of details, reasons, trade-offs and etc. But [you should learn more](https://www.amazon.com/Understanding-Compression-Data-Modern-Developers/dp/1491961538/) as a developer. Newer codecs are trying to use different [entropy coding algorithms like ANS.](https://en.wikipedia.org/wiki/Asymmetric_Numeral_Systems)

> ### Hands-on: CABAC vs CAVLC
> You can [generate two streams, one with CABAC and other with CAVLC](https://github.com/leandromoreira/introduction_video_technology/blob/master/enconding_pratical_examples.md#cabac-vs-cavlc) and **compare the time** it took to generate each of them as well as **the final size**.

## 6th step - bitstream format

After we did all these steps we need to **pack the compressed frames and context to these steps**. We need to explicitly inform to the decoder about **the decisions taken by the encoder**, things like: bit depth, color space, resolution, predictions info (motion vectors, direction of prediction), profile, level, frame rate and more.

We're going to study superficially the H264 bitstream. Our first step is to [generate a minimal H264 bitstream](/enconding_pratical_examples.md#generate-a-single-frame-h264-bitstream), we can do that using our own repository and ffmpeg.

```
./s/ffmpeg -i /files/i/minimal.png -pix_fmt yuv420p /files/v/minimal_yuv420.h264
```

This command will generate a raw h264 bitstream with a single frame, 64x64 and with color space yuv420p.

### H264 bitstream

The AVC (H264) standard defines that the information will be send in **macro frames** (in the network sense), called **[NAL](https://en.wikipedia.org/wiki/Network_Abstraction_Layer)** (Network Abstraction Layer). The main goal of the NAL is the provision of a "network-friendly" video representation, this standard must work on TVs (stream based), Internet (packet based) among others.

![NAL units H264](/i/nal_units.png "NAL units H264")

There is the **synchronization marker** to define the boundaries among the NAL's units. Each synchronization marker holds a value of `0x00 0x00 0x01` except the first one which is `0x00 0x00 0x00 0x01`. If we run the **hexdump** on the minimal h264 bitstream we can identify at least three NALs.

![synchronization marker on NAL units](/i/minimal_yuv420_hex.png "synchronization marker on NAL units")

As we said before, the decoder needs to knows not only the picture data but also the details of the video, the used parameters and others. The **first byte** of each NAL defines its priority and **type**.

| Id  | Description  |
|---  |---|
| 0  |  Undefined |
| 1  |  Coded slice of a non-IDR picture |
| 2  |  Coded slice data partition A |
| 3  |  Coded slice data partition B |
| 4  |  Coded slice data partition C |
| 5  |  **IDR** Coded slice of an IDR picture |
| 6  |  **SEI** Supplemental enhancement information |
| 7  |  **SPS** Sequence parameter set |
| 8  |  **PPS** Picture parameter set |
| 9  |  Access unit delimiter |
| 10 |  End of sequence |
| 12 |  End of stream |
| ... |  ... |

Usually the first NAL of a bitstream is a **SPS** which makes sense, since this type of NAL is responsible to inform the general encoding variables like **profile**, **level**, **resolution** and others.

If we skip the first synchronization marker we can decode the first byte to know what type of NAL is the following.

For instance the first byte after the synchronization marker is `01100111`, where the first bit (`0`) is to the field **forbidden_zero_bit**, the next 2 bits (`11`) tell us the field **nal_ref_idc** which indicates whether this NAL is a reference field or not and the rest 5 bits (`00111`) inform us the field **nal_unit_type**, in this case it's a **SSP** (7) NAL unit.

The next byte of a SSP NAL is the field **profile_idc** which shows the profiler that the encoder has used, in this case we used the **High profiler** (`binary=01100100, hex=0x64, dec=100`)

![SPS binary view](/i/minimal_yuv420_bin.png "SPS binary view")

I think you got the idea, it's like a protocol and if you want or need to learn more about this bitstream please read the [ITU H264 spec.]( http://www.itu.int/rec/T-REC-H.264-201610-I) Here's a macro diagram which shows where the picture data (compressed YUV) resides.

![SPS binary view](/i/h264_bitstream_macro_diagram.png "SPS binary view")


> ### Hands-on: Inspect the H264 bitstream
> We can [generate a single frame video](https://github.com/leandromoreira/introduction_video_technology/blob/master/enconding_pratical_examples.md#generate-a-single-frame-video) and use  [mediainfo](https://en.wikipedia.org/wiki/MediaInfo) to inspect its H264 bitstream. In fact, you can even see the [source code that parses h264 (AVC)](https://github.com/MediaArea/MediaInfoLib/blob/master/Source/MediaInfo/Video/File_Avc.cpp) bitstream.
>
> ![mediainfo details h264 bitstream](/i/mediainfo_details_1.png "mediainfo details h264 bitstream")
>
> We can also use the [Intel Video Pro Analyzer](https://software.intel.com/en-us/intel-video-pro-analyzer) which is paid but there is a free trial version which limits you to only the first 10 frames but that's okay for learning purposes.
>
> ![intel video pro analyzer details h264 bitstream](/i/intel-video-pro-analyzer.png "intel video pro analyzer details h264 bitstream")

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

The richest content is here, where all the info we saw in this text was extracted, based or inspired by. You can deepen your knowledge with these amazing links, books, videos and etc.

* https://www.coursera.org/learn/digital/
* https://storage.googleapis.com/downloads.webmproject.org/docs/vp9/vp9-bitstream-specification-v0.6-20160331-draft.pdf
* http://iphome.hhi.de/wiegand/assets/pdfs/2012_12_IEEE-HEVC-Overview.pdf
* https://medium.com/@mbebenita/av1-bitstream-analyzer-d25f1c27072b#.d5a89oxz8
* https://arxiv.org/pdf/1702.00817v1.pdf
* https://people.xiph.org/~xiphmont/demo/daala/demo1.shtml
* https://people.xiph.org/~jm/daala/revisiting/
* https://people.xiph.org/~tterribe/pubs/lca2012/auckland/intro_to_video1.pdf
* https://xiph.org/video/vid1.shtml
* https://xiph.org/video/vid2.shtml
* http://www.itu.int/rec/T-REC-H.264-201610-I
* https://www.amazon.com/Understanding-Compression-Data-Modern-Developers/dp/1491961538/ref=sr_1_1?s=books&ie=UTF8&qid=1486395327&sr=1-1
* https://www.amazon.com/Practical-Guide-Video-Audio-Compression/dp/0240806301/ref=sr_1_3?s=books&ie=UTF8&qid=1486396914&sr=1-3&keywords=A+PRACTICAL+GUIDE+TO+VIDEO+AUDIO
* https://www.amazon.com/Video-Encoding-Numbers-Eliminate-Guesswork/dp/0998453005/ref=sr_1_1?s=books&ie=UTF8&qid=1486396940&sr=1-1&keywords=jan+ozer
* http://www.cambridgeincolour.com/tutorials/camera-sensors.htm
* https://en.wikipedia.org/wiki/Intra-frame_coding
* https://en.wikipedia.org/wiki/Inter_frame
* http://stackoverflow.com/questions/38094302/how-to-understand-header-of-h264
* http://gentlelogic.blogspot.com.br/2011/11/exploring-h264-part-2-h264-bitstream.html
* https://trac.ffmpeg.org/wiki/Encode/H.264
* http://www.itu.int/ITU-T/recommendations/rec.aspx?rec=12904&lang=en
* http://stackoverflow.com/a/24890903
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
* https://developer.apple.com/library/content/technotes/tn2224/_index.html
* http://www.lighterra.com/papers/videoencodingh264/
* http://www.slideshare.net/ManoharKuse/hevc-intra-coding
* http://www.slideshare.net/mwalendo/h264vs-hevc
* http://www.slideshare.net/rvarun7777/final-seminar-46117193
* http://x265.org/hevc-h265/
* http://www.compression.ru/video/codec_comparison/h264_2012/mpeg4_avc_h264_video_codecs_comparison.pdf
* http://vanseodesign.com/web-design/color-luminance/
* https://en.wikipedia.org/wiki/AOMedia_Video_1
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
* https://cardinalpeak.com/blog/the-h-264-sequence-parameter-set/
* https://cardinalpeak.com/blog/worlds-smallest-h-264-encoder/
* https://tools.ietf.org/html/draft-fuldseth-netvc-thor-03
* https://prezi.com/8m7thtvl4ywr/mp3-and-aac-explained/
* http://www.slideshare.net/MadhawaKasun/audio-compression-23398426
* http://techblog.netflix.com/2016/08/a-large-scale-comparison-of-x264-x265.html
* http://yumichan.net/video-processing/video-compression/introduction-to-h264-nal-unit/
* http://www.springer.com/cda/content/document/cda_downloaddocument/9783642147029-c1.pdf
* http://www.red.com/learn/red-101/video-chroma-subsampling
* http://www.streamingmedia.com/Articles/Editorial/Featured-Articles/A-Progress-Report-The-Alliance-for-Open-Media-and-the-AV1-Codec-110383.aspx
* http://www.explainthatstuff.com/digitalcameras.html
* https://www.youtube.com/watch?v=LWxu4rkZBLw
* http://www.csc.villanova.edu/~rschumey/csc4800/dct.html
* https://en.wikipedia.org/wiki/File:H.264_block_diagram_with_quality_score.jpg
* https://softwaredevelopmentperestroika.wordpress.com/2014/02/11/image-processing-with-python-numpy-scipy-image-convolution/
* http://stackoverflow.com/a/24890903
* http://www.hkvstar.com
* http://www.hometheatersound.com/
* http://web.ece.ucdavis.edu/cerl/ReliableJPEG/Cung/jpeg.html
* https://en.wikipedia.org/wiki/Pixel_aspect_ratio
