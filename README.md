[![license](https://img.shields.io/badge/license-BSD--3--Clause-blue.svg)](https://img.shields.io/badge/license-BSD--3--Clause-blue.svg)

# WIP

This repo will be used to provide a gentle introduction to video technology, although it's aimed to software developers / engineering we want to make it easy for anyone to learn.

The idea is to introduce some video subjects with easy to understand text (at least for developers), visual element and practical examples where is possible. Also, feel free to send PRs.

# Basic video/image terminology

An **image** can be thought as a **2D matrix** and if we think about **colors**, we can extrapolate this idea seeing this image as a **3D matrix** where the **additional dimensions** are used to provide **color info**.

If we chose to represent these colors using the [primary colors (red, green and blue)](https://en.wikipedia.org/wiki/Primary_color), we then can define the tree planes: the first one **red**, the second **green** and the last the **blue** color.

![an image is a 3d matrix RGB](/i/image_3d_matrix_rgb.png "An image is a 3D matrix")

Each point in this matrix, we'll call it **a pixel** (picture element), will hold the **intensity** (usually a numeric value) of that given color. A **total red color** means 0 of green, 0 of blue and max of red, the **pink color** can be formed with (using 0 to 255 as the possible range) with **Red=255, Green=192 and Blue=203**.

> #### Other ways to encode a color image
> There are much more models to represent an image with colors. We could use a indexed palette where we'd spend only a byte for each pixel instead of 3, comparing it to RGB model. In this model instead of a 3D matrix we'd use a 2D matrix, saving memory but having much less color options.
> ![NES palette](/i/nes-color-palette.png "NES palette")

For instance, look at the first Super Mario's picture down bellow, you can see that it has a lots of red and few blue colors therefore the **red color** will be the one that **contributes more** (the brightest parts) to the final color while the **blue color** contribution can be mostly **only seen in Mario's eyes** and part of his clothes.

![RGB channels intensity](/i/rgb_channels_intensity.png "RGB channels intensity")

And each color intensity requires a certain amount of bits, this quantity is know as **bit depth**. Let's say we spend **8 bits** (accepting values from 0 to 255) per color (plane), therefore we have a **color depth** of **24 (8 * 3) bits** and you can also infer that we could use 2 to the power of 24 different colors.

An image has also another property such as **resolution** which is the number of pixels in each dimension. It is often presented as width × height,  for example the **4×4** image bellow.

![image resolution](/i/resolution.png "image resolution")

> #### Play around with image and color
> You can [play around with image and colors](/image_as_3d_array.ipynb) using [jupyter](#how-to-use-jupyter) (python, numpy, matplotlib and etc).

Another property we can see while working with images or video is **aspect ratio** which is simple describes the proportional relationship between width and height of an image or pixel.

When people says this movie or picture is **16x9** they usually are referring to the **Display Aspect Ratio (DAR)** and we also can have different shapes of a pixel, we call this **Pixel Aspect Ratio**.

![display aspect ratio](/i/DAR.png "display aspect ratio")

![pixel aspect ratio](/i/PAR.png "pixel aspect ratio")

Finally we can define a **video** as a succession of *N* frames, being its frame rate or frames per second(FPS).

![video](/i/video.png "video")


# How to use jupyter

Make sure you have **docker installed** and just run `./s/start_jupyter.sh` and follow the instructions on the terminal.

# References

* https://www.coursera.org/learn/digital/
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
* https://storage.googleapis.com/downloads.webmproject.org/docs/vp9/vp9-bitstream-specification-v0.6-20160331-draft.pdf
* https://en.wikipedia.org/wiki/AOMedia_Video_1
* http://www.hkvstar.com
* http://www.hometheatersound.com/
* https://www.vcodex.com/h264avc-intra-precition/
* http://bbb3d.renderfarming.net/download.html
* http://www.slideshare.net/vcodex/a-short-history-of-video-coding
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
* http://stackoverflow.com/a/24890903
* https://xiph.org/video/vid1.shtml
* https://xiph.org/video/vid2.shtml
* http://web.ece.ucdavis.edu/cerl/ReliableJPEG/Cung/jpeg.html
* https://en.wikipedia.org/wiki/Pixel_aspect_ratio
* https://www.coursera.org/learn/digital/
