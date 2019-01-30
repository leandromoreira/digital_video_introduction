[![license](https://img.shields.io/badge/license-BSD--3--Clause-blue.svg)](https://img.shields.io/badge/license-BSD--3--Clause-blue.svg)

# Intro

비디오 기술에 대한 친절한 소개 자료입니다. 비록 소프트웨어 개발자/엔지니어를 대상으로 작성 했지만, **누구나 배울 수 있는** 글이 되었으면 합니다. 아이디어는 [비디오 기술 뉴비를 위한 미니 워크샵](https://docs.google.com/presentation/d/17Z31kEkl_NGJ0M66reqr9_uTG6tI5EDDVXpdPKVuIrs/edit#slide=id.p)에서 비롯되었습니다.

가능한 **쉬운 단어, 많은 시각 자료 그리고 실용적인 예제**들로 디지털 비디오의 컨셉을 소개하며 어디서든 사용할 수 있는 지식이 될 수 있는 것이 목표입니다. 언제나 수정 사항, 제안 등을 보내셔서 개선해주세요.

**실습** 섹션에서는 **도커**가 필요하며 이 레포지토리를 클론하셔야 합니다.


```bash
git clone https://github.com/leandromoreira/digital_video_introduction.git
cd digital_video_introduction
./setup.sh
```

> **알림**: `./s/ffmpeg`나 `./s/mediainfo` 명령을 사용하는 경우,필요로 하는 모든 요구사항이 포함된 **도커 앱**을 실행하는 것을 의미합니다.

All the **hands-on should be performed from the folder you cloned** this repository. For the **jupyter examples** you must start the server `./s/start_jupyter.sh` and copy the URL and use it in your browser.

**모든 실습 내용은 여러분이 클론한 레포지토리 폴더에서 실행되어야 합니다**.  
**주피터 예제**의 경우, `./s/start_jupyter.sh`로 서버를 반드시 실행해야하며 URL을 복사해 브라우저에서 사용하시면 됩니다.

# 변경로그

* DRM 시스템이 추가되었습니다.
* 1.0.0 버전이 릴리즈 되었습니다.
* 요약 버전의 중국어 번역이 추가되었습니다.

# 색인

- [Intro](#intro)
- [변경로그](#%EB%B3%80%EA%B2%BD%EB%A1%9C%EA%B7%B8)
- [색인](#%EC%83%89%EC%9D%B8)
- [기초 용어](#%EA%B8%B0%EC%B4%88-%EC%9A%A9%EC%96%B4)
- [중복 제거](#%EC%A4%91%EB%B3%B5-%EC%A0%9C%EA%B1%B0)
  - [색상, 휘도, 시각](#%EC%83%89%EC%83%81-%ED%9C%98%EB%8F%84-%EC%8B%9C%EA%B0%81)
    - [색상 모델](#%EC%83%89%EC%83%81-%EB%AA%A8%EB%8D%B8)
    - [YCbCr <-> RGB 변환](#ycbcr---rgb-%EB%B3%80%ED%99%98)
    - [크로마 서브샘플링](#%ED%81%AC%EB%A1%9C%EB%A7%88-%EC%84%9C%EB%B8%8C%EC%83%98%ED%94%8C%EB%A7%81)
  - [프레임 유형](#%ED%94%84%EB%A0%88%EC%9E%84-%EC%9C%A0%ED%98%95)
    - [I Frame (인트라, 키프레임)](#i-frame-%EC%9D%B8%ED%8A%B8%EB%9D%BC-%ED%82%A4%ED%94%84%EB%A0%88%EC%9E%84)
    - [P Frame (predicted)](#p-frame-predicted)
    - [B Frame (bi-predictive)](#b-frame-bi-predictive)
    - [요약](#%EC%9A%94%EC%95%BD)
  - [시간적 중복 (인터 프리딕션)](#%EC%8B%9C%EA%B0%84%EC%A0%81-%EC%A4%91%EB%B3%B5-%EC%9D%B8%ED%84%B0-%ED%94%84%EB%A6%AC%EB%94%95%EC%85%98)
  - [공간적 중복 (인트라 프리딕션)](#%EA%B3%B5%EA%B0%84%EC%A0%81-%EC%A4%91%EB%B3%B5-%EC%9D%B8%ED%8A%B8%EB%9D%BC-%ED%94%84%EB%A6%AC%EB%94%95%EC%85%98)
- [코덱은 어떻게 동작할까요?](#%EC%BD%94%EB%8D%B1%EC%9D%80-%EC%96%B4%EB%96%BB%EA%B2%8C-%EB%8F%99%EC%9E%91%ED%95%A0%EA%B9%8C%EC%9A%94)
  - [무엇을? 왜? 어떻게?](#%EB%AC%B4%EC%97%87%EC%9D%84-%EC%99%9C-%EC%96%B4%EB%96%BB%EA%B2%8C)
  - [History](#history)
  - [A generic codec](#a-generic-codec)
  - [1st step - picture partitioning](#1st-step---picture-partitioning)
  - [2nd step - predictions](#2nd-step---predictions)
  - [3rd step - transform](#3rd-step---transform)
  - [4th step - quantization](#4th-step---quantization)
  - [5th step - entropy coding](#5th-step---entropy-coding)
    - [VLC coding:](#vlc-coding)
    - [Arithmetic coding:](#arithmetic-coding)
  - [6th step - bitstream format](#6th-step---bitstream-format)
    - [H.264 bitstream](#h264-bitstream)
  - [Review](#review)
  - [How does H.265 achieve a better compression ratio than H.264?](#how-does-h265-achieve-a-better-compression-ratio-than-h264)
- [Online streaming](#online-streaming)
  - [General architecture](#general-architecture)
  - [Progressive download and adaptive streaming](#progressive-download-and-adaptive-streaming)
  - [Content protection](#content-protection)
    - [DRM](#drm)
      - [Main systems](#main-systems)
      - [What?](#what)
      - [Why?](#why)
      - [How?](#how)
- [How to use jupyter](#how-to-use-jupyter)
- [Conferences](#conferences)
- [References](#references)

# 기초 용어

**이미지**는 2차원 매트릭스로 생각할 수 있습니다. 여기에 **색상**을 고려한다면, **색상 데이터** 제공에 사용되는 **추가적인 차원**이 있는 **3차원 매트릭스**로 여길 수 있습니다.

[삼원색(빨간색, 초록색, 파란색)](https://en.wikipedia.org/wiki/Primary_color)을 사용해 색상들을 표현하는 경우, **빨간색**, **초록색**, **파란색** 순의 세 가지 평면을 정의할 수 있습니다.  

![an image is a 3d matrix RGB](/i/image_3d_matrix_rgb.png "An image is a 3D matrix")

이 매트릭스의 각각의 점을 **픽셀**(화소)라 부를 것입니다. 하나의 픽셀은 주어진 색상의 **강도**(보통 숫자 값)를 표현합니다. 예를들어, **빨간 픽셀**은 초록생이 0, 파란색이 0이고 빨간색이 최대인 것을 의미하지요. **핑크 색상 픽셀**은 세 가지 색상의 조합으로 구성되어 있습니다. 대표적인 0부터 255까지의 숫자 범위를 사용하면 핑크색 픽셀은 **빨간색=255, 초록색=192, 파란색=203**으로 정의됩니다.  

> #### 색상 이미지를 인코딩하는 또 다른 방법
> 이미지를 구성하는 색상들을 표현하는데에는 다양한 모델들이 존재합니다. 예를들면 RGB 모델을 사용할 때 3바이트를 사용하는 것 대신, 각 픽셀을 표현하는데 한 바이트만 필요한 인덱스 팔레트를 사용할 수 있지요. 이러한 모델에서는 3차원 매트릭스 대신 2차원 매트릭스를 사용하여 색상을 표현할 수 있으며, 메모리를 아낄 수 있지만 색상에 대한 몇 가지 옵션들을 포기해야하죠.   
>
> ![NES palette](/i/nes-color-palette.png "NES palette")

예를들어 아래의 사진을 한 번 보세요. 첫 번째 얼굴은 모든 색상이 표현되어있지요. 다른 것들은 빨간색, 초록색, 파란색 평면입니다. (회색 톤으로 나옴)

![RGB channels intensity](/i/rgb_channels_intensity.png "RGB channels intensity")

여기서 **빨간색**(두 번째 얼굴의 밝은 부분들)이 색상에 많이 나타나는 것을 볼 수 있습니다. 반면 **파란색**(마지막 얼굴)은 대부분 **마리오의 눈**과 옷의 일부에만 나타납니다. **모든 색상**의 영향력이 낮은 부분은 **마리오의 수염**(가장 어두운 부분)입니다. 

각각의 색상 강도는 특정한 양의 비트를 필요로 합니다. 여기서 양이란 **비트 깊이** 입니다. 각 색상 평면당 8비트(0부터 255 사이의 값을 가지는)를 할애했다고 가정하면 **24비트**의 **색 깊이**(8 비트 * R/G/B의 3가지 평면)를 가지게 되며, 2의 24승 가지의 서로 다른 색상을 사용할 수 있음을 의미합니다.   

> [세상에서 비트로 이미지가 캡쳐되는 원리](http://www.cambridgeincolour.com/tutorials/camera-sensors.htm)에 대해 배울 수 있는 **훌륭한 글** 입니다.

이미지의 또 다른 속성은 **해상도**입니다. 해상도는 차원 하나에 포함될 수 있는 픽셀의 수를 의미합니다. 이는 보통 width x height로 표현됩니다. 그 예로 아래에는 **4x4** 이미지가 있습니다.  

![image resolution](/i/resolution.png "image resolution")

> #### 실습: 이미지와 색상 가지고 놀기
> [주피터](#how-to-use-jupyter)를 사용하여 [이미지와 색 가지고 놀기](/image_as_3d_array.ipynb)를 해볼 수 있어요.
> 
>
> [이미지 필터(외곽선 검출, 강조, 블러)](/filters_are_easy.ipynb)에 대해 학습할 수 있습니다.

이미지나 비디오를 다루다보면 볼 수 있는 또 다른 속성인 **종횡비(aspect ratio)** 가 있습니다. 이는 이미지나 픽셀의 폭과 높이의 비례 관계를 간단하게 표현하는 방법입니다.  

사람들이 이 영상 혹은 사진은 **16x9**야라고 한다면 이는 일반적으로 **화면 종횡비(DAR)** 에 대한 이야기를 하는 것입니다. 반면에 각각의 픽셀의 서로 다른 형태에 대한 것은 **픽셀 종횡비(PAR)** 라고 부릅니다.  

![display aspect ratio](/i/DAR.png "display aspect ratio")

![pixel aspect ratio](/i/PAR.png "pixel aspect ratio")

> #### DVD는 DAR 4:3이다.
> DVD의 실제 해상도는 704x480이지만 10:11(704x10/480x11)의 PAR로 인해 4:3의 종횡비를 유지합니다.  

마지막으로 **비디오**는 또다른 차원으로 볼 수 있는 시간의 축에 나열된 **n개의 프레임의 연속**으로 정의할 수 있습니다.  
여기서 n은 프레임레이트 혹은 초당 프레임 수 입니다.  

![video](/i/video.png "video")

비디오의 **비트 레이트**는 동영상을 표시하는데 초당 필요한 비트의 수입니다.

> 비트레이트 = 폭 * 높이 * 비트 깊이 * 초당 프레임 수

예를들어 어떤 영상이 30fps, 24비트 픽셀 깊이, 480x240의 해상도에 압축을 하지 않은 경우라면 **초당 82,944,000비트** 혹은 82.944 Mbps (30x480x240x24)가 필요로 합니다.  

**비트 레이트**가 거의 일정한 경우 이를 고정 비트레이트(**CBR**)라고 부르며 가변의 경우에는 가변 비트레이트(**VBR**)라 부릅니다.  

> 이 그래프는 프레임이 검은색인 동안에는 그리 많은 비트를 소비하지 않는 제한된 VBR을 보여줍니다. 
>
> ![constrained vbr](/i/vbr.png "constrained vbr")

초기에는 엔지니어들이 **여분의 대역폭 소모 없이** 두 배의 인지 가능한 프레임 레이트로 비디오를 표시하는 기술을 개발했습니다. 이 기술은 **인터레이싱 비디오**라고 부릅니다. 이는 1프레임에서 화면의 절반을 보내고 나머지 절반을 그 다음 프레임에 보냅니다.  

오늘날의 화면은 대부분 **프로그레시브 스캔 기술**을 사용합니다. 프로그레시브는 각 프레임의 모든 라인을 순서대로 그리는 영상을 출력, 저장, 전송하는 기술입니다.  

![interlaced vs progressive](/i/interlaced_vs_progressive.png "interlaced vs progressive")

이제 어떻게 **이미지**가 디지털로 표현되는지, **색상**이 어떻게 배치되어 영상 표현에 어느 정도의 **초당 비트 수**가 필요한지, 그게 고정(CBR)인지 가변(VBR)인지에 대한 것과 **해상도**와 **프레임 레이트**와 인터레이스드, PAR와 같은 많은 용어들을 배웠습니다.   

> #### 연습: 비디오 속성 확인
> [ffmpeg이나 mediainfo로 속성 살펴보기](https://github.com/leandromoreira/introduction_video_technology/blob/master/encoding_pratical_examples.md#inspect-stream)

# 중복 제거

압축 없이는 비디오를 사용할 수 없다는 것을 배웠습니다. 30fps인 720p 해상도의 **한 시간 짜리 영상**은 **278GB***를 필요로합니다. DEFLATE(PKZIP, Gzip, PNG에 사용되는)와 같은 **무손실 데이터 압축 알고리즘**을 사용하는 경우 대역폭을 충분히 줄일 수 없으므로 비디오를 압축할 다른 방법을 찾아야합니다.  

> <sup>*</sup> 1280 x 720 x 24 x 30 x 3600 (폭, 높이, 픽셀 당 비트 수, fps, 영상 시간)

이를 위해서는, **우리의 눈을 속여야합니다**. 눈은 색상보다 명암 구분을 더 잘합니다. 영상은 변화가 거의 없는 많은 이미지들로 이루어져있으며, 각 프레임들은 같거나 유사한 색상을 사용하는 많은 영역들이 포함되어 있습니다.  

## 색상, 휘도, 시각

시각은 [색상보다 명암에 더 민감하며](http://vanseodesign.com/web-design/color-luminance/), 이를 테스트 해볼 수 있습니다. 이 사진을 보세요.  

![luminance vs color](/i/luminance_vs_color.png "luminance vs color")

만일 왼쪽의 이미지에서 사각형 **A와 B가 동일한 색상**이라는 사실을 눈치채지 못하셨다면 정상입니다. 우리의 뇌는 **색상보다는 명암에 더 신경쓰도록** 만들기 때문이지요. 오른쪽의 사진에서는 같은 색상을 연결해주는 커넥터가 있기 때문에 우리의 뇌는 두 사각형이 동일한 색상이라는 사실을 쉽게 파악할 수 있습니다.  

> **시각은 어떻게 동작하는가에 대한 간단한 설명**  
> 
> [눈은 복잡한 장기이며](http://www.biologymad.com/nervoussystem/eyenotes.htm), 많은 것들로 구성되어 있으나 여기서는 대부분은 원추세포와 간상세포에 집중합니다. 눈은 [약 1억 2천개의 간상세포와 6백만개의 원추세포로 구성되어 있습니다](https://en.wikipedia.org/wiki/Photoreceptor_cell).
> **더 간단하게 설명하기 위해**, 색상과 명암을 눈의 각 기능들에 입력한다고 가정해봅시다.
> **[간상세포](https://en.wikipedia.org/wiki/Rod_cell) 는 대부분 빛에 반응하는 반면에**, **[원추세포](https://en.wikipedia.org/wiki/Cone_cell)는 색상에 반응합니다**. 서로 다른 색소를 지닌 세 가지 타입의 원추 세포가 존재합니다: [S-cones (파란색), M-cones (초록색) and L-cones (빨간색)](https://upload.wikimedia.org/wikipedia/commons/1/1e/Cones_SMJ2_E.svg).
>
> 간상 세포(명암)가 원추 세포(색상)보다 많기 때문에, 색상보다 명암을 더 잘 구분할 것이라는 사실을 짐작할 수 있을 것입니다.  
>
> ![eyes composition](/i/eyes.jpg "eyes composition")
>
> **대비 인식 능력**
>
> 실험 심리학 및 다른 분야들의 연구자들은 사람의 시각에 대한 많은 이론을 개발했습니다. 그 중 하나를 대비 인식 능력이라고 부릅니다. 이것들은 빛의 공간과 시간과 관련 있으며, 주어진 초기에 관측한 빛이 나타내는 값이, 관측자가 변화가 있다는 사실을 말하기까지 얼마나 많은 변화가 필요한지에 대한 것입니다. `function`이 복수형으로 되어 있는데, 그 이유는 바로 대비 인식 능력은 명암 뿐만 아니라 색상도 관계되어 있기 때문입니다. 이 실험의 결과는 대부분의 경우에 우리의 눈이 색상보다 명암에 더 민감하다는 사실을 말해줍니다.  

이제 **루마**(이미지의 명도)에 더 민감하다는 사실을 알게되었으므로 이를 이용해볼 수 있습니다.  

### 색상 모델

초반에 배웠던 **RGB 모델**을 이용한 [이미지에 색상 지정하는 방법](#basic-terminology)외에도 다른 모델들도 있다는 것을 배웠습니다. 사실 모델 중 크로미넌스(색상)로부터 루마(명도)를 분리하는 모델이 있습니다. 이는 **YCbCr**<sup>*</sup>이라고도 알려져있습니다.

> <sup>*</sup> 이와 같은 방식을 사용하는 다른 모델들도 존재합니다.  

이 색상 모델은 명도를 표현하는 **Y**와 두 가지 색상 채널인 **Cb**(크로마 블루)와 **Cr**(크로마 레드)를 사용합니다. [YCbCr](https://en.wikipedia.org/wiki/YCbCr)은 RGB로부터 유도 가능하며, 또한 반대로 RGB로 역변환도 가능합니다. 이 모델을 사용하여 아래에 보이는 이미지와 같은 완전한 색상의 이미지를 만들 수 있습니다. 

![ycbcr example](/i/ycbcr.png "ycbcr example")

### YCbCr <-> RGB 변환

논쟁이 있을 수 있는데요, **어떻게 초록색을 사용하지 않고** 모든 색상을 표현할 수 있을까요?   

이 질문에 답하기 위해 RGB를 YCbCr로 변환하는 일을 같이 해봅시다. **[ITU-R 그룹<sup>*</sup>](https://en.wikipedia.org/wiki/ITU-R)** 에서 권장하는 **[표준 BT.601](https://en.wikipedia.org/wiki/Rec._601)** 계수를 사용할 것입니다. 첫 번째 단계는 **루마 계산**입니다. ITU에서 제안한 상수를 사용하고 RGB 값을 대체할 것입니다.


```
Y = 0.299R + 0.587G + 0.114B
```

루마를 얻었으니 이제 **색상 분리**(크로마 블루, 크로마 레드)를 할 수 있습니다:

```
Cb = 0.564(B - Y)
Cr = 0.713(R - Y)
```

또한 이를 **역변환** 가능하며 **YCbCr을 사용하여 초록색**을 얻을 수도 있습니다.  

```
R = Y + 1.402Cr
B = Y + 1.772Cb
G = Y - 0.344Cb - 0.714Cr
```

> <sup>*</sup> 무엇이 표준인지 정의합니다. 가령 [4K란 무엇인가? 어떤 프레임 레이트를 사용해야 하는가? 해상도는? 컬러 모델은?](https://en.wikipedia.org/wiki/Rec._2020)과 같은 것들입니다.  
일반적으로 **디스플레이**(모니터, TV, 스크린 등)는 **오직 RGB 모델**만 활용하며 이를 각자 다른 방식으로 배열합니다. 확대된 모습은 다음과 같습니다:  

![pixel geometry](/i/new_pixel_geometry.jpg "pixel geometry")

### 크로마 서브샘플링

루마와 크로마로 표현되는 이미지를 인간의 시각이 크로마보다 루마 해상도에 민감하다는 사실을 이용하여 선택적으로 정보를 제거하는데에 있어 이점을 취할 수 있습니다. **크로마 서브샘플링**은 **루마 대비 크로마 정보를 줄여** 이미지를 인코딩하는 기술입니다.  

![ycbcr subsampling resolutions](/i/ycbcr_subsampling_resolution.png "ycbcr subsampling resolutions")

얼마만큼의 크로마 해상도를 줄여야 하는 것일까요?! 이미 답은 나와 있습니다. 해상도와 병합(`final color = Y + Cb + Cr`)을 다루는 스키마가 이미 존재합니다.  

이러한 스키마는 서브 샘플링 시스템으로 알려져있으며 루마 픽셀의 `a x 2` 블록에 대한 크로마 해상도를 정의하는 3 부분의 비율 `a:x:y`로 정의됩니다.  

 * `a`는 수평 샘플링 레퍼런스입니다. (일반적으로 4)
 * `x`는 `a` 픽셀의 행(row)의 크로마 샘플 수입니다. (`a`에 대한 수평해상도)
 * `y`는 `a` 픽셀의 첫 번째와 두 번째 행 사이의 크로마 샘플의 변화에 대한 개수입니다.  

> 예외적으로 4:1:0은 각각의 루마 해상도의 `4 x 4`블록 내의 단일 크로마 샘플을 제공합니다.  

현대 코덱에 사용되는 보편적인 기법은 **4:4:4(서브 샘플링 없음)**, **4:2:2, 4:1:1, 4:2:0, 4:1:0 and 3:1:1**입니다.  

> **YCbCr 4:2:0 병합**
>
> 여기에 YCbCr 4:2:0을 사용한 이미지의 병합된 조각입니다. 픽셀 당 12 비트만 소모했을 뿐이라는 사실을 기억하세요. 
>
> ![YCbCr 4:2:0 merge](/i/ycbcr_420_merge.png "YCbCr 4:2:0 merge")

동일한 이미지에 대해 주요한 크로마 서브샘플링 타입들로 인코딩한 이미지를 보실 수 있을겁니다. 첫 번째 행의 이미지들은 최종 YCbCr 이미지이며 두 번째 열의 이미지들은 크로마 해상도를 나타냅니다. 적은 손실로 훌륭한 결과를 얻었습니다.  

![chroma subsampling examples](/i/chroma_subsampling_examples.jpg "chroma subsampling examples")

앞서 우리는 [한 시간 분량의 720p 해상도에 30fps인 영상을 저장하기 위해 278GB가 필요하다고 계산](#redundancy-removal)하였습니다. **YCbCr 4:2:0**을 사용하면 이를 **절반(139GB)의 크기**<sup>*</sup>로 줄일 수 있습니다. 하지만 아직 그리 이상적이진 않네요.  

> <sup>*</sup> 이 값은 width, height, 픽셀 당 비트 수 그리고 fps를 곱하여 얻었습니다. 이전에는 24비트가 필요했지만 이젠 12비트면 됩니다.  

<br/>

> ### 실습: YCbCr 히스토그램 확인하기
> [ffmpeg로 YCbCr 히스토그램을 확인할 수 있습니다.](/encoding_pratical_examples.md#generates-yuv-histogram) 이 장면은 [히스토그램](https://en.wikipedia.org/wiki/Histogram)에 보여지는 바와 같이 파란색 비율이 높습니다.  
>
> ![ycbcr color histogram](/i/yuv_histogram.png "ycbcr color histogram")

## 프레임 유형

이제 계속해서 **시간 상에서의 중복 제거**를 할 수도 있지만 그 전에 몇 가지 기본적인 용어를 정립해보겠습니다. 30fps의 영화가 있다고 가정해봅시다. 여기에 이 영화의 첫 번째부분의 4장의 프레임이 있습니다.  

![ball 1](/i/smw_background_ball_1.png "ball 1") ![ball 2](/i/smw_background_ball_2.png "ball 2") ![ball 3](/i/smw_background_ball_3.png "ball 3")
![ball 4](/i/smw_background_ball_4.png "ball 4")

**파란색 배경**과 같이 프레임 내에 **많은 중복**을 볼 수 있을겁니다. 프레임 0부터 3까지 변한게 없지요. 이 문제를 해결하기 위해 프레임을 세 가지 유형으로 **추상적으로 분류**할 수 있습니다.  

### I Frame (인트라, 키프레임)

`I-frame(레퍼런스, 키프레임, 인트라)`은 **자기 자신을 포함한 프레임**입니다. 렌더링 하기 위해 어떤 것에도 의존적이지 않지요. I-frame은 마치 정적인 사진같습니다. 첫 번째 프레임은 보통 I-frame입니다. 하지만 I-frame은 일반적으로 다른 유형의 프레임의 사이사이에 삽입된다는 사실을 볼 수 있을 겁니다.  

![ball 1](/i/smw_background_ball_1.png "ball 1")

### P Frame (predicted)

`P-frame`은 거의 항상 **이전의 프레임을 이용하여 렌더링 될 수 있다는 점**을 이점으로 취할 수 있습니다. 예를ㄷ를어 두 번째 프레임에서 변화라곤 공이 앞으로 움직인 것 뿐입니다. **변경된 부분을 사용해서 이 전의 프레임을 참고하여 프레임 1번을 다시 만들 수 있지요.**

![ball 1](/i/smw_background_ball_1.png "ball 1") <-  ![ball 2](/i/smw_background_ball_2_diff.png "ball 2")

> #### 실습: I-frame이 한장 뿐인 동영상
> P-frame이 데이터를 적게 사용하는데 왜 전체를 [I-frame 한장에 나머지 전부가 p-frame인 영상](/encoding_pratical_examples.md#1-i-frame-and-the-rest-p-frames)으로 인코딩하지 않을까요?
>
> 이 비디오를 인코딩하고 영상을 시작해서 비디오의 **앞부분으로 이동**해보면, 이동하는데 **시간이 좀 걸리는 사실**을 알게될겁니다. 왜냐하면 **P-frame은 렌더링하기 위해 레퍼런스 프레임(가령 I-frame)이 필요하기 때문**입니다.  
>
> 빨리 테스트 해볼 수 있는 다른 방법은 I-frame 한 장으로 비디오를 인코딩한 뒤, [2초 간격으로 I-frame을 삽입하여 인코딩한 뒤](/encoding_pratical_examples.md#1-i-frames-per-second-vs-05-i-frames-per-second) **각 렌디션의 사이즈를 확인해보세요.**

### B Frame (bi-predictive)

이전과 앞의 프레임을 참조하여 더 나은 압축률을 제공할 수 있다면?! 그것이 바로 B-Frame이라는 것입니다.

![ball 1](/i/smw_background_ball_1.png "ball 1") <-  ![ball 2](/i/smw_background_ball_2_diff.png "ball 2") -> ![ball 3](/i/smw_background_ball_3.png "ball 3")

> #### 실습: B-frame으로 비디오 비교하기
> 두 개의 렌디션을 생성해, 첫 번째에는 B-frame을 주고 다른 것에는 [B-frame을 주지 않고](/encoding_pratical_examples.md#no-b-frames-at-all) 퀄리티를 비롯하여 파일 사이즈도 확인을 해보세요.

### 요약

이러한 프레임들은 **더 나은 압축 성능을 제공**하는데 사용됩니다. 어떻게 이런 일이 가능한지 다음 섹션에서 알아볼 거에요. 하지만 여러분은 이제 **I-frame은 코스트가 높고 P-frame은 좀 더 낮고 B-frame이 제일 낮다는 사실**에 대해 생각할 수 있게 되었습니다.  

![frame types example](/i/frame_types.png "frame types example")

## 시간적 중복 (인터 프리딕션)

반드시 줄여야 하는 **시간 상에서의 반복**에 대해 알아봅시다. 이러한 중복의 유형은 **인터 프리딕션**이라는 기법을 활용해 해결할 수 있습니다.  

프레임 0과 1의 시퀀스를 **더 적은 비트를 활용해** 인코딩 해볼 것 입니다.  

![original frames](/i/original_frames.png "original frames")

One thing we can do it's a subtraction, we simply **subtract frame 1 from frame 0** and we get just what we need to **encode the residual**.

시도해 볼 수 있는 한 가지는 바로 제거입니다. 단순히 **프레임 0에서 프레임 1을 빼면** 오로지 **남은 부분만 인코딩**하면 됩니다.  

![delta frames](/i/difference_frames.png "delta frames")

하지만 이보다 더 적은 비트를 사용하는 **더 나은 방법**이 있다면 어떠시겠나요? 우선, `frame 0`을 잘 정의된 파티션의 집합으로 여기고, `frame 0`에 `frame 1`을 매칭시켜보세요. 이를 **모션 추정**으로 생각할 수 있지요.  

> ### 위키페디아 - 블록 모션 보정
> "**블록 모션 보정**은 현재 프레임을 겹치지 않은 블록으로 분할하고, 모션 보정 벡터가 **블록이 어디에서 왔는지 알려줍니다.** (일반적인 오개념으로 이전의 프레임이 겹치지 않은 블록으로 분할되어 있고, 모션 보정 벡터가 이 블록들이 어디로 이동할 지 알려주는 정보라고 여기는 것이 있습니다.) 원본 블록은 일반적으로 원본 프레임에 겹칩니다. 몇몇의 비디오 압축 알고리즘은 서로 다른 이전에 전송된 프레임의 일부 조각을 현재 프레임과 합칩니다."

![delta frames](/i/original_frames_motion_estimation.png "delta frames")

여기서 `x=0, y=25`에서 `x=6, y=26`으로 공이 움직였다고 추정할 수 있습니다. **x**와 **y**의 값들이 **모션 벡터**입니다. 비트를 절약할 수 있는 **추가적인 단계**로는 최종 블록의 위치와 예측되는 벡터의 **모션 벡터의 차이만 인코딩 하는 것**입니다. 따라서 최종적인 모션 벡터는 `x=6 (6-0), y=1 (26-25)`가 될 것입니다.  

> 현실 세계에서는 이 **공이 n개의 파티션으로 조각**나지만 과정은 동일합니다.  

프레임 상의 객체는 **3차원 상으로 움직이며**, 이 공이 배경으로 이동하는 경우에 더 작아질 수도 있습니다. 일치점을 찾으려 했던 블록과 **완전히 일치하는 것을 찾을 수 없는 일은** 일반적이지요.  

![motion estimation](/i/motion_estimation.png "motion estimation")

그럼에도 **모션 추정**을 적용하는 것이 단순히 델타 프레임 기법을 사용하는 것 보다 **인코딩 할 데이터가 더 적다는** 사실입니다.

![motion estimation vs delta ](/i/comparison_delta_vs_motion_estimation.png "motion estimation delta")

> ### 모션 보정은 실제로 어떻게 보이는가
> 이 기법은 모든 블록에 대해 적용되며, 공이 매우 빈번하게 하나 이상의 블록에서 분할됩니다.
>  ![real world motion compensation](/i/real_world_motion_compensation.png "real world motion compensation")
> Source: https://web.stanford.edu/class/ee398a/handouts/lectures/EE398a_MotionEstimation_2012.pdf

[주피터를 활용하여 이러한 기법들을 실험해볼 수 있습니다](/frame_difference_vs_motion_estimation_plus_residual.ipynb).

> #### Hands-on: See the motion vectors
> We can [generate a video with the inter prediction (motion vectors)  with ffmpeg.](/encoding_pratical_examples.md#generate-debug-video)
>
> ![inter prediction (motion vectors) with ffmpeg](/i/motion_vectors_ffmpeg.png "inter prediction (motion vectors) with ffmpeg")
>
> Or we can use the [Intel Video Pro Analyzer](https://software.intel.com/en-us/intel-video-pro-analyzer) (which is paid but there is a free trial version which limits you to only the first 10 frames).
>
> ![inter prediction intel video pro analyzer](/i/inter_prediction_intel_video_pro_analyzer.png "inter prediction intel video pro analyzer")

## 공간적 중복 (인트라 프리딕션)

영상의 **각각의 프레임을** 분석해보면 **많은 영역이 연관되어 있다는 사실**을 발견할 수 있을겁니다.  

![](/i/repetitions_in_space.png)

예제를 살펴보죠. 이 장면은 대부분 파란색과 하얀색으로 구성되어 있습니다.  

![](/i/smw_bg.png)

이는 `I-frame`이며 **이전의 프레임을 사용하여** 예측할 수는 없지만, 여전히 압축할 여지는 남아 있지요. **빨간 블록 부분을** 인코딩해볼거에요. **인접한 부분을 살펴보면**, **블록 주변의 색상의 경향을 추산**할 수 있습니다.  

![](/i/smw_bg_block.png)

프레임이 계속하여 **수직으로 색상이 확산될 것**이라고 예측할 것입니다. 이 의미는 **블록의 인접한 값을 알 수 없는 픽셀의** 색상이 지니고 있다는 것이지요.  

![](/i/smw_bg_prediction.png)

**예측이 틀렸을 수도 있습니다.** 그 이유는 바로 이 기법(**인트라 프리딕션**)을 적용한 뒤 잔여 블록을 반환하는 **실제 값을 빼야할** 필요가 있기 때문에, 원본과 비교했을 때 훨씬 더 압축률이 높은 행렬이 생성됩니다.  

![](/i/smw_residual.png)

> #### 실습: 인트라 프리딕션 확인해보기
> [매크로 블록과 프리딕션을 사용해 ffmpeg로 영상을 생성할 수 있습니다.](/encoding_pratical_examples.md#generate-debug-video) [각 블록의 색상의 의미](https://trac.ffmpeg.org/wiki/Debug/MacroblocksAndMotionVectors#AnalyzingMacroblockTypes)를 ffmpeg 문서를 확인해 이해해보세요.  
> 
> ![intra prediction (macro blocks) with ffmpeg](/i/macro_blocks_ffmpeg.png "inter prediction (motion vectors) with ffmpeg")
>
> 혹은 [Intel Video Pro Analyzer](https://software.intel.com/en-us/intel-video-pro-analyzer)(유료지만 처음 10 프레임 제한이 걸려 있는 무료 트라이얼 버전도 있습니다)를 사용해보세요.
>
> ![intra prediction intel video pro analyzer](/i/intra_prediction_intel_video_pro_analyzer.png "intra prediction intel video pro analyzer")

# 코덱은 어떻게 동작할까요?

## 무엇을? 왜? 어떻게?

**무엇을?** 코덱은 디지털 비디오를 압축 혹은 해제하는 소프트웨어/하드웨어 입니다. **왜?** 시장과 사회는 제한적인 대역폭과 스토리지를 활용한 높은 퀄리티의 영상을 필요로 합니다. 30fps, 픽셀당 24비트, 480x240 해상도의 비디오에 [필요한 대역폭 계산](#%EA%B8%B0%EC%B4%88-%EC%9A%A9%EC%96%B4)을 떠올려보세요. 압축을 하지 않은 경우 **82.944 Mbps**였지요. TV와 인터넷에서 HD/FullHD/4K를 전송할 유일한 방법입니다. **어떻게?** 여기서는 주요 기법들에 대해 간략히 살펴볼 것입니다.  

> **코덱 vs 컨테이너**
> 
> 초심자들이 흔히 범하는 실수 중 하나로 디지털 비디오 코덱과 [디지털 비디오 컨테이너](https://en.wikipedia.org/wiki/Digital_container_format)를 혼동하는 것입니다. **컨테이너**를 비디오의 메타 데이터(오디오 포함)를 포함하는 래퍼 포맷으로 여길 수 있으며 **압축된 비디오**를 컨테이너의 페이로드로 볼 수도 있습니다.  
> 
> Usually, the extension of a video file defines its video container. For instance, the file `video.mp4` is probably a **[MPEG-4 Part 14](https://en.wikipedia.org/wiki/MPEG-4_Part_14)** container and a file named `video.mkv` it's probably a **[matroska](https://en.wikipedia.org/wiki/Matroska)**. To be completely sure about the codec and container format we can use [ffmpeg or mediainfo](/encoding_pratical_examples.md#inspect-stream).

## History

Before we jump into the inner workings of a generic codec, let's look back to understand a little better about some old video codecs.

The video codec [H.261](https://en.wikipedia.org/wiki/H.261)  was born in 1990 (technically 1988), and it was designed to work with **data rates of 64 kbit/s**. It already uses ideas such as chroma subsampling, macro block, etc. In the year of 1995, the **H.263** video codec standard was published and continued to be extended until 2001.

In 2003 the first version of **H.264/AVC** was completed. In the same year, a company called **TrueMotion** released their video codec as a **royalty-free** lossy video compression called **VP3**. In 2008, **Google bought** this company, releasing **VP8** in the same year. In December of 2012, Google released the **VP9** and it's  **supported by roughly ¾ of the browser market** (mobile included).

 **[AV1](https://en.wikipedia.org/wiki/AOMedia_Video_1)** is a new **royalty-free** and open source video codec that's being designed by the [Alliance for Open Media (AOMedia)](http://aomedia.org/), which is composed of the **companies: Google, Mozilla, Microsoft, Amazon, Netflix, AMD, ARM, NVidia, Intel and Cisco** among others. The **first version** 0.1.0 of the reference codec was **published on April 7, 2016**.

![codec history timeline](/i/codec_history_timeline.png "codec history timeline")

> #### The birth of AV1
>
> Early 2015, Google was working on [VP10](https://en.wikipedia.org/wiki/VP9#Successor:_from_VP10_to_AV1), Xiph (Mozilla) was working on [Daala](https://xiph.org/daala/) and Cisco open-sourced its royalty-free video codec called [Thor](https://tools.ietf.org/html/draft-fuldseth-netvc-thor-03).
>
> Then MPEG LA first announced annual caps for HEVC (H.265) and fees 8 times higher than H.264 but soon they changed the rules again:
> * **no annual cap**,
> * **content fee** (0.5% of revenue) and
> * **per-unit fees about 10 times higher than h264**.
>
> The [alliance for open media](http://aomedia.org/about-us/) was created by companies from hardware manufacturer (Intel, AMD, ARM , Nvidia, Cisco), content delivery (Google, Netflix, Amazon), browser maintainers (Google, Mozilla), and others.
>
> The companies had a common goal, a royalty-free video codec and then AV1 was born with a much [simpler patent license](http://aomedia.org/license/patent/). **Timothy B. Terriberry** did an awesome presentation, which is the source of this section, about the [AV1 conception, license model and its current state](https://www.youtube.com/watch?v=lzPaldsmJbk).
>
> You'll be surprised to know that you can **analyze the AV1 codec through your browser**, go to http://aomanalyzer.org/
>
> ![av1 browser analyzer](/i/av1_browser_analyzer.png "av1 browser analyzer")
>
> PS: If you want to learn more about the history of the codecs you must learn the basics behind [video compression patents](https://www.vcodex.com/video-compression-patents/).

## A generic codec

We're going to introduce the **main mechanics behind a generic video codec** but most of these concepts are useful and used in modern codecs such as VP9, AV1 and HEVC. Be sure to understand that we're going to simplify things a LOT. Sometimes we'll use a real example (mostly H.264) to demonstrate a technique.

## 1st step - picture partitioning

The first step is to **divide the frame** into several **partitions, sub-partitions** and beyond.

![picture partitioning](/i/picture_partitioning.png "picture partitioning")

**But why?** There are many reasons, for instance, when we split the picture we can work the predictions more precisely, using small partitions for the small moving parts while using bigger partitions to a static background.

Usually, the CODECs **organize these partitions** into slices (or tiles), macro (or coding tree units) and many sub-partitions. The max size of these partitions varies, HEVC sets 64x64 while AVC uses 16x16 but the sub-partitions can reach sizes of 4x4.

Remember that we learned how **frames are typed**?! Well, you can **apply those ideas to blocks** too, therefore we can have I-Slice, B-Slice, I-Macroblock and etc.

> ### Hands-on: Check partitions
> We can also use the [Intel Video Pro Analyzer](https://software.intel.com/en-us/intel-video-pro-analyzer) (which is paid but there is a free trial version which limits you to only the first 10 frames). Here are [VP9 partitions](/encoding_pratical_examples.md#transcoding) analyzed.
>
> ![VP9 partitions view intel video pro analyzer ](/i/paritions_view_intel_video_pro_analyzer.png "VP9 partitions view intel video pro analyzer")

## 2nd step - predictions

Once we have the partitions, we can make predictions over them. For the [inter prediction](#temporal-redundancy-inter-prediction) we need **to send the motion vectors and the residual** and the [intra prediction](#spatial-redundancy-intra-prediction) we'll **send the prediction direction and the residual** as well.

## 3rd step - transform

After we get the residual block (`predicted partition - real partition`), we can **transform** it in a way that lets us know which **pixels we can discard** while keeping the **overall quality**. There are some transformations for this exact behavior.

Although there are [other transformations](https://en.wikipedia.org/wiki/List_of_Fourier-related_transforms#Discrete_transforms), we'll look more closely at the discrete cosine transform (DCT). The [**DCT**](https://en.wikipedia.org/wiki/Discrete_cosine_transform) main features are:

* **converts** blocks of **pixels** into  same-sized blocks of **frequency coefficients**.
* **compacts** energy, making it easy to eliminate spatial redundancy.
* is **reversible**, a.k.a. you can reverse to pixels.

> On 2 Feb 2017, Cintra, R. J. and Bayer, F. M have published their paper [DCT-like Transform for Image Compression
Requires 14 Additions Only](https://arxiv.org/abs/1702.00817).

Don't worry if you didn't understand the benefits from every bullet point, we'll try to make some experiments in order to see the real value from it.

Let's take the following **block of pixels** (8x8):

![pixel values matrix](/i/pixel_matrice.png "pixel values matrix")

Which renders to the following block image (8x8):

![pixel values matrix](/i/gray_image.png "pixel values matrix")

When we **apply the DCT** over this block of pixels and we get the **block of coefficients** (8x8):

![coefficients values](/i/dct_coefficient_values.png "coefficients values")

And if we render this block of coefficients, we'll get this image:

![dct coefficients image](/i/dct_coefficient_image.png "dct coefficients image")

As you can see it looks nothing like the original image, we might notice that the **first coefficient** is very different from all the others. This first coefficient is known as the DC coefficient which represents of **all the samples** in the input array, something **similar to an average**.

This block of coefficients has an interesting property which is that it separates the high-frequency components from the low frequency.

![dct frequency coefficients property](/i/dctfrequ.jpg "dct frequency coefficients property")

In an image, **most of the energy** will be concentrated in the [**lower frequencies**](https://web.archive.org/web/20150129171151/https://www.iem.thm.de/telekom-labor/zinke/mk/mpeg2beg/whatisit.htm), so if we transform an image into its frequency components and **throw away the higher frequency coefficients**, we can **reduce the amount of data** needed to describe the image without sacrificing too much image quality.

> frequency means how fast a signal is changing

Let's try to apply the knowledge we acquired in the test by converting the original image to its frequency (block of coefficients) using DCT and then throwing away part of the least important coefficients.

First, we convert it to its **frequency domain**.

![coefficients values](/i/dct_coefficient_values.png "coefficients values")

Next, we discard part (67%) of the coefficients, mostly the bottom right part of it.

![zeroed coefficients](/i/dct_coefficient_zeroed.png "zeroed coefficients")

Finally, we reconstruct the image from this discarded block of coefficients (remember, it needs to be reversible) and compare it to the original.

![original vs quantized](/i/original_vs_quantized.png "original vs quantized")

As we can see it resembles the original image but it introduced lots of differences from the original, we **throw away 67.1875%** and we still were able to get at least something similar to the original. We could more intelligently discard the coefficients to have a better image quality but that's the next topic.

> **Each coefficient is formed using all the pixels**
>
> It's important to note that each coefficient doesn't directly map to a single pixel but it's a weighted sum of all pixels. This amazing graph shows how the first and second coefficient is calculated, using weights which are unique for each index.
>
> ![dct calculation](/i/applicat.jpg "dct calculation")
>
> Source: https://web.archive.org/web/20150129171151/https://www.iem.thm.de/telekom-labor/zinke/mk/mpeg2beg/whatisit.htm
>
> You can also try to [visualize the DCT by looking at a simple image](/dct_better_explained.ipynb) formation over the DCT basis. For instance, here's the [A character being formed](https://en.wikipedia.org/wiki/Discrete_cosine_transform#Example_of_IDCT) using each coefficient weight.
>
> ![](https://upload.wikimedia.org/wikipedia/commons/5/5e/Idct-animation.gif )




<br/>

> ### Hands-on: throwing away different coefficients
> You can play around with the [DCT transform](/uniform_quantization_experience.ipynb).

## 4th step - quantization

When we throw away some of the coefficients, in the last step (transform), we kinda did some form of quantization. This step is where we chose to lose information (the **lossy part**) or in simple terms, we'll **quantize coefficients to achieve compression**.

How can we quantize a block of coefficients? One simple method would be a uniform quantization, where we take a block, **divide it by a single value** (10) and round this value.

![quantize](/i/quantize.png "quantize")

How can we **reverse** (re-quantize) this block of coefficients? We can do that by **multiplying the same value** (10) we divide it first.

![re-quantize](/i/re-quantize.png "re-quantize")

This **approach isn't the best** because it doesn't take into account the importance of each coefficient, we could use a **matrix of quantizers** instead of a single value, this matrix can exploit the property of the DCT, quantizing most the bottom right and less the upper left, the [JPEG uses a similar approach](https://www.hdm-stuttgart.de/~maucher/Python/MMCodecs/html/jpegUpToQuant.html), you can check [source code to see this matrix](https://github.com/google/guetzli/blob/master/guetzli/jpeg_data.h#L40).

> ### Hands-on: quantization
> You can play around with the [quantization](/dct_experiences.ipynb).

## 5th step - entropy coding

After we quantized the data (image blocks/slices/frames) we still can compress it in a lossless way. There are many ways (algorithms) to compress data. We're going to briefly experience some of them, for a deeper understanding you can read the amazing book [Understanding Compression: Data Compression for Modern Developers](https://www.amazon.com/Understanding-Compression-Data-Modern-Developers/dp/1491961538/).

### VLC coding:

Let's suppose we have a stream of the symbols: **a**, **e**, **r** and **t** and their probability (from 0 to 1) is represented by this table.

|             | a   | e   | r    | t   |
|-------------|-----|-----|------|-----|
| probability | 0.3 | 0.3 | 0.2 |  0.2 |

We can assign unique binary codes (preferable small) to the most probable and bigger codes to the least probable ones.

|             | a   | e   | r    | t   |
|-------------|-----|-----|------|-----|
| probability | 0.3 | 0.3 | 0.2 | 0.2 |
| binary code | 0 | 10 | 110 | 1110 |

Let's compress the stream **eat**, assuming we would spend 8 bits for each symbol, we would spend **24 bits** without any compression. But in case we replace each symbol for its code we can save space.

The first step is to encode the symbol **e** which is `10` and the second symbol is **a** which is added (not in a mathematical way) `[10][0]` and finally the third symbol **t** which makes our final compressed bitstream to be `[10][0][1110]` or `1001110` which only requires **7 bits** (3.4 times less space than the original).

Notice that each code must be a unique prefixed code [Huffman can help you to find these numbers](https://en.wikipedia.org/wiki/Huffman_coding). Though it has some issues there are [video codecs that still offers](https://en.wikipedia.org/wiki/Context-adaptive_variable-length_coding) this method and it's the  algorithm for many applications which requires compression.

Both encoder and decoder **must know** the symbol table with its code, therefore, you need to send the table too.

### Arithmetic coding:

Let's suppose we have a stream of the symbols: **a**, **e**, **r**, **s** and **t** and their probability is represented by this table.

|             | a   | e   | r    | s    | t   |
|-------------|-----|-----|------|------|-----|
| probability | 0.3 | 0.3 | 0.15 | 0.05 | 0.2 |

With this table in mind, we can build ranges containing all the possible symbols sorted by the most frequents.

![initial arithmetic range](/i/range.png "initial arithmetic range")

Now let's encode the stream **eat**, we pick the first symbol **e** which is located within the subrange **0.3 to 0.6** (but not included) and we take this subrange and split it again using the same proportions used before but within this new range.

![second sub range](/i/second_subrange.png "second sub range")

Let's continue to encode our stream **eat**, now we take the second symbol **a** which is within the new subrange **0.3 to 0.39** and then we take our last symbol **t** and we do the same process again and we get the last subrange **0.354 to 0.372**.

![final arithmetic range](/i/arithimetic_range.png "final arithmetic range")

We just need to pick a number within the last subrange **0.354 to 0.372**, let's choose **0.36** but we could choose any number within this subrange. With **only** this number we'll be able to recover our original stream **eat**. If you think about it, it's like if we were drawing a line within ranges of ranges to encode our stream.

![final range traverse](/i/range_show.png "final range traverse")

The **reverse process** (A.K.A. decoding) is equally easy, with our number **0.36** and our original range we can run the same process but now using this number to reveal the stream encoded behind this number.

With the first range, we notice that our number fits at the slice, therefore, it's our first symbol, now we split this subrange again, doing the same process as before, and we'll notice that **0.36** fits the symbol **a** and after we repeat the process we came to the last symbol **t** (forming our original encoded stream *eat*).

Both encoder and decoder **must know** the symbol probability table, therefore you need to send the table.

Pretty neat, isn't it? People are damn smart to come up with a such solution, some [video codecs use](https://en.wikipedia.org/wiki/Context-adaptive_binary_arithmetic_coding) this technique (or at least offer it as an option).

The idea is to lossless compress the quantized bitstream, for sure this article is missing tons of details, reasons, trade-offs and etc. But [you should learn more](https://www.amazon.com/Understanding-Compression-Data-Modern-Developers/dp/1491961538/) as a developer. Newer codecs are trying to use different [entropy coding algorithms like ANS.](https://en.wikipedia.org/wiki/Asymmetric_Numeral_Systems)

> ### Hands-on: CABAC vs CAVLC
> You can [generate two streams, one with CABAC and other with CAVLC](https://github.com/leandromoreira/introduction_video_technology/blob/master/encoding_pratical_examples.md#cabac-vs-cavlc) and **compare the time** it took to generate each of them as well as **the final size**.

## 6th step - bitstream format

After we did all these steps we need to **pack the compressed frames and context to these steps**. We need to explicitly inform to the decoder about **the decisions taken by the encoder**, such as bit depth, color space, resolution, predictions info (motion vectors, intra prediction direction), profile, level, frame rate, frame type, frame number and much more.

We're going to study, superficially, the H.264 bitstream. Our first step is to [generate a minimal  H.264 <sup>*</sup> bitstream](/encoding_pratical_examples.md#generate-a-single-frame-h264-bitstream), we can do that using our own repository and [ffmpeg](http://ffmpeg.org/).

```
./s/ffmpeg -i /files/i/minimal.png -pix_fmt yuv420p /files/v/minimal_yuv420.h264
```

> <sup>*</sup> ffmpeg adds, by default, all the encoding parameter as a **SEI NAL**, soon we'll define what is a NAL.

This command will generate a raw h264 bitstream with a **single frame**, 64x64, with color space yuv420 and using the following image as the frame.

> ![used frame to generate minimal h264 bitstream](/i/minimal.png "used frame to generate minimal h264 bitstream")

### H.264 bitstream

The AVC (H.264) standard defines that the information will be sent in **macro frames** (in the network sense), called **[NAL](https://en.wikipedia.org/wiki/Network_Abstraction_Layer)** (Network Abstraction Layer). The main goal of the NAL is the provision of a "network-friendly" video representation, this standard must work on TVs (stream based), the Internet (packet based) among others.

![NAL units H.264](/i/nal_units.png "NAL units H.264")

There is a **[synchronization marker](https://en.wikipedia.org/wiki/Frame_synchronization)** to define the boundaries of the NAL's units. Each synchronization marker holds a value of `0x00 0x00 0x01` except to the very first one which is `0x00 0x00 0x00 0x01`. If we run the **hexdump** on the generated h264 bitstream, we can identify at least three NALs in the beginning of the file.

![synchronization marker on NAL units](/i/minimal_yuv420_hex.png "synchronization marker on NAL units")

As we said before, the decoder needs to know not only the picture data but also the details of the video, frame, colors, used parameters, and others. The **first byte** of each NAL defines its category and **type**.

| NAL type id  | Description  |
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
| 11 |  End of stream |
| ... |  ... |

Usually, the first NAL of a bitstream is a **SPS**, this type of NAL is responsible for informing the general encoding variables like **profile**, **level**, **resolution** and others.

If we skip the first synchronization marker we can decode the **first byte** to know what **type of NAL** is the first one.

For instance the first byte after the synchronization marker is `01100111`, where the first bit (`0`) is to the field **forbidden_zero_bit**, the next 2 bits (`11`) tell us the field **nal_ref_idc** which indicates whether this NAL is a reference field or not and the rest 5 bits (`00111`) inform us the field **nal_unit_type**, in this case, it's a **SPS** (7) NAL unit.

The second byte (`binary=01100100, hex=0x64, dec=100`) of an SPS NAL is the field **profile_idc** which shows the profile that the encoder has used, in this case, we used  the **[constrained high-profile](https://en.wikipedia.org/wiki/H.264/MPEG-4_AVC#Profiles)**, it's a high profile without the support of B (bi-predictive) slices.

![SPS binary view](/i/minimal_yuv420_bin.png "SPS binary view")

When we read the H.264 bitstream spec for an SPS NAL we'll find many values for the **parameter name**, **category** and a **description**, for instance, let's look at `pic_width_in_mbs_minus_1` and `pic_height_in_map_units_minus_1` fields.

| Parameter name  | Category  |  Description  |
|---  |---|---|
| pic_width_in_mbs_minus_1 |  0 | ue(v) |
| pic_height_in_map_units_minus_1 |  0 | ue(v) |

> **ue(v)**: unsigned integer [Exp-Golomb-coded](https://pythonhosted.org/bitstring/exp-golomb.html)

If we do some math with the value of these fields we will end up with the **resolution**. We can represent a `1920 x 1080` using a `pic_width_in_mbs_minus_1` with the value of `119 ( (119 + 1) * macroblock_size = 120 * 16 = 1920) `, again saving space, instead of encode `1920` we did it with `119`.

If we continue to examine our created video with a binary view (ex: `xxd -b -c 11 v/minimal_yuv420.h264`), we can skip to the last NAL which is the frame itself.

![h264 idr slice header](/i/slice_nal_idr_bin.png "h264 idr slice header")

We can see its first 6 bytes values: `01100101 10001000 10000100 00000000 00100001 11111111`. As we already know the first byte tell us about what type of NAL it is, in this case, (`00101`) it's an **IDR Slice (5)** and we can further inspect it:

![h264 slice header spec](/i/slice_header.png "h264 slice header spec")

Using the spec info we can decode what type of slice (**slice_type**), the frame number (**frame_num**) among others important fields.

In order to get the values of some fields (`ue(v), me(v), se(v) or te(v)`) we need to decode it using a special decoder called [Exponential-Golomb](https://pythonhosted.org/bitstring/exp-golomb.html), this method is **very efficient to encode variable values**, mostly when there are many default values.

> The values of **slice_type** and **frame_num** of this video are 7 (I slice) and 0 (the first frame).

We can see the **bitstream as a protocol** and if you want or need to learn more about this bitstream please refer to the [ITU H.264 spec.]( http://www.itu.int/rec/T-REC-H.264-201610-I) Here's a macro diagram which shows where the picture data (compressed YUV) resides.

![h264 bitstream macro diagram](/i/h264_bitstream_macro_diagram.png "h264 bitstream macro diagram")

We can explore others bitstreams like the [VP9 bitstream](https://storage.googleapis.com/downloads.webmproject.org/docs/vp9/vp9-bitstream-specification-v0.6-20160331-draft.pdf), [H.265 (HEVC)](http://handle.itu.int/11.1002/1000/11885-en?locatt=format:pdf) or even our **new best friend** [**AV1** bitstream](https://medium.com/@mbebenita/av1-bitstream-analyzer-d25f1c27072b#.d5a89oxz8
), [do they all look similar? No](http://www.gpac-licensing.com/2016/07/12/vp9-av1-bitstream-format/), but once you learned one you can easily get the others.

> ### Hands-on: Inspect the H.264 bitstream
> We can [generate a single frame video](https://github.com/leandromoreira/introduction_video_technology/blob/master/encoding_pratical_examples.md#generate-a-single-frame-video) and use  [mediainfo](https://en.wikipedia.org/wiki/MediaInfo) to inspect its H.264 bitstream. In fact, you can even see the [source code that parses h264 (AVC)](https://github.com/MediaArea/MediaInfoLib/blob/master/Source/MediaInfo/Video/File_Avc.cpp) bitstream.
>
> ![mediainfo details h264 bitstream](/i/mediainfo_details_1.png "mediainfo details h264 bitstream")
>
> We can also use the [Intel Video Pro Analyzer](https://software.intel.com/en-us/intel-video-pro-analyzer) which is paid but there is a free trial version which limits you to only the first 10 frames but that's okay for learning purposes.
>
> ![intel video pro analyzer details h264 bitstream](/i/intel-video-pro-analyzer.png "intel video pro analyzer details h264 bitstream")

## Review

We'll notice that many of the **modern codecs uses this same model we learned**. In fact, let's look at the Thor video codec block diagram, it contains all the steps we studied. The idea is that you now should be able to at least understand better the innovations and papers for the area.

![thor_codec_block_diagram](/i/thor_codec_block_diagram.png "thor_codec_block_diagram")

Previously we had calculated that we needed [139GB of storage to keep a video file with one hour at 720p resolution and 30fps](#chroma-subsampling) if we use the techniques we learned here, like **inter and intra prediction, transform, quantization, entropy coding and other** we can achieve, assuming we are spending **0.031 bit per pixel**, the same perceivable quality video **requiring only 367.82MB vs 139GB** of store.

> We choose to use **0.031 bit per pixel** based on the example video provided here.

## How does H.265 achieve a better compression ratio than H.264?

Now that we know more about how codecs work, then it is easy to understand how new codecs are able to deliver higher resolutions with fewer bits.

We will compare AVC and HEVC, let's keep in mind that it is almost always a trade-off between more CPU cycles (complexity) and compression rate.

HEVC has bigger and more **partitions** (and **sub-partitions**) options than AVC, more **intra predictions directions**, **improved entropy coding** and more, all these improvements made H.265 capable to compress 50% more than H.264.

![h264 vs h265](/i/avc_vs_hevc.png "H.264 vs H.265")

# Online streaming
## General architecture

![general architecture](/i/general_architecture.png "general architecture")

[TODO]

## Progressive download and adaptive streaming

![progressive download](/i/progressive_download.png "progressive download")

![adaptive streaming](/i/adaptive_streaming.png "adaptive streaming")

[TODO]

## Content protection

We can use **a simple token system** to protect the content. The user without a token tries to request a video and the CDN forbids her or him while a user with a valid token can play the content, it works pretty similarly to most of the web authentication systems.

![token protection](/i/token_protection.png "token_protection")

The sole use of this token system still allows a user to download a video and distribute it. Then the **DRM (digital rights management)** systems can be used to try to avoid this.

![drm](/i/drm.png "drm")

In real life production systems, people often use both techniques to provide authorization and authentication.

### DRM
#### Main systems

* FPS - [**FairPlay Streaming**](https://developer.apple.com/streaming/fps/)
* PR - [**PlayReady**](https://www.microsoft.com/playready/)
* WV - [**Widevine**](http://www.widevine.com/)


#### What?

DRM means Digital rights management, it's a way **to provide copyright protection for digital media**, for instance, digital video and audio. Although it's used in many places [it's not universally accepted](https://en.wikipedia.org/wiki/Digital_rights_management#DRM-free_works).

#### Why?

Content creator (mostly studios) want to protect its intelectual property against copy to prevent unauthorized redistribution of digital media.

#### How?

We're going to describe an abstract and generic form of DRM in a very simplified way.

Given a **content C1** (i.e. an hls or dash video streaming), with a **player P1** (i.e. shaka-clappr, exo-player or ios) in a **device D1** (i.e. a smartphone, TV, tablet or desktop/notebook) using a **DRM system DRM1** (widevine, playready or FairPlay).

The content C1 is encrypted with a **symmetric-key K1** from the system DRM1, generating the **encrypted content C'1**.

![drm general flow](/i/drm_general_flow.jpeg "drm general flow")

The player P1, of a device D1, has two keys (asymmetric), a **private key PRK1** (this key is protected<sup>1</sup> and only known by **D1**) and a **public key PUK1**.

> **<sup>1</sup>protected**: this protection can be **via hardware**, for instance, this key can be stored inside a special (read-only) chip that works like [a black-box](https://en.wikipedia.org/wiki/Black_box) to provide decryption, or **by software** (less safe), the DRM system provides means to know which type of protection a given device has.


When the **player P1 wants to play** the **content C'1**, it needs to deal with the **DRM system DRM1**, giving its public key **PUK1**. The DRM system DRM1 returns the **key K1 encrypted** with the client''s public key **PUK1**. In theory, this response is something that **only D1 is capable of decrypting**.

`K1P1D1 = enc(K1, PUK1)`

**P1** uses its DRM local system (it could be a [SOC](https://en.wikipedia.org/wiki/System_on_a_chip), a specialized hardware or software), this system is **able to decrypt** the content using its private key PRK1, it can decrypt **the symmetric-key K1 from the K1P1D1** and **play C'1**. At best case, the keys are not exposed through RAM.

 ```
 K1 = dec(K1P1D1, PRK1)

 P1.play(dec(C'1, K1))
 ```

![drm decoder flow](/i/drm_decoder_flow.jpeg "drm decoder flow")

# How to use jupyter

Make sure you have **docker installed** and just run `./s/start_jupyter.sh` and follow the instructions on the terminal.

# Conferences

* [DEMUXED](https://demuxed.com/) - you can [check the last 2 events presentations.](https://www.youtube.com/channel/UCIc_DkRxo9UgUSTvWVNCmpA).

# References

The richest content is here, it's where all the info we saw in this text was extracted, based or inspired by. You can deepen your knowledge with these amazing links, books, videos and etc.

Online Courses and Tutorials:

* https://www.coursera.org/learn/digital/
* https://people.xiph.org/~tterribe/pubs/lca2012/auckland/intro_to_video1.pdf
* https://xiph.org/video/vid1.shtml
* https://xiph.org/video/vid2.shtml
* http://slhck.info/ffmpeg-encoding-course
* http://www.cambridgeincolour.com/tutorials/camera-sensors.htm
* http://www.slideshare.net/vcodex/a-short-history-of-video-coding
* http://www.slideshare.net/vcodex/introduction-to-video-compression-13394338
* https://developer.android.com/guide/topics/media/media-formats.html
* http://www.slideshare.net/MadhawaKasun/audio-compression-23398426
* http://inst.eecs.berkeley.edu/~ee290t/sp04/lectures/02-Motion_Compensation_girod.pdf

Books:

* https://www.amazon.com/Understanding-Compression-Data-Modern-Developers/dp/1491961538/ref=sr_1_1?s=books&ie=UTF8&qid=1486395327&sr=1-1
* https://www.amazon.com/H-264-Advanced-Video-Compression-Standard/dp/0470516925
* https://www.amazon.com/Practical-Guide-Video-Audio-Compression/dp/0240806301/ref=sr_1_3?s=books&ie=UTF8&qid=1486396914&sr=1-3&keywords=A+PRACTICAL+GUIDE+TO+VIDEO+AUDIO
* https://www.amazon.com/Video-Encoding-Numbers-Eliminate-Guesswork/dp/0998453005/ref=sr_1_1?s=books&ie=UTF8&qid=1486396940&sr=1-1&keywords=jan+ozer

Bitstream Specifications:

* http://www.itu.int/rec/T-REC-H.264-201610-I
* http://www.itu.int/ITU-T/recommendations/rec.aspx?rec=12904&lang=en
* https://storage.googleapis.com/downloads.webmproject.org/docs/vp9/vp9-bitstream-specification-v0.6-20160331-draft.pdf
* http://iphome.hhi.de/wiegand/assets/pdfs/2012_12_IEEE-HEVC-Overview.pdf
* http://phenix.int-evry.fr/jct/doc_end_user/current_document.php?id=7243
* http://gentlelogic.blogspot.com.br/2011/11/exploring-h264-part-2-h264-bitstream.html
* https://forum.doom9.org/showthread.php?t=167081
* https://forum.doom9.org/showthread.php?t=168947

Software:

* https://ffmpeg.org/
* https://ffmpeg.org/ffmpeg-all.html
* https://ffmpeg.org/ffprobe.html
* https://trac.ffmpeg.org/wiki/
* https://software.intel.com/en-us/intel-video-pro-analyzer
* https://medium.com/@mbebenita/av1-bitstream-analyzer-d25f1c27072b#.d5a89oxz8

Non-ITU Codecs:

* https://aomedia.googlesource.com/
* https://github.com/webmproject/libvpx/tree/master/vp9
* https://people.xiph.org/~xiphmont/demo/daala/demo1.shtml
* https://people.xiph.org/~jm/daala/revisiting/
* https://www.youtube.com/watch?v=lzPaldsmJbk
* https://fosdem.org/2017/schedule/event/om_av1/

Encoding Concepts:

* http://x265.org/hevc-h265/
* http://slhck.info/video/2017/03/01/rate-control.html
* http://slhck.info/video/2017/02/24/vbr-settings.html
* http://slhck.info/video/2017/02/24/crf-guide.html
* https://arxiv.org/pdf/1702.00817v1.pdf
* https://trac.ffmpeg.org/wiki/Debug/MacroblocksAndMotionVectors
* http://web.ece.ucdavis.edu/cerl/ReliableJPEG/Cung/jpeg.html
* http://www.adobe.com/devnet/adobe-media-server/articles/h264_encoding.html
* https://prezi.com/8m7thtvl4ywr/mp3-and-aac-explained/
* https://blogs.gnome.org/rbultje/2016/12/13/overview-of-the-vp9-video-codec/

Video Sequences for Testing:

* http://bbb3d.renderfarming.net/download.html
* https://www.its.bldrdoc.gov/vqeg/video-datasets-and-organizations.aspx

Miscellaneous:

* http://stackoverflow.com/a/24890903
* http://stackoverflow.com/questions/38094302/how-to-understand-header-of-h264
* http://techblog.netflix.com/2016/08/a-large-scale-comparison-of-x264-x265.html
* http://vanseodesign.com/web-design/color-luminance/
* http://www.biologymad.com/nervoussystem/eyenotes.htm
* http://www.compression.ru/video/codec_comparison/h264_2012/mpeg4_avc_h264_video_codecs_comparison.pdf
* http://www.csc.villanova.edu/~rschumey/csc4800/dct.html
* http://www.explainthatstuff.com/digitalcameras.html
* http://www.hkvstar.com
* http://www.hometheatersound.com/
* http://www.lighterra.com/papers/videoencodingh264/
* http://www.red.com/learn/red-101/video-chroma-subsampling
* http://www.slideshare.net/ManoharKuse/hevc-intra-coding
* http://www.slideshare.net/mwalendo/h264vs-hevc
* http://www.slideshare.net/rvarun7777/final-seminar-46117193
* http://www.springer.com/cda/content/document/cda_downloaddocument/9783642147029-c1.pdf
* http://www.streamingmedia.com/Articles/Editorial/Featured-Articles/A-Progress-Report-The-Alliance-for-Open-Media-and-the-AV1-Codec-110383.aspx
* http://www.streamingmediaglobal.com/Articles/ReadArticle.aspx?ArticleID=116505&PageNum=1
* http://yumichan.net/video-processing/video-compression/introduction-to-h264-nal-unit/
* https://cardinalpeak.com/blog/the-h-264-sequence-parameter-set/
* https://cardinalpeak.com/blog/worlds-smallest-h-264-encoder/
* https://codesequoia.wordpress.com/category/video/
* https://developer.apple.com/library/content/technotes/tn2224/_index.html
* https://en.wikibooks.org/wiki/MeGUI/x264_Settings
* https://en.wikipedia.org/wiki/Adaptive_bitrate_streaming
* https://en.wikipedia.org/wiki/AOMedia_Video_1
* https://en.wikipedia.org/wiki/Chroma_subsampling#/media/File:Colorcomp.jpg
* https://en.wikipedia.org/wiki/Cone_cell
* https://en.wikipedia.org/wiki/File:H.264_block_diagram_with_quality_score.jpg
* https://en.wikipedia.org/wiki/Inter_frame
* https://en.wikipedia.org/wiki/Intra-frame_coding
* https://en.wikipedia.org/wiki/Photoreceptor_cell
* https://en.wikipedia.org/wiki/Pixel_aspect_ratio
* https://en.wikipedia.org/wiki/Presentation_timestamp
* https://en.wikipedia.org/wiki/Rod_cell
* https://it.wikipedia.org/wiki/File:Pixel_geometry_01_Pengo.jpg
* https://leandromoreira.com.br/2016/10/09/how-to-measure-video-quality-perception/
* https://sites.google.com/site/linuxencoding/x264-ffmpeg-mapping
* https://softwaredevelopmentperestroika.wordpress.com/2014/02/11/image-processing-with-python-numpy-scipy-image-convolution/
* https://tools.ietf.org/html/draft-fuldseth-netvc-thor-03
* https://www.encoding.com/android/
* https://www.encoding.com/http-live-streaming-hls/
* https://web.archive.org/web/20150129171151/https://www.iem.thm.de/telekom-labor/zinke/mk/mpeg2beg/whatisit.htm
* https://www.lifewire.com/cmos-image-sensor-493271
* https://www.linkedin.com/pulse/brief-history-video-codecs-yoav-nativ
* https://www.linkedin.com/pulse/video-streaming-methodology-reema-majumdar
* https://www.vcodex.com/h264avc-intra-precition/
* https://www.youtube.com/watch?v=9vgtJJ2wwMA
* https://www.youtube.com/watch?v=LFXN9PiOGtY
* https://www.youtube.com/watch?v=Lto-ajuqW3w&list=PLzH6n4zXuckpKAj1_88VS-8Z6yn9zX_P6
* https://www.youtube.com/watch?v=LWxu4rkZBLw
* https://web.stanford.edu/class/ee398a/handouts/lectures/EE398a_MotionEstimation_2012.pdf
