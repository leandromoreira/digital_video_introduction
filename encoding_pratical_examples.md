[![license](https://img.shields.io/badge/license-BSD--3--Clause-blue.svg)](https://img.shields.io/badge/license-BSD--3--Clause-blue.svg)

# Introduction

Please make sure you run `./setup.sh` first.

# General commands

## Inspect stream

To see some details:

```
./s/mediainfo /files/v/small_bunny_1080p_30fps.mp4
```

To see full details:

```
./s/mediainfo --Details /files/v/small_bunny_1080p_30fps.mp4
# I don't know why Details is not on man page
```

To see only the frame, slice types:

```
./s/mediainfo --Details /files/v/small_bunny_1080p_30fps.mp4 | grep slice_type
```
## Transmuxing

From `mp4` to `ts`:

```
./s/ffmpeg -i /files/v/small_bunny_1080p_30fps.mp4  /files/v/small_bunny_1080p_30fps.ts
```

From `mp4` to `ts` explicitly telling to copy audio and video codec:

```
./s/ffmpeg -i /files/v/small_bunny_1080p_30fps.mp4 -c:a copy -c:v copy  /files/v/small_bunny_1080p_30fps.ts
```

## Transcoding

From `h264` to `vp9`:

```
./s/ffmpeg -i /files/v/small_bunny_1080p_30fps.mp4 -c:v libvpx-vp9 -c:a libvorbis /files/v/small_bunny_1080p_30fps_vp9.webm
```

From `h264` to `h265`:

```
./s/ffmpeg -i /files/v/small_bunny_1080p_30fps.mp4 -c:v libx265 /files/v/small_bunny_1080p_30fps_h265.mp4
```

From `h264` to `h264` with I-frame at each second (for a 30FPS video):

```
./s/ffmpeg -i /files/v/small_bunny_1080p_30fps.mp4 -c:v libx264 -x264-params keyint=30:min-keyint=30:no-scenecut=1 -c:a copy /files/v/small_bunny_1080p_30fps_h264_keyframe_each_second.mp4
```

Count how many `I-slice` (keyframes) were inserted:

```
./s/mediainfo --Details /files/v/small_bunny_1080p_30fps_h264_keyframe_each_second.mp4 | grep "slice_type I" | wc -l
```

## Split and merge smoothly

To work with smaller videos you can split the whole video into segments and you can also merge then after.

```
# spliting into several likely 2s segments
./s/ffmpeg -fflags +genpts -i /files/v/small_bunny_1080p_30fps.mp4 -map 0 -c copy -f segment -segment_format mp4 -segment_time 2 -segment_list video.ffcat -reset_timestamps 1 -v error chunk-%03d.mp4

# joining them 
./s/ffmpeg -y -v error -i video.ffcat -map 0 -c copy output.mp4
```

## 1 I-Frames per second vs 0.5 I-Frames per second

From `h264` to `h264` with I-frame at each second (for a 30FPS video):

```
./s/ffmpeg -i /files/v/small_bunny_1080p_30fps.mp4 -c:v libx264 -x264-params keyint=30:min-keyint=30:no-scenecut=1 -c:a copy /files/v/small_bunny_1080p_30fps_h264_keyframe_each_one_second.mp4
```
From `h264` to `h264` with I-frame at each two seconds (for a 30FPS video):

```
./s/ffmpeg -i /files/v/small_bunny_1080p_30fps.mp4 -c:v libx264 -x264-params keyint=60:min-keyint=60:no-scenecut=1 -c:a copy /files/v/small_bunny_1080p_30fps_h264_keyframe_each_two_seconds.mp4
```

## 1 I-frame and the rest P-Frames

Generates a video with a `single I frame` and the `rest are P frames`.

```
./s/ffmpeg -i /files/v/small_bunny_1080p_30fps.mp4 -c:v libx264 -x264-params keyint=300:min-keyint=300:no-scenecut=1:bframes=0 -c:a copy /files/v/small_bunny_1080p_30fps_single_I_rest_P.mp4
```

You can check if that's true:

```
./s/mediainfo --Details /files/v/small_bunny_1080p_30fps_single_I_rest_P.mp4 | grep "slice_type I" | wc -l

./s/mediainfo --Details /files/v/small_bunny_1080p_30fps_single_I_rest_P.mp4 | grep "slice_type P" | wc -l

./s/mediainfo --Details /files/v/small_bunny_1080p_30fps_single_I_rest_P.mp4 | grep "slice_type B" | wc -l

```

## No B-frames at all

Generates a video with 0 B-frames.

```
./s/ffmpeg -i /files/v/small_bunny_1080p_30fps.mp4 -c:v libx264 -x264-params keyint=30:min-keyint=30:no-scenecut=1:bframes=0 -c:a copy /files/v/small_bunny_1080p_30fps_zero_b_frames.mp4
```

Check if that's right and also compare the size.

```
./s/mediainfo --Details /files/v/small_bunny_1080p_30fps_zero_b_frames.mp4 | grep "slice_type B" | wc -l

ls -lah v/
```

## CABAC vs CAVLC

Generates `h264` using CAVLC (faster, less cpu intensive, less compression):

```
./s/ffmpeg -i /files/v/small_bunny_1080p_30fps.mp4 -c:v libx264 -x264-params keyint=30:min-keyint=30:no-scenecut=1:no-cabac=1 -c:a copy /files/v/small_bunny_1080p_30fps_h264_keyframe_each_second_CAVLC.mp4
```

Generates `h264` using CABAC ("slower", more cpu intensive, more compression):

```
./s/ffmpeg -i /files/v/small_bunny_1080p_30fps.mp4 -c:v libx264 -x264-params keyint=30:min-keyint=30:no-scenecut=1:coder=1 -c:a copy /files/v/small_bunny_1080p_30fps_h264_keyframe_each_second_CABAC.mp4
```

## Transrating

CBR from `1928 kbps` to `964 kbps`:

```
./s/ffmpeg -i /files/v/small_bunny_1080p_30fps.mp4 -b:v 964K -minrate 964K -maxrate 964K -bufsize 2000K  /files/v/small_bunny_1080p_30fps_transrating_964.mp4
```

Constrained VBR or ABR from `1928 kbps` to `max=3856 kbps ,min=964 kbps`:

```
./s/ffmpeg -i /files/v/small_bunny_1080p_30fps.mp4 -minrate 964K -maxrate 3856K -bufsize 2000K  /files/v/small_bunny_1080p_30fps_transrating_964_3856.mp4
```

## Transsizing

From `1080p` to `480p`:

```
./s/ffmpeg -i /files/v/small_bunny_1080p_30fps.mp4 -vf scale=480:-1 /files/v/small_bunny_1080p_30fps_transsizing_480.mp4
```

## Demuxing

Extracting `audio` from `container`:

```
./s/ffmpeg -i /files/v/small_bunny_1080p_30fps.mp4 -vn -c:a copy /files/v/small_bunny_audio.aac
```

## Muxing

Joining `audio` with `video`:

```
./s/ffmpeg -i /files/v/small_bunny_audio.aac -i /files/v/small_bunny_1080p_30fps.mp4 /files/v/small_bunny_1080p_30fps_muxed.mp4
```

## Generates YUV histogram

It generates a video with color histogram as an overlay.
```
./s/ffmpeg -i /files/v/small_bunny_1080p_30fps.mp4 -vf "split=2[a][b],[b]histogram,format=yuv420p[hh],[a][hh]overlay" /files/v/small_bunny_yuv_histogram.mp4
```

## Generate debug video

It generates a video with macro blocks debug over the video. Please refer to https://trac.ffmpeg.org/wiki/Debug/MacroblocksAndMotionVectors to understand the meaning of each block color.
```
./s/ffmpeg -debug vis_mb_type -i /files/v/small_bunny_1080p_30fps.mp4 /files/v/small_bunny_1080p_30fps_vis_mb.mp4
```

It generates a video with motion vector over the video.
```
./s/ffmpeg -flags2 +export_mvs -i /files/v/small_bunny_1080p_30fps.mp4 -vf codecview=mv=pf+bf+bb /files/v/small_bunny_1080p_30fps_vis_mv.mp4
```

## Generate images from video

Get `images` from `1s video`:

```
./s/ffmpeg -y -i /files/v/bunny_1080p_30fps.mp4 -ss 00:01:24 -t 00:00:01  /files/v/smallest_bunny_1080p_30fps_%3d.jpg
```

## Generate video from images

```
# from one image
./s/ffmpeg -loop 1 -i /files/v/smallest_bunny_1080p_30fps_001.jpg -c:v libx264 -pix_fmt yuv420p -t 10 /files/v/smallest_bunny_1080p_30fps_frame_001.mp4

# from multiple images (repeating 10s)
./s/ffmpeg -loop 1 -i /files/v/smallest_bunny_1080p_30fps_%03d.jpg -c:v libx264 -pix_fmt yuv420p -t 10 /files/v/smallest_bunny_1080p_30fps_from_images.mp4
```

## Generate a single frame video

It generates a single frame video which is great for learning and analysis.

```
./s/ffmpeg -i /files/i/minimal.png -pix_fmt yuv420p /files/v/minimal_yuv420.mp4

./s/ffmpeg -i /files/i/minimal.png  /files/v/minimal_yuv444.mp4

# we can inspect h264 bitstream
./s/mediainfo --Details /files/v/minimal_yuv420.mp4  | less
```

## Generate a simple video

It generates a video from a sequence of images.

```
# 2 simple images with white background
./s/ffmpeg -i /files/i/solid_background_ball_%d.png -pix_fmt yuv420p /files/v/solid_background_ball_yuv420.mp4

# 4 simple images with background
./s/ffmpeg -i /files/i/smw_background_ball_%d.png -pix_fmt yuv420p /files/v/smw_background_ball_yuv420.mp4

# 4 white images as a video (great to test predicitons)

for i in {1..4}; do cp i/solid_background.png i/solid_background_$i.png; done
./s/ffmpeg -i /files/i/solid_background_%d.png -pix_fmt yuv420p /files/v/solid_background_yuv420.mp4
```

## Generate a single frame h264 bitstream

```
./s/ffmpeg -i /files/i/minimal.png -pix_fmt yuv420p /files/v/minimal_yuv420.h264

# you can check the raw h264 bit stream
hexdump  v/minimal_yuv420.h264
```

## Audio sampling

From `original` to `8kHz`:

```
./s/ffmpeg -i /files/v/small_bunny_1080p_30fps.mp4 -ar 8000 /files/v/small_bunny_1080p_30fps_8khz.mp4
```

## Audio bit depth

From `original` to `8 bits`:

```
./s/ffmpeg -i /files/v/small_bunny_1080p_30fps.mp4 -sample_fmt:0:1 u8p /files/v/small_bunny_1080p_30fps_8bits.mp4 -y
```

> Technically speaking, bit depth is only meaningful when applied to pure PCM devices. Non-PCM formats, such as lossy compression systems like MP3, have bit depths that are not defined in the same sense as PCM. In lossy audio compression, where bits are allocated to other types of information, the bits actually allocated to individual samples are allowed to fluctuate within the constraints imposed by the allocation algorithm.

## Adaptive bitrate streaming

[HLS](https://tools.ietf.org/html/draft-pantos-http-live-streaming-20) streaming:

### A VOD stream with 1s chunk size
```
./s/ffmpeg -i /files/v/small_bunny_1080p_30fps_h264_keyframe_each_second.mp4 -c:a copy -c:v libx264 -x264-params keyint=30:min-keyint=30:no-scenecut=1 -hls_playlist_type vod -hls_time 1 /files/v/playlist_keyframe_each_second.m3u8
```

### Playlists for 720p(2628kbs), 480p(480p1128kbs) and 240p(264kbs) streams

```
./s/ffmpeg -i /files/v/small_bunny_1080p_30fps_h264_keyframe_each_second.mp4 \
             -c:a copy -c:v libx264 -x264-params keyint=30:min-keyint=30:no-scenecut=1 \
             -b:v 2500k -s 1280x720 -profile:v high -hls_time 1 -hls_playlist_type vod /files/v/720p2628kbs.m3u8 \
             -c:a copy -c:v libx264 -x264-params keyint=30:min-keyint=30:no-scenecut=1 \
             -b:v 1000k -s 854x480 -profile:v high -hls_time 1 -hls_playlist_type vod /files/v/480p1128kbs.m3u8 \
             -c:a copy -c:v libx264 -x264-params keyint=30:min-keyint=30:no-scenecut=1 \
             -b:v 200k -s 426x240 -profile:v high -hls_time 1 -hls_playlist_type vod /files/v/240p264kbs.m3u8
```

### The variant playlist
```
cat <<EOF > v/variant.m3u8
#EXTM3U
#EXT-X-VERSION:6
#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=2500000,CODECS="avc1.640028,mp4a.40.2",RESOLUTION=1280x720
720p2628kbs.m3u8
#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=1000000,CODECS="avc1.4d001f,mp4a.40.2",RESOLUTION=854x480
480p1128kbs.m3u8
#EXT-X-STREAM-INF:PROGRAM-ID=1,BANDWIDTH=200000,CODECS="avc1.42001f,mp4a.40.2",RESOLUTION=426x240
240p264kbs.m3u8
EOF
```

## Video quality perception

You can learn more about [vmaf](http://techblog.netflix.com/2016/06/toward-practical-perceptual-video.html) and [general video quality perception](https://leandromoreira.com.br/2016/10/09/how-to-measure-video-quality-perception/).

```
# generating a 2 seconds example video
./s/ffmpeg -y -i /files/v/bunny_1080p_30fps.mp4 -ss 00:01:24 -t 00:00:02  /files/v/smallest_bunny_1080p_30fps.mp4

# generate a transcoded video (600kbps vp9)
./s/ffmpeg -i /files/v/smallest_bunny_1080p_30fps.mp4 -c:v libvpx-vp9 -b:v 600K -c:a libvorbis /files/v/smallest_bunny_1080p_30fps_vp9.webm

# extract the yuv (yuv420p) color space from them
./s/ffmpeg -i /files/v/smallest_bunny_1080p_30fps.mp4 -c:v rawvideo -pix_fmt yuv420p /files/v/smallest_bunny_1080p_30fps.yuv
./s/ffmpeg -i /files/v/smallest_bunny_1080p_30fps_vp9.webm -c:v rawvideo -pix_fmt yuv420p /files/v/smallest_bunny_1080p_30fps_vp9.yuv

# run vmaf original h264 vs transcoded vp9
./s/vmaf run_vmaf yuv420p 1080 720 /files/v/smallest_bunny_1080p_30fps.yuv /files/v/smallest_bunny_1080p_30fps_vp9.yuv --out-fmt json
```

## FFMpeg as a library

There are some documentations, examples and tutorials:

* http://dranger.com/ffmpeg/tutorial01.html
* https://github.com/leandromoreira/player-ffmpeg
* https://github.com/FFmpeg/FFmpeg/tree/master/doc/examples
* https://www.ffmpeg.org/doxygen/3.2/index.html
