[![license](https://img.shields.io/badge/license-BSD--3--Clause-blue.svg)](https://img.shields.io/badge/license-BSD--3--Clause-blue.svg)

# Introduction

Please make sure you run `./setup.sh` first.

# General commands

## Inspect stream

To see some details:

```
./s/mediainfo.sh /files/v/small_bunny_1080p_30fps.mp4
```

To see full details:

```
./s/mediainfo.sh --Details=1 /files/v/small_bunny_1080p_30fps.mp4
```

To see only the frame, slice types:

```
./s/mediainfo.sh --Details=1 /files/v/small_bunny_1080p_30fps.mp4 | grep slice_type
```
## Transmuxing

From `mp4` to `ts`:

```
./s/ffmpeg.sh -i /files/v/small_bunny_1080p_30fps.mp4  /files/v/small_bunny_1080p_30fps.ts
```

From `mp4` to `ts` explicitly telling to copy audio and video codec:

```
./s/ffmpeg.sh -i /files/v/small_bunny_1080p_30fps.mp4 -c:a copy -c:v copy  /files/v/small_bunny_1080p_30fps.ts
```

## Transcoding

From `h264` to `vp9`:

```
./s/ffmpeg.sh -i /files/v/small_bunny_1080p_30fps.mp4 -c:v libvpx-vp9 -c:a libvorbis /files/v/small_bunny_1080p_30fps_vp9.webm
```

From `h264` to `h265`:

```
./s/ffmpeg.sh -i /files/v/small_bunny_1080p_30fps.mp4 -c:v libx265 /files/v/small_bunny_1080p_30fps_h265.mp4
```

From `h264` to `h264` with I-frame at each second (for a 30FPS video):

```
./s/ffmpeg.sh -i /files/v/small_bunny_1080p_30fps.mp4 -c:v libx264 -x264-params keyint=30:min-keyint=30:no-scenecut=1 -c:a copy /files/v/small_bunny_1080p_30fps_h264_keyframe_each_second.mp4
```

Count how many `I-slice` (keyframes) were inserted:

```
./s/mediainfo.sh --Details=1 /files/v/small_bunny_1080p_30fps_h264_keyframe_each_second.mp4 | grep "slice_type I" | wc -l
```

## Transrating

CBR from `1928 kbps` to `964 kbps`:

```
./s/ffmpeg.sh -i /files/v/small_bunny_1080p_30fps.mp4 -b:v 964K -minrate 964K -maxrate 964K -bufsize 2000K  /files/v/small_bunny_1080p_30fps_transrating_964.mp4
```

Constrained VBR or ABR from `1928 kbps` to `max=3856 kbps ,min=964 kbps`:

```
./s/ffmpeg.sh -i /files/v/small_bunny_1080p_30fps.mp4 -minrate 964K -maxrate 3856K -bufsize 2000K  /files/v/small_bunny_1080p_30fps_transrating_964_3856.mp4
```

## Transsizing

From `1080p` to `480p`:

```
./s/ffmpeg.sh -i /files/v/small_bunny_1080p_30fps.mp4 -vf scale=480:-1 /files/v/small_bunny_1080p_30fps_transsizing_480.mp4
```

## Adaptive bitrate streaming

[HLS](https://tools.ietf.org/html/draft-pantos-http-live-streaming-20) streaming:

### A VOD stream with 1s chunk size
```
./s/ffmpeg.sh -i /files/v/small_bunny_1080p_30fps_h264_keyframe_each_second.mp4 -c:a copy -c:v libx264 -x264-params keyint=30:min-keyint=30:no-scenecut=1 -hls_playlist_type vod -hls_time 1 /files/v/playlist_keyframe_each_second.m3u8
```

### Playlists for 720p(2628kbs), 480p(480p1128kbs) and 240p(264kbs) streams

```
./s/ffmpeg.sh -i /files/v/small_bunny_1080p_30fps_h264_keyframe_each_second.mp4 \
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
