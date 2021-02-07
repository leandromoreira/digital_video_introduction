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
  - [역사](#%EC%97%AD%EC%82%AC)
  - [일반 코덱](#%EC%9D%BC%EB%B0%98-%EC%BD%94%EB%8D%B1)
  - [첫 번째 스텝 - 사진 파티셔닝](#%EC%B2%AB-%EB%B2%88%EC%A7%B8-%EC%8A%A4%ED%85%9D---%EC%82%AC%EC%A7%84-%ED%8C%8C%ED%8B%B0%EC%85%94%EB%8B%9D)
  - [두 번째 스텝 - 프리딕션](#%EB%91%90-%EB%B2%88%EC%A7%B8-%EC%8A%A4%ED%85%9D---%ED%94%84%EB%A6%AC%EB%94%95%EC%85%98)
  - [세 번째 스탭 - 변환](#%EC%84%B8-%EB%B2%88%EC%A7%B8-%EC%8A%A4%ED%83%AD---%EB%B3%80%ED%99%98)
  - [네 번째 단계 - 양자화](#%EB%84%A4-%EB%B2%88%EC%A7%B8-%EB%8B%A8%EA%B3%84---%EC%96%91%EC%9E%90%ED%99%94)
  - [다섯번째 단계 - 엔트로피 인코딩](#%EB%8B%A4%EC%84%AF%EB%B2%88%EC%A7%B8-%EB%8B%A8%EA%B3%84---%EC%97%94%ED%8A%B8%EB%A1%9C%ED%94%BC-%EC%9D%B8%EC%BD%94%EB%94%A9)
    - [VLC coding:](#vlc-coding)
    - [산술적 코딩:](#%EC%82%B0%EC%88%A0%EC%A0%81-%EC%BD%94%EB%94%A9)
  - [여섯번째 단계 - 비트 스트림 포맷](#%EC%97%AC%EC%84%AF%EB%B2%88%EC%A7%B8-%EB%8B%A8%EA%B3%84---%EB%B9%84%ED%8A%B8-%EC%8A%A4%ED%8A%B8%EB%A6%BC-%ED%8F%AC%EB%A7%B7)
    - [H.264 비트스트림](#h264-%EB%B9%84%ED%8A%B8%EC%8A%A4%ED%8A%B8%EB%A6%BC)
  - [리뷰](#%EB%A6%AC%EB%B7%B0)
  - [어떻게 H.265는 H.264보다 더 높은 압축률을 달성했는가](#%EC%96%B4%EB%96%BB%EA%B2%8C-h265%EB%8A%94-h264%EB%B3%B4%EB%8B%A4-%EB%8D%94-%EB%86%92%EC%9D%80-%EC%95%95%EC%B6%95%EB%A5%A0%EC%9D%84-%EB%8B%AC%EC%84%B1%ED%96%88%EB%8A%94%EA%B0%80)
- [온라인 스트리밍](#%EC%98%A8%EB%9D%BC%EC%9D%B8-%EC%8A%A4%ED%8A%B8%EB%A6%AC%EB%B0%8D)
  - [일반적인 아키텍쳐](#%EC%9D%BC%EB%B0%98%EC%A0%81%EC%9D%B8-%EC%95%84%ED%82%A4%ED%85%8D%EC%B3%90)
  - [점진적 다운로드와 적응형 스트리밍](#%EC%A0%90%EC%A7%84%EC%A0%81-%EB%8B%A4%EC%9A%B4%EB%A1%9C%EB%93%9C%EC%99%80-%EC%A0%81%EC%9D%91%ED%98%95-%EC%8A%A4%ED%8A%B8%EB%A6%AC%EB%B0%8D)
  - [컨텐츠 보호](#%EC%BB%A8%ED%85%90%EC%B8%A0-%EB%B3%B4%ED%98%B8)
    - [DRM](#drm)
      - [Main systems](#main-systems)
      - [무엇인가?](#%EB%AC%B4%EC%97%87%EC%9D%B8%EA%B0%80)
      - [왜?](#%EC%99%9C)
      - [어떻게?](#%EC%96%B4%EB%96%BB%EA%B2%8C)
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

`I-frame(레퍼런스, 키프레임, 인트라)`은 **독립적인 프레임**입니다. 렌더링 하기 위해 어떤 것에도 의존적이지 않지요. I-frame은 마치 정적인 사진같습니다. 첫 번째 프레임은 보통 I-frame입니다. 하지만 I-frame은 일반적으로 다른 유형의 프레임의 사이사이에 삽입된다는 사실을 볼 수 있을 겁니다.  

![ball 1](/i/smw_background_ball_1.png "ball 1")

### P Frame (predicted)

`P-frame`은 항상 **이전의 프레임을 이용하여 렌더링 될 수 있다는 점**을 이점으로 취할 수 있습니다. 예를 들어 두 번째 프레임에서 변화라곤 공이 앞으로 움직인 것 뿐입니다. **변경된 부분을 사용해서 이 전의 프레임을 참고하여 프레임 1번을 다시 만들 수 있지요.**

![ball 1](/i/smw_background_ball_1.png "ball 1") <-  ![ball 2](/i/smw_background_ball_2_diff.png "ball 2")

> #### 실습: I-frame이 한장 뿐인 동영상
> P-frame이 데이터를 적게 사용하는데 왜 전체를 [I-frame 한장에 나머지 전부가 p-frame인 영상](/encoding_pratical_examples.md#1-i-frame-and-the-rest-p-frames)으로 인코딩하지 않을까요?
>
> 이 비디오를 인코딩 후 영상을 재생해 비디오의 **앞부분으로 이동**해보면, 이동하는데 **시간이 좀 걸림**을 발견하게 될 것입니다. 왜냐하면 **P-frame은 렌더링하기 위해 레퍼런스 프레임(가령 I-frame)이 필요하기 때문**입니다.  
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

시도해 볼 수 있는 한 가지는 바로 제거입니다. 단순히 **프레임 0에서 프레임 1을 빼면** 오로지 **남은 부분만 인코딩**하면 됩니다.  

![delta frames](/i/difference_frames.png "delta frames")

하지만 이보다 더 적은 비트를 사용하는 **더 나은 방법**이 있다면 어떠시겠나요? 우선, `frame 0`을 잘 정의된 파티션의 집합으로 여기고, `frame 0`에 `frame 1`을 매칭시켜보세요. 이를 **모션 추정**으로 생각할 수 있지요.  

> ### 위키페디아 - 블록 모션 보정
> "**블록 모션 보정**은 현재 프레임을 겹치지 않은 블록으로 분할하고, 모션 보정 벡터가 **블록이 어디에서 왔는지 알려줍니다.** (일반적인 오개념으로 이전의 프레임이 겹치지 않은 블록으로 분할되어 있고, 모션 보정 벡터가 이 블록들이 어디로 이동할 지 알려주는 정보라고 여기는 것이 있습니다.) 원본 블록은 일반적으로 원본 프레임에 겹칩니다. 몇몇의 비디오 압축 알고리즘은 서로 다른 이전에 전송된 프레임의 일부 조각을 현재 프레임과 합칩니다."

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
> 초심자들이 흔히 범하는 실수 중 하나로 디지털 동영상 코덱과 [디지털 비디오 컨테이너](https://en.wikipedia.org/wiki/Digital_container_format)를 혼동하는 것입니다. **컨테이너**를 동영상의 메타 데이터(오디오 포함)를 포함하는 래퍼 포맷으로 여길 수 있으며 **압축된 비디오**를 컨테이너의 페이로드로 볼 수도 있습니다.  
> 
> 일반적으로 동영상 파일의 확장자는 비디오 파일의 동영상 컨테이너를 정의합니다. 예를들어 `video.mp4` 파일은 **[MPEG-4 Part 14](https://en.wikipedia.org/wiki/MPEG-4_Part_14)** 컨테이너일 것이고 파일 이름은 `video.mkv`로 **[matroska](https://en.wikipedia.org/wiki/Matroska)** 일 것입니다. 코덱과 컨테이너 포멧을 정확히 확인하려면 [ffmpeg나 mediainfo](/encoding_pratical_examples.md#inspect-stream)를 사용하면 됩니다.  

## 역사

일반적인 코덱의 내부 동작을 파헤치기에 앞서, 구세대 동영상 코덱에 대해 좀 더 자세히 살펴보도록 합시다.  

비디오 코덱인 [H.261](https://en.wikipedia.org/wiki/H.261)는 1990년(정확히는 1988년)에 탄생하였으며 **64 kibt/s의 데이터 전송비**로 동작하기 위해 설계되었습니다. 이 코덱에서 이미 크로마 서브샘플링, 매크로 블록 등의 아이디어를 사용했습니다. 1995년, **H.263** 비디오 코덱 표준이 탄생하였으며 2001년까지 지속적으로 확장되었습니다.  

**H.264/AVC**의 첫 버전은 2003년에 완성되었습니다. 같은 해에, **TrueMotion**이라는 회사가 **로얄티가 없는** **VP3**이라 부르는 영상 압축 코덱을 공개하였습니다. 2008년, **구글이 이 회사를 인수하고** 같은 해에 **VP8**을 공개하였습니다. 2012년 12월, 구글은 **VP9**을 출시하였으며 VP9은 **브라우저 시장의 약 ¾(모바일 포함)에서 지원됩니다.**

 **[AV1](https://en.wikipedia.org/wiki/AOMedia_Video_1)** 은 **구글, 모질라, 마이크로소프트, 아마존, 넷플릭스, AMD, ARM, 엔비디아, 인텔 그리고 시스코**를 비롯한 여러 회사로 구성된 [오픈 미디어 연합 (AOMedia)](http://aomedia.org/)이 설계를 주도하는 **로얄티 없는** 새로운 오픈 소스 동영상 코덱입니다.  

![codec history timeline](/i/codec_history_timeline.png "codec history timeline")

> #### AV1의 탄생
>
> 2015년 초, 구글은 [VP10](https://en.wikipedia.org/wiki/VP9#Successor:_from_VP10_to_AV1)를, Xiph(모질라)는 [Daala](https://xiph.org/daala/) 그리고 시스코는 [Thor](https://tools.ietf.org/html/draft-fuldseth-netvc-thor-03)라는 로얄티 프리 비디오 코덱을 만들었습니다.  
>
> MPEG LA는 HEVC(H.265)에 대한 애뉴얼 캡을 발표하고, H.264보다 8배 높은 수수료를 발표했으나 태세전환을 하고 규칙을 변경했습니다:
> * **애뉴얼 캡 없음**,
> * **컨텐츠 수수료** (수익의 0.5%) 그리고
> * **단위당 수수료는 H.264보다 약 10배 높음**.
>
> [오픈 미디어 연합](http://aomedia.org/about/)은 하드웨어 제조사(인텔, AMD, ARM, 엔비디아, 시스코), 컨텐츠 딜리버리(구글, 넷플릭스, 아마존), 브라우저 메인테이너(구글, 모질라)를 비롯한 다른 여러 회사들에 의해 설립되었습니다. 
> 
> 이 회사들은 동일한 목표를 가지고 있었으며, 로얄티 프리의 동영상 코덱과 훨씬 [단순한 특허 라이센스](http://aomedia.org/license/patent/)로 무장한 AV1의 탄생이였죠. **티모시 B. 테리베리**는 [AV1 컨셉, 라이센스 모델, 현황](https://www.youtube.com/watch?v=lzPaldsmJbk)에 대한 멋진 프리젠테이션을 진행했습니다. 이 섹션의 출처이기도 하지요.  
>
> **브라우저로 AV1 코덱을 분석** 가능하다는 사실을 알게되면 아주 놀라실거에요. http://aomanalyzer.org/ 에 방문해보세요.
> ![av1 browser analyzer](/i/av1_browser_analyzer.png "av1 browser analyzer")
>
> 추신: 코덱의 역사에 대해 더 자세히 알고 싶으면 [동영상 압축 특허](https://www.vcodex.com/video-compression-patents/)에 대한 기초를 공부하셔야합니다.  

## 일반 코덱

**일반 코덱의 바탕이 되는 주요 메커니즘을** 소개할 것이며, 이러한 컨셉들의 대부분은 유용하고 VP9, AV1, HEVC와 같은 현대 코덱들에서 사용됩니다. 설명을 아주 굉장히 단순화한다는 점 양해 부탁드립니다. 글의 간간히 현업 예제(대부분 H.264)를 시연해볼 것입니다.    

## 첫 번째 스텝 - 사진 파티셔닝

첫 번째 단계는 **프레임을 여러개의 파티션, 서브 파티션** 그 이상으로 **분할**하는 것입니다.   

![picture partitioning](/i/picture_partitioning.png "picture partitioning")

**그런데 왜?** 많은 이유가 있어요. 예로, 사진을 분할하게 되면 정적인 배경에 커다란 파티션을 사용하고, 적은 움직임들에 대해서는 작은 파티션을 사용하면 프리딕션을 보다 더 정확하게 수행할 수 있답니다.   

일반적으로 코덱은 **이러한 파티션들을 슬라이스(혹은 타일), 매크로(혹은 코딩 트리 유닛) 그리고 수 많은 서브 파티션**으로 정리를 합니다. 이러한 파티션의 최대 크기는 다양한데, AVC는 16x16을 사용하는 반면 HEVC는 64x64를 설정하지만 서브 파티션들은 4x4의 사이즈까지도 사용합니다.  

앞서 공부한 **프레임 유형**을 떠올려봅시다. **이러한 아이디어들을 블록들에도** 적용해볼 수 있지요. 그러므로 I-Slice, B-Slice, I-Macroblock등을 이용할 수 있습니다.  

> ### 실습: 파티션 확인해보기
> 여기서도 [Intel Video Pro Analyzer](https://software.intel.com/en-us/intel-video-pro-analyzer)(유료도 있지만 첫 10프레임 제약의 무료 트라이얼 버전도 있음)를 사용할 것입니다. [VP9 파티션](/encoding_pratical_examples.md#transcoding) 분석본입니다. 
> 
> ![VP9 partitions view intel video pro analyzer ](/i/paritions_view_intel_video_pro_analyzer.png "VP9 partitions view intel video pro analyzer")

## 두 번째 스텝 - 프리딕션

파티션을 확보하고 나면, 이제 이에 대한 프리딕션을 수행할 수 있습니다. [인터 프리딕션](#temporal-redundancy-inter-prediction)에 대해서는 **모션 벡터와 나머지**를 전송해야하고, [인트라 프리딕션](#spatial-redundancy-intra-prediction)에 대해서는 **프리딕션의 방향과 나머지를 전송할 것입니다.**

## 세 번째 스탭 - 변환

잔여 블록(`예측된 파티션 - 실제 파티션`)을 확보하고 난 후에는 **변환**을 통하여 **전반적인 품질을** 유지하면서 **버려야 할 픽셀**을 알 수 있게됩니다. 이 정확한 동작을 위한 몇 가지 변환들이 존재합니다.  

[다른 다양한 변환](https://en.wikipedia.org/wiki/List_of_Fourier-related_transforms#Discrete_transforms)들이 존재하지만, 여기서는 이산 코사인 변환(DCT)에 대해 주도 면밀히 살펴볼 것입니다. [**DCT**](https://en.wikipedia.org/wiki/Discrete_cosine_transform)의 주된 성질로는:

* **픽셀들의** 블록을 동일한 사이즈의 **주파수 계수**의 블록으로 변환함
* 에너지를 **압축**하여 공간적 중복을 쉽게 제거함
* **가역적임**. 바꿔말해 픽셀로 되돌릴 수 있다는 뜻

> 2017년 2월 2일, 신트라 R.J. 와 바이엘 F.M은 [14개의 덧셈만 필요로하는 이미지 압축에 대한 DCT 유사 변환](https://arxiv.org/abs/1702.00817)을 논문으로 발표하였습니다. (역자: 8-포인트 직교 근사 이산 코사인 변환으로, 곱셈이나 비트 시프트가 필요가 없음)  

모든 불렛에 소개된 이점들에 대해 이해하지 못한다고 해서 걱정할 필요는 없습니다. 실제 값을 확인하기 위해 몇 가지 실험을 해볼거에요.  

다음 **픽셀의 블록** (8x8)을 사용해볼 것입니다:

![pixel values matrix](/i/pixel_matrice.png "pixel values matrix")

렌더링된 블록 이미지는 다음과 같습니다(8x8):  

![pixel values matrix](/i/gray_image.png "pixel values matrix")

픽셀의 블록에 대하여 **이산 코사인 변환을 수행하면** **계수의 블록**(8x8)을 얻게됩니다:

![coefficients values](/i/dct_coefficient_values.png "coefficients values")

그리고 이 계수의 블록을 렌더링하면 다음과 같은 이미지를 얻게 됩니다:

![dct coefficients image](/i/dct_coefficient_image.png "dct coefficients image")

보시는 바와 같이 원본 이미지같이 생기진 않죠. 눈치 채셨을지 모르겠지만 **첫 번째 계수**는 다른 모든 것들과 아주 다릅니다. 첫 번째 계수는 DC 계수로, 입력 배열에서 **샘플의 모든 것**을 표현하며 **평균과 유사합니다.**  

이 계수 블록은 흥미로운 성질을 가지고 있는데, 높은 주파수 성분을 낮은 주파수 성분과 분리한다는 점이지요.  

![dct frequency coefficients property](/i/dctfrequ.jpg "dct frequency coefficients property")

이미지 상에서, **에너지의 대부분은** [**낮은 주파수**](https://web.archive.org/web/20150129171151/https://www.iem.thm.de/telekom-labor/zinke/mk/mpeg2beg/whatisit.htm)에 집중되기 때문에, 이미지를 주파수 성분으로 변환하고 **높은 주파수 계수를 날려버리면**, 이미지 품질을 그리 많이 희생하지 않고도 이미지를 표현하는데 필요한 **데이터의 양을 줄일 수 있습니다.**  

> 주파수는 신호가 얼마나 빠르게 변화하는가를 의미합니다.  

테스트에서 얻은 지식을 활용하여 DCT를 사용해 원본 이미지를 주파수(계수 블록)를 변환 후 중요하지 않은 계수들을 날려봅시다. 

우선, 이를 **주파수 영역**으로 변환합니다.  

![coefficients values](/i/dct_coefficient_values.png "coefficients values")

다음으로, 오른쪽 하단의 대부분에 해당되는 계수의 부분(67%)를 버립니다.  

![zeroed coefficients](/i/dct_coefficient_zeroed.png "zeroed coefficients")

마침내, 폐기한 계수 블록으로부터 이미지를 재구성해보고 이를 원본과 비교해봅시다. (명심하세요. 이는 가역적이여야 합니다.)

![original vs quantized](/i/original_vs_quantized.png "original vs quantized")

여러분이 보시는 바와 같이 원본 이미지와 닮긴 했지만 원본과 비교하면 다른 부분이 많이 보입니다. **67.1875%를 날려버리고도** 원본과 유사한 무언가를 얻을 수 있었지요. 더 높은 이미지 품질을 위해 더 똑똑한 방법으로 계수를 폐기하는 방법도 있지만 이는 다음의 주제입니다.   

> **각 계수는 모든 픽셀을 사용하여 만듭니다**
>
> 여기서 기억하셔야 할 중요한 점은 각 계수가 각각의 픽셀과 직접적으로 매핑되지는 않으나 계수는 모든 픽셀의 가중치 합이라는 점입니다. 다음 이 놀라운 도식은 어떻게 첫 번째와 두 번째 계수가 각 인덱스에 대한 고유한 가중치를 사용하여 계산되는지 보여줍니다.  
>
> ![dct calculation](/i/applicat.jpg "dct calculation")
>
> 출처: https://web.archive.org/web/20150129171151/https://www.iem.thm.de/telekom-labor/zinke/mk/mpeg2beg/whatisit.htm
>
> 또한 DCT를 기반으로 [간단한 이미지 형성을 보며 DCT를 시각화](/dct_better_explained.ipynb)해볼 수도 있습니다. 그 예로 각 계수 가중치를 사용하여 [알파벳 A가 형성되는 모습입니다.](https://en.wikipedia.org/wiki/Discrete_cosine_transform#Example_of_IDCT)
>
> ![](https://upload.wikimedia.org/wikipedia/commons/5/5e/Idct-animation.gif )




<br/>

> ### 실습: 다른 계수 날리기
> [DCT 변환](/uniform_quantization_experience.ipynb)

## 네 번째 단계 - 양자화

몇몇 계수를 버릴 때 마지막 단계(변환)에서 일종의 양자화를 수행하였습니다. 이 단계에서는 잃을 정보(간단한 용어로 **손실부**)를 선택하고, **계수를 양자화 하여 압축을 합니다.**

어떻게 계수 블록을 양자화 시킬까요? 간단한 방법으로는 균일 양자화가 있습니다. 균일 양자화는 블록을 가지고 **단일 값(10)으로 이를 나누어** 이 값을 내림합니다.    

![quantize](/i/quantize.png "quantize")

이 계수 블록을 어떻게 **변환**(재양자화) 할까요? 처음에 나누었던 값과 **동일한 값을 곱하여** 수행할 수 있습니다.  

![re-quantize](/i/re-quantize.png "re-quantize")

**이 방법이 최선은 아닙니다.** 왜냐하면 각 계수의 중요성을 고려하지 않았기 때문입니다. 단일 값 대신 **양자화 행렬**을 사용할 수 있습니다. 이 행렬은 DCT의 특성을 이용하는 것으로, 우측 하단의 대부분을 양자화하고 좌측 상단은 덜한다는 특성으로, [JPEG가 이와 유사한 방법을 사용합니다](https://www.hdm-stuttgart.de/~maucher/Python/MMCodecs/html/jpegUpToQuant.html). [이 행렬을 소스코드](https://github.com/google/guetzli/blob/master/guetzli/jpeg_data.h#L40)에서 확인할 수 있습니다.  

> ### 실습: 양자화
> [양자화](/dct_experiences.ipynb)를 실습해보실 수 있습니다.

## 다섯번째 단계 - 엔트로피 인코딩

데이터(이미지 블록/슬라이스/프레임)를 양자화 하고 나면 손실 없이 압축할 수 있는 방법이 여전히 남아 있습니다. 데이터를 압축하는 많은 방법(알고리즘)이 존재합니다. 여기서는 그 중 일부를 간략히 알아볼 것입니다. 더 깊은 이해를 바란다면 [압축에 대한 이해: 현대 개발자를 위한 데이터 압축](https://www.amazon.com/Understanding-Compression-Data-Modern-Developers/dp/1491961538/)이라는 놀라운 책을 읽어보세요.  

### VLC coding:

심볼 스트림이 있다고 가정해봅시다: **a**, **e**, **r**, **t**이며 이 심볼들에 대한 확률(0과 1사이)은 다음 테이블에 표현됩니다.  
|             | a   | e   | r    | t   |
|-------------|-----|-----|------|-----|
| 확률         | 0.3 | 0.3 | 0.2 |  0.2 |

가장 가능성이 크고 큰 코드부터 낮은 것까지 고유한 이진 코드(작은 값 추천)를 할당할 수 있습니다.  

|             | a   | e   | r    | t   |
|-------------|-----|-----|------|-----|
| 확률         | 0.3 | 0.3 | 0.2 | 0.2 |
| 이진 코드     | 0 | 10 | 110 | 1110 |

스트림 **eat**를 압축해봅시다. 각 심볼당 8비트를 소비한다고 가정하면 압축하지 않은 경우에 24비트를 소비하게 됩니다. 하지만 각각의 심볼을 코드로 대체하면 공간을 절약할 수 있습니다.  

첫 번째 단계는 `10`에 해당하는 심볼 **e**를 인코딩하고 두 번째 심볼 **a**를 더하고(산술 연산 아님) `[10][0]` 마지막으로 최종 압축된 비트스트림을 `[10][0][1110]` 혹은 `1001110`으로 만드는 심볼 **t**를 붙여주면 오직 **7비트**만 필요로 합니다. (원본보다 3.4배 적은 공간)

각각의 코드는 반드시 고유한 접두사 코드여야 하며 [허프만이 이러한 숫자들을 찾는 데 도움이 됩니다.](https://en.wikipedia.org/wiki/Huffman_coding) 몇 가지 문제가 있음에도 **비디오 코덱들은 여전히 이 방법을 제공**하며 압축을 필요로하는 많은 애플리케이션들을 위한 알고리즘이기도 합니다.  

엔코더와 디코더 모두 **반드시 이 코드가 있는 심볼 테이블을 알고 있어야 합니다.** 그러므로 테이블도 함께 보내야하죠.  

### 산술적 코딩:

심볼 스트림이 있다고 가정해봅시다: **a**, **e**, **r**, **s**, **t**이며 이 들의 확률은 다음 테이블과 같이 표현됩니다.  

|             | a   | e   | r    | s    | t   |
|-------------|-----|-----|------|------|-----|
| 확률 | 0.3 | 0.3 | 0.15 | 0.05 | 0.2 |

이 테이블을 참고하여 빈도순으로 정렬된 모든 심볼을 포함하는 범위를 만들 수 있습니다.  

![initial arithmetic range](/i/range.png "initial arithmetic range")

이제 스트림 **eat**를 인코딩해보죠. 하위 범위 **0.3부터 0.6** 안에 있는 (그러나 포함되진 않음) 첫 번째 심볼 **e**를 선택하고 이 하위 범위를 가지고 이전에 사용한 것과 동일한 비율로 분할해 새로운 범위 내에서 다시 분할합니다.  

![second sub range](/i/second_subrange.png "second sub range")

스트림 **eat**를 이어서 인코딩 해봅시다. 새로운 하위 범위 **0.3부터 0.39**에 포함된 두 번째 심볼 **e**를 취한 뒤 마지막 심볼 **t**로 동일한 과정을 반복하여 마지막 하위 범주인 **0.354부터 0.372**를 얻게됩니다.  

![final arithmetic range](/i/arithimetic_range.png "final arithmetic range")

마지막 하위 범위인 **0.354부터 0.372**내에 있는 숫자를 선택해봅시다. **0.36**을 골라보죠. 이 하위 범주에 내에 있는 수라면 어떤 것이든 상관 없습니다. 그리고 **이 숫자만 있으면** 원본 스트림인 **eat**를 복구할 수 있습니다. 이는 스트림을 인코딩할 범위의 범위 안에 선을 긋는 것과 같습니다.  

![final range traverse](/i/range_show.png "final range traverse")

**역과정** (소위 말하는 디코딩)은 인코딩과 동일하게 간단합니다. 선택했던 숫자인 **0.36**으로 동일한 과정을 통하여 원래의 범위를 구하는데, 이번에는 이 숫자를 인코딩된 스트림을 밝혀내는데 사용합니다.

첫 번째 범위에서 앞서 선택한 숫자(0.36)가 슬라이스와 일치한다는 사실을 알 수 있습니다. 그러므로 이게 첫 번째 심볼이며 이제 하위 범위로 분할할 차례입니다. 이전과 동일한 과정으로 **0.36**이 심볼 **a**와 일치한다는 사실을 파악할 수 잇죠. 이 과정을 반복하고 나면 마지막 심볼인 **t**에 이르게 됩니다. (원본의 인코딩 된 스트림 *eat*를 구성함) 

엔코더와 디코더 모두 심볼 확률 테이블에 대해 **반드시 알고 있어야 합니다.** 그러므로 이 테이블도 보내야겠죠.

깔끔하쥬? 그쥬? 이 해법을 떠올린 사람들은 겁나 똑똑합니다. 몇몇 [비디오 코덱](https://en.wikipedia.org/wiki/Context-adaptive_binary_arithmetic_coding)은 이 기법을 사용합니다. (적어도 이를 옵션으로 제공하거나 말이죠)

이 아이디어는 무손실로 양자화된 비트스트림을 압축하는 것입니다. 이 글은 아주 많은 세부사항, 이유, 절충안 등등이 생략되어 있습니다. 그러나 개발자로서 [더 배우셔야 합니다](https://www.amazon.com/Understanding-Compression-Data-Modern-Developers/dp/1491961538/). 최신 코덱은 다른 종류의 [ANS와 같은 엔트로피 코딩 알고리즘](https://en.wikipedia.org/wiki/Asymmetric_Numeral_Systems)을 사용하려는 시도를 하고 있습니다.  

> ### 예제: CABAC vs CAVLC
> [CABAC와 CAVLC 이 두 개의 스트림을 생성](https://github.com/leandromoreira/introduction_video_technology/blob/master/encoding_pratical_examples.md#cabac-vs-cavlc)하고 각각의 스트림이 생성하는데 소모하는 **시간을 비교**해 보세요. 또, **결과물의 사이즈도** 비교해보세요.  

## 여섯번째 단계 - 비트 스트림 포맷

이 모든 과정을 마친 후에는 **압축된 프레임과 이 과정들에 대한 컨텍스트를 패킹**해야합니다. **엔코더가 결정한 내용들**, 가령 비트 깊이, 색공간, 해상도, 프리딕션 정보(모션 벡터, 인트라 프리딕션 방향), 프로파일, 레벨, 프레임레이트, 프레임 타입, 프레임 넘버 등의 무수히 많은 정보들에 대하여 디코더에게 이를 명시적으로 알려주어야 합니다. 

이제 겉핥기로 H.264 비트스트림을 공부해볼거에요. 첫 번째 단계는 [미니멀한 H.264 <sup>*</sup> 비트스트림](/encoding_pratical_examples.md#generate-a-single-frame-h264-bitstream)을 생성하는 것으로, 이 저장소와 [ffmpeg](http://ffmpeg.org/)를 사용하면 되지요.  

```
./s/ffmpeg -i /files/i/minimal.png -pix_fmt yuv420p /files/v/minimal_yuv420.h264
```

> <sup>*</sup> ffmpeg는 기본 값으로 모든 인코딩 파라미터에 **SEI NAL**을 붙이는데 NAL이 무엇인지 곧 정의 해볼 것입니다.  

이 명령어는 **단일 프레임**, 64x64, 색공간 yuv420의 로우 h264 비트스트림을 생성하며 프레임으로는 다음 이미지를 사용할거에요.   

> ![used frame to generate minimal h264 bitstream](/i/minimal.png "used frame to generate minimal h264 bitstream")

### H.264 비트스트림

AVC(H.264) 표준은 **[NAL](https://en.wikipedia.org/wiki/Network_Abstraction_Layer)** (네트워크 추상 계층)이라 부르는 **매크로 프레임** (네트워크 용어)에 전송하는 정보를 정의합니다. NAL의 주된 목적은 "네트워크 친화적"인 비디오 표현의 프로비전으로, 이 표준은 반드시 TV(스트림 기반), 인터넷(패킷 기반) 등을 비롯한 것들에서 반드시 동작해야합니다.  

![NAL units H.264](/i/nal_units.png "NAL units H.264")

NAL 유닛의 경계를 정의하는 [동기화 마커](https://en.wikipedia.org/wiki/Frame_synchronization)라는 것이 있습니다. 각 동기화 마커는 맨 첫 번째인 `0x00 0x00 0x00 0x01`를 제외하고 `0x00 0x00 0x01`의 값을 가집니다. 앞서 생성한 h264 비트스트림에 **hexdump**를 떠보면, 파일 시작 부분에 세계의 `NAL`을 확인할 수 있습니다.  

![synchronization marker on NAL units](/i/minimal_yuv420_hex.png "synchronization marker on NAL units")

앞서 말씀드린 바와 같이, 디코더는 사진 정보 뿐만 아니라 비디오의 세부사항, 색, 사용된 파라미터 등의 여러 정보를 필요로 합니다. 각 NAL의 **첫 번째 바이트**는 이에 대한 카테고리와 **타입**을 정의합니다.  

| NAL type id  | Description  |
|---  |---|
| 0  |  정의되지 않음 |
| 1  |  인코딩된 non-IDR 사진 슬라이스 |
| 2  |  인코딩된 슬라이스 데이터 파티션 A |
| 3  |  인코딩된 슬라이스 데이터 파티션 B |
| 4  |  인코딩된 슬라이스 데이터 파티션 C |
| 5  |  **IDR** 인코딩의 IDR 사진 슬라이스 |
| 6  |  **SEI** 추가 보완 정보 |
| 7  |  **SPS** 시퀀스 파라미터 셋 |
| 8  |  **PPS** 사진 파라미터 셋 |
| 9  |  엑세스 단위 델리미터 |
| 10 |  시퀀스의 끝 |
| 11 |  스트림의 끝 |
| ... |  ... |

보편적으로 비트스트림의 첫 번째 NAL은 **SPS**입니다. 이 타입은 **프로파일**, **레벨**, **해상도** 등과 같은 일반적인 인코딩 변수를 알려주는 역할을 합니다.  

동기화 마커를 건너 뛰는 경우 **첫 번째 바이트**를 디코드하여 **어떤 타입의 NAL**이 첫 번째 바이트인지 알아낼 수 있습니다.  

동기화 마커 다음의 첫 번째 바이트는 `01100111`입니다. 이 첫 번째 비트(`0`)는 **forbidden_zero_bit**에 해당하며, 다음 2비트(`11`)는 해당 필드가 이 NAL이 레퍼런스 필드인지 아닌지를 가리키는 **nal_ref_idc**를 알려주며, 나머지 5비트(`00111`)은 `nal_unit_type` 필드를 알려줍니다. 이 경우에는 **SPS** (7) NAL 유닛입니다.  

SPS NAL의 두 번째 바이트(`binary=01100100, hex=0x64, dec=100`)는 인코더가 사용한 프로파일을 보여주는 **profile_idc** 필드로, 이 경우에는 **[constrained high-profile](https://en.wikipedia.org/wiki/H.264/MPEG-4_AVC#Profiles)** 를 사용했습니다. 이는 B(bi-predictive) 슬라이스의 지원이 없는 하이프로파일입니다.  

![SPS binary view](/i/minimal_yuv420_bin.png "SPS binary view")

SPS NAL에 대한 H.264 비트스트림 스펙을 읽는 경우, **파라미터 이름**, **카테고리** 그리고 **디스크립션**에 대한 많은 값을 참고할 것입니다. 예를들어 `pic_width_in_mbs_minus_1`와 `pic_height_in_map_units_minus_1`필드를 봅시다.

| Parameter name  | Category  |  Description  |
|---  |---|---|
| pic_width_in_mbs_minus_1 |  0 | ue(v) |
| pic_height_in_map_units_minus_1 |  0 | ue(v) |

> **ue(v)**: unsigned integer [Exp-Golomb-coded](https://pythonhosted.org/bitstring/exp-golomb.html)

이 필드들의 값으로 계산을 때려보면, **해상도**에 이르게 됩니다. `119 ( (119 + 1) * macroblock_size = 120 * 16 = 1920) `의 값과 `pic_width_in_mbs_minus_1`를 사용하여 `1920 x 1080`를 표현할 수 있습니다. `1920`을 인코딩하는 대신 `119`를 사용하여 또 공간을 절약한것이지요.  

바이너리 뷰(ex: `xxd -b -c 11 v/minimal_yuv420.h264`)로 앞서 생성한 비디오를 계속하여 검사하는 경우, frame 자체를 의미하는 마지막 NAL은 생략할 수 있습니다.  

![h264 idr slice header](/i/slice_nal_idr_bin.png "h264 idr slice header")

앞서 생성한 비디오의 첫 번째 6바이트의 값을 볼 수 있습니다: `01100101 10001000 10000100 00000000 00100001 11111111`. 이미 아는 바와 같이 첫 번째 바이트는 NAL의 타입을 의미하며, 이 경우에는 (`00101`)이며 이는 **IDR Slice (5)** 이고 더 자세히 확인해보면:  

![h264 slice header spec](/i/slice_header.png "h264 slice header spec")

스펙 정보를 바탕으로 슬라스의 타입(**slice_type**), 프레임 번호(**frame_num**)을 비롯한 다른 중요한 필드들을 디코딩할 수 있습니다.  

몇몇 필드(`ue(v), me(v), se(v) 혹은 te(v)`)의 값을 얻기 위해, [Exponential-Golomb](https://pythonhosted.org/bitstring/exp-golomb.html)라 부르는 특별한 디코더를 사용하여 이를 디코딩할 수 있습니다. 이 방법은 대부분 수많은 기본 값들이 존재하는 경우에 **변수 값을 인코딩하는데에 있어 매우 효과적입니다.**

> **slice_type**의 값과 이 비디오의 **frame_num**는 각각 7(I slice)과 0 (첫 번째 프레임)입니다.

**비트스트림을 프로토콜**로 볼 수 있으며 이 비트스트림에 대하여 더 공부하고 싶으시다면 [ITU H.264 spec.](http://www.itu.int/rec/T-REC-H.264-201610-I)를 살펴보세요. 다음은 사진 데이터(압축된 YUV)가 어디에 위치하는지 나타내는 매크로 다이어그램입니다.  

![h264 bitstream macro diagram](/i/h264_bitstream_macro_diagram.png "h264 bitstream macro diagram")

[VP9 bitstream](https://storage.googleapis.com/downloads.webmproject.org/docs/vp9/vp9-bitstream-specification-v0.6-20160331-draft.pdf), [H.265 (HEVC)](http://handle.itu.int/11.1002/1000/11885-en?locatt=format:pdf)와 같은 다른 비트스트림에 대해서도 살펴볼 수 있습니다. 혹은 우리의 새 베프 [**AV1** bitstream](https://medium.com/@mbebenita/av1-bitstream-analyzer-d25f1c27072b#.d5a89oxz8
)도 말이죠. [모든 비트스트림들이 비슷할까요? 응 아니야](http://www.gpac-licensing.com/2016/07/12/vp9-av1-bitstream-format/), 하지만 한 번 터득하고 나면 다른 것들도 쉽게 배울 수 있습니다.  

> ### 실습: H.264 비트스트림 살펴보기
> [단일 프레임의 비디오를 만들고](https://github.com/leandromoreira/introduction_video_technology/blob/master/encoding_pratical_examples.md#generate-a-single-frame-video) [mediainfo](https://en.wikipedia.org/wiki/MediaInfo)를 사용하여 생성한 비디오의 H.264 비트스트림을 조사해볼 수 있습니다. 게다가 [h264(AVC)를 파싱하는 소스코드](https://github.com/MediaArea/MediaInfoLib/blob/master/Source/MediaInfo/Video/File_Avc.cpp)도 볼 수 있지요.  
> 
> ![mediainfo details h264 bitstream](/i/mediainfo_details_1.png "mediainfo details h264 bitstream")
>
> [Intel Video Pro Analyzer](https://software.intel.com/en-us/intel-video-pro-analyzer)는 유료이긴 하지만 트라이얼 버전에서는 초반의 10프레임 제한으로 사용해보실 수 있습니다. 학습 용도로는 충분합니다.  
>
> ![intel video pro analyzer details h264 bitstream](/i/intel-video-pro-analyzer.png "intel video pro analyzer details h264 bitstream")

## 리뷰

**현대 코덱의 대부분은 지금까지 학습한 것과 동일한 모델을 사용한다는 사실**을 명심해주세요. 실제로 Thor 비디오 코덱의 블록 다이어 그램을 살펴봅시다. 여기에는 앞서 학습한 모든 단계가 포함되어 있습니다. 이 아이디어는 이 분야에 대한 혁신과 논문들에 대해 최소한의 이해를 필요로 합니다.  

![thor_codec_block_diagram](/i/thor_codec_block_diagram.png "thor_codec_block_diagram")

이전에 계산했던 [한 시간 분량의 720p 해상도를 가진 30fps 비디오를 저장하기 위해 139GB의 용량](#%ED%81%AC%EB%A1%9C%EB%A7%88-%EC%84%9C%EB%B8%8C%EC%83%98%ED%94%8C%EB%A7%81)이 필요했었습니다. 여기서 배운 **인터 프리딕션, 인트라 프리딕션, 변환, 양자화, 엔트로피 코딩 등**의 기법을 사용하면, 대략 **픽셀 당 0.031비트**를 소비하며, 볼 수 있을만한 수준의 품질의 비디오에 **139GB와 달리 367.82MB의 용량만을 필요로** 합니다. 

> 여기서 제공된 예제 비디오를 기반으로 **픽셀 당 0.031비트**를 사용하도록 선택하였습니다.

## 어떻게 H.265는 H.264보다 더 높은 압축률을 달성했는가

이제 코덱이 어떻게 동작하는지에 대해 많이 배웠으니, 새로운 코덱들이 적은 비트를 가지고 더 높은 해상도를 제공하는 방법들에 대해 쉽게 이해하실 수 있을거에요.  

AVC와 HEVC를 비교해볼텐데요, CPU 싸이클(복잡도)와 압축률 간에는 항상 트레이드 오프가 존재한다는 사실을 명심하세요.  

HEVC는 AVC에 비해 더 크고 더 많은 **파티션(그리고 서브 파티션)** 옵션, **인트라 프리딕션 방향**, **향상된 엔트로피 코딩** 등을 가지고 있습니다. 이러한 모든 향상은 H.265가 H.264보다 50% 높은 압축 성능을 발휘할 수 있게 해주었죠.  

![h264 vs h265](/i/avc_vs_hevc.png "H.264 vs H.265")

# 온라인 스트리밍
## 일반적인 아키텍쳐

![general architecture](/i/general_architecture.png "general architecture")

[TODO]

## 점진적 다운로드와 적응형 스트리밍

![progressive download](/i/progressive_download.png "progressive download")

![adaptive streaming](/i/adaptive_streaming.png "adaptive streaming")

[TODO]

## 컨텐츠 보호

**간단한 토큰 시스템**을 사용하여 컨텐츠를 보호할 수 있습니다. 토큰이 없는 사용자가 비디오를 요청하면 CDN은 사용자를 막고, 유효한 토큰을 지닌 사용자라면 컨텐츠를 재생할 수 있도록 말이죠. 이는 대부분의 웹 인증 시스템과 굉장히 유사합니다.  

![token protection](/i/token_protection.png "token_protection")

이 토큰 시스템만 사용하면 사용자가 비디오를 다운로드 받아 배포가 가능합니다. 그러나 **DRM(디지털 저작권 관리)** 시스템은 이를 막을 수 있습니다.  

![drm](/i/drm.png "drm")

실제 현업의 시스템과 실무자들은 두 기법을 사용하여 인증과 인가를 제공합니다.   

### DRM
#### Main systems

* FPS - [**FairPlay Streaming**](https://developer.apple.com/streaming/fps/)
* PR - [**PlayReady**](https://www.microsoft.com/playready/)
* WV - [**Widevine**](http://www.widevine.com/)


#### 무엇인가?

DRM은 디지털 저작권 관리를 의미하며, **디지털 미디어에 대한 권리 보호**를 제공합니다. 많은 곳에서 사용되고 있으나 [보편적으로는 수긍받지 못하고 있습니다](https://en.wikipedia.org/wiki/Digital_rights_management#DRM-free_works).

#### 왜?

컨텐츠 제작자(대부분 스튜디오들)들은 저작물의 무단 배포를 막아 자신의 지적 재산권을 보호하고자 합니다.    

#### 어떻게?

극도로 간략화된 DRM의 추상적이고 일반적인 형태만 소개할 것입니다.  

**컨텐츠 C1**(예를들어 HLS나 dash 비디오 스트리밍)을 **DRM 시스템 DRM1**(와이드바인, 플레이레디, 페어플레이)을 사용하는 **디바이스 D1**(예를들어 스마트폰, TV, 태블릿, 데스크탑, 노트북)에서 **플레이어 P1**(예를들어 샤카 클래퍼, 엑소 플레이어, ios)로 본다고 해봅시다.  

컨텐츠 C1은 시스템 DRM1의 **대칭키 K1**으로 암호화되어 **암호화된 컨텐츠 C'1**을 생성합니다.  

![drm general flow](/i/drm_general_flow.jpeg "drm general flow")

디바이스 D1의 플레이어 P1은 **개인키 PRK1**(이 키는 보호되어 있으며<sup>1</sup> **D1**만 알고 있음)와 **공개키 PUK1**라는 두 개의 키(비대칭)를 가지고 있습니다.  

> **<sup>1</sup>보호됨**: [블랙박스](https://en.wikipedia.org/wiki/Black_box)처럼 동작하는 내부의 특별한(읽기 전용) 칩에 저장된 키로 해독을 제공하는 **하드웨어를 통한** 방법이 있고, 혹은 DRM 시스템이 제공하는 **소프트웨어를 통한**(덜 안전함) 방법이 있습니다. 이 보호는 해당 디바이스가 어떤 방법(하드웨어적, 소프트웨어적)을 가지고 있는지 알 수 있습니다.  

**플레이어 P1이 컨텐츠 C'1을 보고 싶은 경우**, 공개키 **PUK1**를 부여한 **DRM 시스템 DRM1**를 통해 처리해야합니다. DRM시스템 DRM1는 클라이언트의 공개키 **PUK1**를 가지고 **암호화된 키 K1**을 반환합니다. 이론적으로 이 응답은 **D1만이 해독할 수 있습니다**.

`K1P1D1 = enc(K1, PUK1)`

**P1**은 DRM 로컬 시스템([SOC](https://en.wikipedia.org/wiki/System_on_a_chip)가 해당될 수 있으며, 특화된 하드웨어나 소프트웨어)을 사용하며, 이 시스템은 개인키 PRK1을 사용한 컨텐츠를 **해독 가능**합니다. **K1P1D1로부터 비대칭 키 K1**를 해독할 수 있으며 **C'1을 재생할 수 있습니다**. 가장 좋은 점은 RAM을 통해 이 키들이 노출이 되지 않는 다는 것이지요.  

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
