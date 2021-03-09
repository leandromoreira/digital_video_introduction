[![license](https://img.shields.io/badge/license-BSD--3--Clause-blue.svg)](https://img.shields.io/badge/license-BSD--3--Clause-blue.svg)

# はじめに

これは、ビデオ技術に関するやさしい解説資料です。ソフトウェア開発者やエンジニアを対象にしていますが、**誰でも理解できる**解説にしたいと思っています。このアイディアは、[ビデオ技術初学者のためのミニワークショップ](https://docs.google.com/presentation/d/17Z31kEkl_NGJ0M66reqr9_uTG6tI5EDDVXpdPKVuIrs/edit#slide=id.p)から生まれました。

できるだけ**簡潔な言葉、多くの視覚的要素、具体的な例**を使うことで、誰でもデジタルビデオの概念が理解できることを目標にしています。気軽に訂正や提案を送り、改善してください。

本資料には**ハンズオン**による解説が含まれています。ハンズオンに取り組む方は、事前にdockerをインストールし、このレポジトリをクローンしておいてください。

```bash
git clone https://github.com/leandromoreira/digital_video_introduction.git
cd digital_video_introduction
./setup.sh
```
> **注意**: `./s/ffmpeg` や `./s/mediainfo` コマンドは、そのプログラムが**Dockerコンテナ上**で実行されることを意味しています。コンテナの中には、必要な依存関係が全て含まれています。

**ハンズオンはすべて、このレポジトリをクローンしたフォルダで実行してください**。 **jupyter examples**については、`./s/start_jupyter.sh`でサーバーを起動して、表示されるURLをブラウザで開いてください。

# 変更履歴

* DRMシステムの追加
* 1.0.0版のリリース
* 簡体字訳の追加
* FFmpeg oscilloscopeフィルターの例を追加

# 目次

- [はじめに](#はじめに)
- [目次](#目次)
- [基本用語](#基本用語)
  * [カラー画像を符号化する別の方法](#カラー画像を符号化する別の方法)
  * [ハンズオン: 画像と色の実験](#ハンズオン-画像と色の実験)
  * [DVDの画面アスペクト比は4:3](#dvdの画面アスペクト比は43)
  * [ハンズオン: ビデオプロパティを調べる](#ハンズオン-ビデオプロパティを調べる)
- [冗長性除去](#冗長性除去)
  * [色、明るさと私たちの目](#色、明るさと私たちの目)
    + [カラーモデル](#カラーモデル)
    + [YCbCrとRGB間の変換](#ycbcrとrgb間の変換)
    + [クロマサブサンプリング](#クロマサブサンプリング)
    + [ハンズオン: YCbCrヒストグラムを調べる](#ハンズオン-ycbcrヒストグラムを調べる)
  * [フレームの種類](#フレームの種類)
    + [Iフレーム (イントラ、キーフレーム)](#iフレーム-イントラ、キーフレーム)
    + [Pフレーム (予測)](#pフレーム-予測)
      - [ハンズオン: Iフレームが１つだけのビデオ](#ハンズオン-iフレームが１つだけのビデオ)
    + [Bフレーム (双方向予測)](#bフレーム-双方向予測)
      - [ハンズオン: Bフレーム付きのビデオとの比較](#ハンズオン-bフレーム付きのビデオとの比較)
    + [まとめ](#まとめ)
  * [時間的冗長性 (インター予測)](#時間的冗長性-インター予測)
      - [ハンズオン: 動きベクトルを見る](#ハンズオン-動きベクトルを見る)
  * [空間的冗長性 (イントラ予測)](#空間的冗長性-イントラ予測)
      - [ハンズオン: イントラ予測を調べる](#ハンズオン-イントラ予測を調べる)
- [ビデオコーデックの仕組み](#ビデオコーデックの仕組み)
  * [何か? なぜ? どのように?](#何か-なぜ-どのように)
  * [歴史](#歴史)
    + [AV1の誕生](#av1の誕生)
  * [一般的コーデック](#一般的コーデック)
  * [ステップ１ - 画像分割](#ステップ１---画像分割)
    + [ハンズオン: パーティションを調べる](#ハンズオン-パーティションを調べる)
  * [ステップ２ - 予測](#ステップ２---予測)
  * [ステップ３ - 変換](#ステップ３---変換)
    + [ハンズオン: 種々の係数を捨てる](#ハンズオン-種々の係数を捨てる)
  * [ステップ４ - 量子化](#ステップ４---量子化)
    + [ハンズオン: 量子化](#ハンズオン-量子化)
  * [ステップ５ - エントロピー符号化](#ステップ５---エントロピー符号化)
    + [可変長符号](#可変長符号)
    + [算術符号](#算術符号)
    + [ハンズオン: CABAC対CAVLC](#ハンズオン-cabac対cavlc)
  * [ステップ６ - ビットストリームフォーマット](#ステップ６---ビットストリームフォーマット)
    + [H.264ビットストリーム](#h264ビットストリーム)
    + [ハンズオン: H.264ビットストリームを調べる](#ハンズオン-h264ビットストリームを調べる)
  * [おさらい](#おさらい)
  * [どのようにH.265はH.264よりも良い圧縮率を実現しているのか?](#どのようにh265はh264よりも良い圧縮率を実現しているのか)
- [オンラインストリーミング](#オンラインストリーミング)
  * [一般的なアーキテクチャ](#一般的なアーキテクチャ)
  * [プログレッシブダウンロードとアダプティブストリーミング](#プログレッシブダウンロードとアダプティブストリーミング)
  * [コンテンツ保護](#コンテンツ保護)
- [jupyterの使い方](#jupyterの使い方)
- [カンファレンス](#カンファレンス)
- [参考文献](#参考文献)

# 基本用語

**画像**は、**二次元マトリクス**として考えることができます。さらに次元を増やして**三次元マトリクス**にすることで画像の色を表現することも可能です。

画像の色を[原色 (赤、緑、青)](https://ja.wikipedia.org/wiki/%E5%8E%9F%E8%89%B2)で表現すると、三つの平面を定義することになります。一つめが**赤**、二つ目が**緑**、そして三つ目が**青**です。

![an image is a 3d matrix RGB](/i/image_3d_matrix_rgb.png "画像は三次元マトリクスです")

マトリクスのそれぞれの要素を**ピクセル** (画素)と呼びます。一つのピクセルはその色の**強度** (通常は数値)を表します。例えば、**赤色のピクセル**は、緑が0、青が0、赤が最大の強度により表現できます。**ピンク色のピクセル**も同様に3つの値で表現できます。0から255の数値で表現することにより、ピンクピクセルは**赤=255、緑=192、青=203**と定義できます。

> #### カラー画像を符号化する別の方法
> 色を表現する方法は、他にもたくさんあります。例えば、RGBモデルでは各ピクセルで3バイトを必要としますが、インデックスパレットは1バイトしか必要ありません。そういったモデルでは、色を表現するために三次元モデルを使わずに二次元モデルを使用できるでしょう。メモリを節約できますが、色の選択肢を狭めることになります。
>
> ![NES palette](/i/nes-color-palette.png "ファミコンパレット")

例えば、下の画像をみてください。1番左の画像は色付けされており、他の画像は赤、緑、青の強度を表す平面です(グレートーンで表示しています)。

![RGB channels intensity](/i/rgb_channels_intensity.png "RGB要素の輝度")

**赤色**が最も多く使われていることが分かります(左から二番目の顔の最も明るい部分)。一方**青色** は服の一部と**マリオの目にしかみられません**(最後の顔) 。**マリオのひげ**に対しては、**どの色もあまり使われていない**(最も暗い部分)ことが分かります。

各色の強度は**ビット深度**とよばれる一定量のビットで表現されます。色(平面)ごとに**8ビット**(0から255の値で表現する)を使う場合、**24ビット**(8ビット x 3次元 R/G/B)の**色深度**を持つことになり、2の24乗種類の色を使えることが推測できます。

> [画像がどのように万物をビットとしてとらえるのか](http://www.cambridgeincolour.com/tutorials/camera-sensors.htm)を学ぶと **良い**でしょう 

もう一つの画像のプロパティは **解像度**です。解像度は長さあたりのピクセルの数です。解像度はよく幅 x 高さとして表現されます。例えば、下記は**4×4**の画像です。

![image resolution](/i/resolution.png "画像解像度")

> #### ハンズオン: 画像と色の実験
>  [jupyter](#jupyterの使い方) (python、numpy、matplotlib、その他)を使って、[画像と色の実験](/image_as_3d_array.ipynb)をしましょう。
>
> [(エッジ検出, シャープ化, ぼかし等の)画像フィルタがどのように動くか](/filters_are_easy.ipynb)を学びましょう。

画像やビデオの作業をする時にみるもう一つのプロパティは **アスペクト比**です。アスペクト比は、画像やピクセルの幅と高さの比率を表します。

動画や画像が**16x9**であると言うときは、たいてい**画面アスペクト比 (DAR)** のことを指します。しかし、個々のピクセルを様々な形状にすることができ、これを **ピクセルアスペクト比 (PAR)** といいます。

![display aspect ratio](/i/DAR.png "画面アスペクト比")

![pixel aspect ratio](/i/PAR.png "ピクセルアスペクト比")

> #### DVDの画面アスペクト比は4:3
> DVDの実際の解像度は704x480ですが、10:11のピクセルアスペクト比を持っているため、4:3のアスペクト比を保っています(704x10/480x11)。

最後に、**ビデオ**を**単位時間**内の***n*フレームの並び**として定義でき、もう一つの特性と見ることができます。*n*はフレームレートもしくは秒間フレーム数 (FPS)です。

![video](/i/video.png "ビデオ")

ビデオを表すために必要な秒間あたりのビット数は**ビットレート**です。

> ビットレート = 幅 x 高さ x ビット深度 x フレームレート

例えば、圧縮を全く使わないなら、フレームレートが30で、ピクセルあたりが24ビットで、解像度が480x240のビデオは、**秒間あたり82,944,000ビット**もしくは82.944 Mbps (30x480x240x24)が必要です。

**ビットレート**がほとんど一定なら、固定ビットレート(**CBR**)と呼ばれます。ビットレートが変動するなら、可変ビットレート (**VBR**)と呼ばれます。

> このグラフはフレームが真っ黒の間はあまりビットを使わない、制約付きのVBRを示しています。
>
> ![constrained vbr](/i/vbr.png "制約付きのvbr")

黎明期に、技術者たちが**帯域幅を増やさずに**ビデオ画面で認識できるフレームレートを倍にする技術を思いつきました。この技術は**インターレース動画**として知られています。基本的には一つ目の「フレーム」で画面の半分を送り、次の「フレーム」で残りの半分を送ります。

今日では **プログレッシブスキャン技術**を使って画面に描画されます。プログレッシブは、動画を描画、保存、転送する手段の一つで、各フレームの全走査線を順番に描画します。

![interlaced vs progressive](/i/interlaced_vs_progressive.png "インターレース対プログレッシブ")

これで**画像**がどのようにデジタル表現されるのかが分かりました。**色**がどのように配置され、ビデオを表すのにどのくらいの**秒間あたりのビット**が必要なのか、それが固定なのか(CBR)可変なのか(VBR)、**解像度**と**フレームレート**、他にもインターレースやピクセルアスペクト比、その他のたくさんの用語を学びました。

> #### ハンズオン: ビデオプロパティを調べる
> [ffmpegやmediainfoを使って説明したプロパティのほとんどを調べる](https://github.com/leandromoreira/introduction_video_technology/blob/master/encoding_pratical_examples.md#inspect-stream)ことができます。

# 冗長性除去

圧縮なしにビデオを扱うことは不可能であることを学びました。解像度が720pで30fpsの場合、**1時間のビデオ一つ**に**278GB<sup>*</sup>が必要**です。(PKZIP、Gzip、PNGで使われている)DEFLATE のような**可逆圧縮アルゴリズム一つを使うだけでは**必要な帯域幅を十分に削減**できない**ため、ビデオを圧縮する別の方法を見つける必要があるのです。

> <sup>*</sup> この数値は1280 x 720 x 24 x 30 x 3600 (幅、高さ、ピクセルあたりのビット数、フレームレート、秒単位での時間)を掛けることで算出しました

これを成し遂げるために、**私たちの視覚の仕組みを利用する**ことができます。私たちは色よりも明るさを見分けることが得意です。また、ビデオには少しの変化しかない多くの画像が含まれている**時間的繰り返し**があります。それぞれのフレームもまた、多くの領域では同じか似ている色が使われている**画像内の繰り返し**があります。

## 色、明るさと私たちの目

私たちの目は[色よりも明るさにより敏感](http://vanseodesign.com/web-design/color-luminance/)です。この画像をみてそれを自分自身で確認できます。

![luminance vs color](/i/luminance_vs_color.png "明るさ 対 色")

左側の**正方形Aと正方形B**の色は**同じ**であることが分からないとしても大丈夫です。私たちの脳は**色よりも明暗に注意をはらう**ことで錯覚を起こさせているのです。右側では、同じ色のコネクターがあるため、私たち（私たちの脳）は、それらは実際は同じ色であるということを簡単に気づきます。

> **私たちの目がどのように機能するかの簡単な説明**
>
> [眼は複雑な器官](http://www.biologymad.com/nervoussystem/eyenotes.htm)で、たくさんのパーツから成り立っていますが、主に錐体細胞と桿体細胞に関心があります。眼は [1億2000万の桿体細胞と600万の錐体細胞を含んでいる](https://en.wikipedia.org/wiki/Photoreceptor_cell)のです。
>
> **ものすごく簡単にする**ため、眼のパーツの機能のうち色と明るさに焦点を当てましょう。**[桿体細胞](https://en.wikipedia.org/wiki/Rod_cell)は主に明るさに対して責任を持っています**。一方 **[錐体細胞](https://en.wikipedia.org/wiki/Cone_cell)は色に対して責任を持っています**。異なった色素を持つ3種類の錐体があり、名前は[S錐体(青)、M錐体(緑)、L錐体(赤)](https://upload.wikimedia.org/wikipedia/commons/1/1e/Cones_SMJ2_E.svg)です。
>
> 私たちは錐体細胞(色)よりも多くの桿体細胞(明るさ)を持っているため、色よりも明暗をより識別することができることが推論できます。
>
> ![eyes composition](/i/eyes.jpg "眼の構成")

私たちは**輝度**(画像の明るさの度合い)により敏感であることが分かりました。この特性を利用しましょう。

### カラーモデル

**RGBモデル**を使って[カラー画像がどのように](#基本用語)機能するのか最初に学びましたが、他のモデルも存在します。実は、輝度(明るさ)と色度(色)を別にするモデルが存在します。それは**YCbCr**<sup>*</sup>として知られています。

> <sup>*</sup> 同じ分離を行うモデルはもっと存在します。

このカラーモデルは明るさを表すために**Y**を使い、２つの色チャンネル**Cb** (青の色差)と**Cr** (赤の色差)を使います。[YCbCr](https://en.wikipedia.org/wiki/YCbCr)はRGBから生成することができ、RGBに戻すこともできます。下の写真のように、このモデルを使ってフルカラーの画像を作ることができます。

![ycbcr example](/i/ycbcr.png "ycbcr例")

### YCbCrとRGB間の変換

中には **緑なしで色**の全てを生成できるのかと異議を唱える方もいるでしょう。

この質問に答えるために、RGBからYCbCrへの変換を一通り説明します。**[ITU-Rグループ<sup>*</sup>](https://en.wikipedia.org/wiki/ITU-R)** によって推奨される **[BT.601標準](https://en.wikipedia.org/wiki/Rec._601)** からの係数を使います。最初のステップは、**輝度を計算する**ことです。ITUに提案されている定数を使い、RGB値を置き換えます。

```
Y = 0.299R + 0.587G + 0.114B
```

輝度をえると次に、**色を分ける** (青の色差と赤の色差)ことができます。

```
Cb = 0.564(B - Y)
Cr = 0.713(R - Y)
```

それを**戻す**ことができ、**YCbCrを使って緑**を得ることもできます。

```
R = Y + 1.402Cr
B = Y + 1.772Cb
G = Y - 0.344Cb - 0.714Cr
```

> <sup>*</sup> グループや標準はデジタルビデオではよくでてきます。彼らは何が標準なのかを定義します。例えば[4Kとは何か？どのフレームレート、解像度、カラーモデルを使うべきか？](https://en.wikipedia.org/wiki/Rec._2020)などです。

一般的に**ディスプレイ** (モニター、テレビ、スクリーン等) は様々な方法で構成された**RGBモデルだけ**を利用します。下の写真でいくつか拡大したもの示しています。

![pixel geometry](/i/new_pixel_geometry.jpg "画素形状")

### クロマサブサンプリング

画像は輝度と色度成分で表現することができるので、人間の視覚システムが色度よりも輝度に敏感であることを利用して情報を選択的に削減することができます。**クロマサブサンプリング**は**色度の解像度を輝度の解像度より小さくする**画像符号化技術です。


![ycbcr subsampling resolutions](/i/ycbcr_subsampling_resolution.png "ycbcrサブサンプリング解像度")


色度の解像度をどのくらい小さくすべきでしょうか？！解像度と結合 (`最終的な色 = Y + Cb + Cr`)の仕方をどのようにするかを定義したいくつかの方式がすでに存在しています。

これらの方式はサブサンプリングシステムとして知られ、３つの部分からなる比`a:x:y`として表現されます。これは `a x 2`ブロックの輝度ピクセルに対する色度解像度を定義しています。

 * `a`：横方向のサンプルの基本数。通常は４。
 * `x`：1ライン目の`a`に現れる色信号サンプルの数。(`a`に対する水平解像度)
 * `y`：1ライン目と2ライン目での変化数

> 4:1:0は例外で、`4 x 4`ブロックの輝度に１つの色信号サンプルだけを含んでいます。

現代のコーデックでよく使われる方式は**4:4:4(サブサンプリング無し)**、**4:2:2、4:1:1、4:2:0、4:1:0、3:1:1**です。

> **YCbCr 4:2:0結合**
>
> これがYCbCr 4:2:0を使って結合された画像の断片です。１ピクセルに１２ビットしか使わないことに注意してください。
>
> ![YCbCr 4:2:0 merge](/i/ycbcr_420_merge.png "YCbCr 4:2:0結合")

クロマサブサンプリングの主要な形式で符号化された同じ画像を見て下さい。一行目の画像は最終的なYCbCrで、二行目の画像は色度解像度を示しています。実に小さな劣化で素晴らしい結果です。

![chroma subsampling examples](/i/chroma_subsampling_examples.jpg "クロマサブサンプリング例")

[解像度が720pで30fpsのビデオを1時間ファイルに保存するためには278GBの領域](#冗長性除去)が必要になることを先に計算しました。**YCbCr 4:2:0**を使うと、**半分のサイズ(139 GB)**<sup>*</sup>にすることができます。しかしまだ理想には程遠いです。

> <sup>*</sup> 幅、高さ、ピクセルごとのビット数、フレームレートを掛けることによりこの値を計算しました。先に計算した時は２４ビット必要でしたが、今は１２ビットしか必要ありません。

<br/>

> ### ハンズオン: YCbCrヒストグラムを調べる
> [ffmpegでYCbCrヒストグラムを調べる](/encoding_pratical_examples.md#generates-yuv-histogram)ことができます。 このシーンでは青の寄与率がより高くなっています。  [ヒストグラム](https://en.wikipedia.org/wiki/Histogram)でそのことが示されます。
>
> ![ycbcr color histogram](/i/yuv_histogram.png "ycbcrカラーヒストグラム")

### 色、輝度、明るさ、ガンマについての映像

輝度や明るさ、ガンマ、色について解説している素晴らしい動画があります。ぜひご覧ください。

[![Analog Luma - A history and explanation of video](http://img.youtube.com/vi/Ymt47wXUDEU/0.jpg)](http://www.youtube.com/watch?v=Ymt47wXUDEU)	[![Analog Luma - A history and explanation of video](http://img.youtube.com/vi/Ymt47wXUDEU/0.jpg)](http://www.youtube.com/watch?v=Ymt47wXUDEU)

> ### ハンズオン: YCbCr 強度を調べる
> [FFmpegのoscilloscope filter](https://ffmpeg.org/ffmpeg-filters.html#oscilloscope)を使って、映像のYの強度を可視化できます。
> ```bash
> ffplay -f lavfi -i 'testsrc2=size=1280x720:rate=30000/1001,format=yuv420p' -vf oscilloscope=x=0.5:y=200/720:s=1:c=1
> ```
> ![y color oscilloscope](/i/ffmpeg_oscilloscope.png "y color oscilloscope")

## フレームの種類

次に**時間的な冗長性**の削減を試みましょう。しかし、その前にいくつかの基本的用語について押さえておきましょう。30 fpsの動画があり、下記が最初の4フレームであるとします。

![ball 1](/i/smw_background_ball_1.png "ボール1") ![ball 2](/i/smw_background_ball_2.png "ボール2") ![ball 3](/i/smw_background_ball_3.png "ボール3")
![ball 4](/i/smw_background_ball_4.png "ボール4")

**青い背景**のようにフレーム間に**たくさんの繰り返し**を見ることができます。背景はフレーム0からフレーム3まで変化しません。この問題に取り組むために、これらを3種類のフレームに**抽象的に分類**しましょう。

### Iフレーム (イントラ、キーフレーム)

Iフレーム(参照、キーフレーム、イントラ)は**自己完結的なフレーム**です。Iフレームは他に依存せずに描画することができ、静止画と似ています。最初のフレームは普通はIフレームですが、他の種類のフレームの間にも規則的にIフレームが挿入されています。

![ball 1](/i/smw_background_ball_1.png "ボール1")

### Pフレーム (予測)

現在の画像は、ほとんど毎回**１つ前のフレームを使って描画する**ことができるという事実をPフレームは利用しています。例えば、2番目のフレームでは、ボールが前に動いたという変化しかありません。**1つ前のフレームを参照し、そのフレームとの差分だけを用いてフレーム1を再構築**できます。

![ball 1](/i/smw_background_ball_1.png "ボール1") <-  ![ball 2](/i/smw_background_ball_2_diff.png "ボール2")

> #### ハンズオン: Iフレームが１つだけのビデオ
> Pフレームはより小さなデータしか使わないので、全体を[Iフレームは１つだけで、他は全てPフレームのビデオ](/encoding_pratical_examples.md#1-i-frame-and-the-rest-p-frames)にエンコードしたらどうでしょう？
>
> このビデオをエンコードした後、再生してビデオの**前方にシーク**してください。シーク先に移るのに**時間がかかる**ことに気づくでしょう。これは、描画のために**Pフレームが参照フレームを必要とする** (例えばIフレーム)ためです。
>
> もう１つ手軽にできるテストとして、まず１つのI-Frameだけを使ってビデオをエンコードして、次に[２秒間隔でIフレームを挿入してエンコード](/encoding_pratical_examples.md#1-i-frames-per-second-vs-05-i-frames-per-second)してから、**それぞれのエンコード結果のサイズを比較**してください。

### Bフレーム (双方向予測)

過去と未来のフレーム両方を参照したら、さらに高い圧縮率を得ることができるのではないでしょうか？！それがBフレームの基本です。

![ball 1](/i/smw_background_ball_1.png "ボール1") <-  ![ball 2](/i/smw_background_ball_2_diff.png "ボール2") -> ![ball 3](/i/smw_background_ball_3.png "ボール3")

> #### ハンズオン: Bフレーム付きのビデオとの比較
> ２つの方法でエンコードしてみましょう。１つはBフレーム付きで、もう一方は[Bフレームなし](/encoding_pratical_examples.md#no-b-frames-at-all)でエンコードして、ファイルサイズおよび画質を確認してください。

### まとめ

これらの異なる種類のフレームは**より高い圧縮率を得る**ために使われます。次の節でどうやってこれが行われるのか見ていきます。しかし、今のところは**Iフレームは重く、Pフレームは比較的軽いですが、最も軽いのはBフレーム**と考えておいてよいでしょう。

![frame types example](/i/frame_types.png "フレームの種類の例")

## 時間的冗長性 (インター予測)

**時間的繰り返し**を削減するために何ができるか見ていきましょう。この種の冗長性は**インター予測**という技術で解決することができます。


**できるだけ少ないビットを使って**、連続したフレーム0とフレーム1をエンコードしてみましょう。

![original frames](/i/original_frames.png "元のフレーム")

１つできることとして、引き算があります。単純に**フレーム0からフレーム1を引く**と、**エンコード**する必要がある**差分**を得ることができます。

![delta frames](/i/difference_frames.png "差分フレーム")

しかし、さらに少ないビットしか使わない**もっとよい方法**があると言ったらどうでしょう！まず、`フレーム0`をきちんと定められた区画の集合であるとします。そして`フレーム0`のそれぞれのブロックを`フレーム1`上にマッチさせようとします。.これは **動き推定**として考えることができます。

> ### Wikipedia - ブロック動き補償
> "**ブロック動き補償**は現在のフレームを重ならないブロックに分けて、動き補償ベクトルは**これらのブロックがどこからのものかを表します** (前回のフレームが重ならないブロックに分けられ、動き補償ベクトルはこれらのブロックがどこへ行くかを表すというのは、よくある誤解です)。 元のブロックは元のフレーム内で通常は重なり合います。ビデオ圧縮アルゴリズムの中には、 すでに送信された異なったいくつかのフレームの断片から現在のフレームを組み立てるものもあります。"

![delta frames](/i/original_frames_motion_estimation.png "フレーム差分")

ボールが`x=0、y=25`から`x=6、y=26`へ移動したと推定することができます。**x**と**y**の値は**動きベクトル**です。ビットを節約するためのもう１つの**さらなるステップ**は、前回のブロック位置と予測されるブロック位置との**動きベクトルの差分だけをエンコードする**ことです。 最終的な動きベクトルは`x=6 (6-0)、y=1 (26-25)`のようになります。

> 実際には、この**ボールは分割されてn個の区画にまたがるでしょう**。しかし処理は同じです

フレーム上の物体は**3D空間で移動します**。ボールは背景の方に動くと小さくもなります。 **完全にマッチするブロックを見つけられない**ことはよくあります。 推定画像と実際の画像を重ねると下記のようになります。

![motion estimation](/i/motion_estimation.png "動き推定")

しかし、**動き推定**を適用すると、単純なフレーム差分手法を使うよりも**エンコードするデータがより小さくなる**ことが分かります。

![motion estimation vs delta ](/i/comparison_delta_vs_motion_estimation.png "動き推定 差分")

> ### 可視化された実際の動き補償
> この手法は全てのブロックに適用され、高い確率でボールは１つ以上のブロックに配置されます。
>  ![real world motion compensation](/i/real_world_motion_compensation.png "現実世界の動き補償")
> 引用元: https://web.stanford.edu/class/ee398a/handouts/lectures/EE398a_MotionEstimation_2012.pdf

[jupyterを使ってこれらの概念を実験](/frame_difference_vs_motion_estimation_plus_residual.ipynb)できます。

> #### ハンズオン: 動きベクトルを見る
> [ffmpegでインター予測 (動きベクトル)付きのビデオを生成する](/encoding_pratical_examples.md#generate-debug-video)ことができます。
>
> ![inter prediction (motion vectors) with ffmpeg](/i/motion_vectors_ffmpeg.png "ffmpegでインター予測 (動きベクトル)")
>
> または、[Intel Video Pro Analyzer](https://software.intel.com/en-us/intel-video-pro-analyzer) (有料ですが、最初の10フレームに制限された無料お試し版もあります)を使うこともできます。
>
> ![inter prediction intel video pro analyzer](/i/inter_prediction_intel_video_pro_analyzer.png "インター予測 intel video pro analyzer")

## 空間的冗長性 (イントラ予測)

ビデオの中の**1つ1つのフレーム**を分析すると、**たくさんの相関性のある領域**が存在することが分かります。

![](/i/repetitions_in_space.png)

例を通してみていきましょう。このシーンはほとんど青と白で構成されています。

![](/i/smw_bg.png)

これは `Iフレーム`で、予測のために**前のフレームを使えません**が、圧縮することはできます。赤いブロックを選択してエンコードしてみましょう。**隣接する部分を見る**と、**その周りの色に傾向**があることを**推定**することができます。

![](/i/smw_bg_block.png)

このフレームでは**色が垂直方向に広がり**続けることを**予測**してみます。**未知のピクセルの色が隣接するピクセルの色を持つ**ことを意味します。

![](/i/smw_bg_prediction.png)

**予測が間違うかもしれません**。そのため、この手法(**イントラ予測**)を適用してから、**実際の値を引いて**差分を生成する必要があります。その差分は予測前よりもさらに圧縮しやすいマトリクスになります。

![](/i/smw_residual.png)

> #### ハンズオン: イントラ予測を調べる
> [ffmpegでマクロブロックとそれらの予測付きのビデオを生成する](/encoding_pratical_examples.md#generate-debug-video)ことができます。[それぞれのブロックの色の意味](https://trac.ffmpeg.org/wiki/Debug/MacroblocksAndMotionVectors#AnalyzingMacroblockTypes)を理解するためにffmpegのドキュメントを調べてください。
>
> ![intra prediction (macro blocks) with ffmpeg](/i/macro_blocks_ffmpeg.png "ffmpegでインター予測 (動きベクトル)")
>
> または[Intel Video Pro Analyzer](https://software.intel.com/en-us/intel-video-pro-analyzer) (有料ですが、最初の10フレームに制限された無料お試し版もあります)を使うことができます。
>
> ![intra prediction intel video pro analyzer](/i/intra_prediction_intel_video_pro_analyzer.png "イントラ予測 intel video pro analyzer")

# ビデオコーデックの仕組み

## What? Why? How?

**What?** デジタルビデオを圧縮、解凍するソフトウェア / ハードウェアの部品。**Why?** 制限された帯域とストレージの下でより高い品質のビデオへの要求が、市場と社会で高まっているため。毎秒30フレーム、ピクセルあたり24ビット、解像度が480x240のビデオに[必要な帯域を計算](#基本用語)したのを覚えていますか。圧縮なしでは**82.944 Mbps**でした。テレビやインターネットでHD/FullHD/4Kを配信するためには圧縮するしかありません。**How?** ここで主な技法について簡単に見ていきます。

> **コーデック 対 コンテナ**
>
> 初心者がよく誤解することの１つに、デジタルビデオコーデックと[デジタルビデオコンテナ](https://en.wikipedia.org/wiki/Digital_container_format)を混同するというものがあります。**コンテナ**はビデオ(と音声もありえる)のメタデータとペイロードである**圧縮されたビデオ**を包括するラッパーフォーマットとして考えることができます。
>
> たいてい、ビデオファイルの拡張子はそのビデオコンテナを定義します。例えば、ファイル`video.mp4`はおそらく **[MPEG-4 Part 14](https://en.wikipedia.org/wiki/MPEG-4_Part_14)** コンテナで、`video.mkv`という名前のファイルはおそらく **[matroska](https://en.wikipedia.org/wiki/Matroska)** です。コーデックとコンテナフォーマットを確実に調べるためには、[ffmpegかmediainfo](/encoding_pratical_examples.md#inspect-stream)が使えます。

## 歴史

一般的なコーデックの内部動作に入って行く前に、いくつかの古いビデオコーデックについて少し理解するために過去を振り返ってみましょう。

ビデオコーデックである[H.261](https://en.wikipedia.org/wiki/H.261)は1990年(厳密には1988年)に生まれました。H.261は**64 kbit/sのデータレート**で動作するように設計されました。クロマサブサンプリングやマクロブロックなどの考えをすでに使っていました。1995年に、**H.263**ビデオコーデック標準が発表され2001年まで拡張され続けました。

2003年に**H.264/AVC**の初版が完成しました。同じ年に**TrueMotion**と呼ばれる会社が、**ロイヤリティーフリー**で非可逆ビデオ圧縮の **VP3**と呼ばれるビデオコーデックをリリースしました。2008年にこの会社を**Googleが買収**し、同じ年に**VP8**をリリースしました。2012年の12月にGoogleが**VP9**をリリースしました。VP9は(モバイルを含む)**ブラウザ市場のおよそ¾でサポートされています**。

**[AV1](https://en.wikipedia.org/wiki/AOMedia_Video_1)**は新しい**ロイヤリティーフリー**でオープンソースのビデオコーデックで、[Alliance for Open Media (AOMedia)](http://aomedia.org/)によって設計されました。AOMediaは**複数の会社: Google、Mozilla、Microsoft、Amazon、Netflix、AMD、ARM、NVidia、Intel、Cisco**と他のいくつかの会社から成り立っています。リファレンスコーデックの**初版** 0.1.0が**2016年4月7日に公開されました**。

![codec history timeline](/i/codec_history_timeline.png "コーデック歴史年表")

> #### AV1の誕生
>
> 2015年の初期にGoogleが[VP10](https://en.wikipedia.org/wiki/VP9#Successor:_from_VP10_to_AV1)の開発、Xiph (Mozilla)は[Daala](https://xiph.org/daala/)の開発、Ciscoはオープンソースでロイヤリティーフリーの[Thor](https://tools.ietf.org/html/draft-fuldseth-netvc-thor-03)と呼ばれるビデオコーデックの開発に取り組んでいました。
>
> MPEG LAは、当初はHEVC (H.265)の年間ロイヤリティーの上限とH.264の8倍高いライセンス料を発表しましたが、すぐにルールを変更しました。:
> * **年間ロイヤリティーの上限なし**
> * **コンテンツ料金** (収入の0.5%)
> * **h264より10倍高い単位あたり料金**
>
> [alliance for open media](http://aomedia.org/about/)はハードウェアメーカー(Intel、AMD、ARM、Nvidia、Cisco)、コンテンツ配信 (Google、Netflix、Amazon)、ブラウザ開発(Google, Mozilla)、その他の会社によって作られました。
>
> これらの会社にはロイヤリティーフリーのビデオコーデックという共通の目的があり、AV1はより [簡単な特許ライセンス](http://aomedia.org/license/patent/)で誕生しました。**Timothy B. Terriberry**が [AV1の概念、ライセンスモデル、現状](https://www.youtube.com/watch?v=lzPaldsmJbk)についての素晴らしいプレゼンテーションを行いました。この節はこのプレゼンテーションを元に書いています。
>
> **ブラウザーを使ってAV1コーデックを分析**できることを知って驚くことでしょう。http://aomanalyzer.org/ を見てください。
>
> ![av1 browser analyzer](/i/av1_browser_analyzer.png "av1ブラウザーアナライザー")
>
> 追記: コーデックの歴史についてもっと学びたいなら、背後にある[ビデオ圧縮の特許](https://www.vcodex.com/video-compression-patents/)の基本を学ばなくてはなりません。

## 一般的コーデック

**一般的なビデオコーデックの背後にある主な機構**を紹介していきますが、これらの概念のほとんどは  VP9、AV1、HEVCのような最新のコーデックでも役に立ち、使われています。物事をかなり単純にして説明することを理解してください。ときどき実際の例(だいたいはH.264)を使って、技法のデモを行います。

## ステップ１ - 画像分割

最初のステップは、いくつかの**パーティション、サブパーティション**、もっと細かい単位に**フレームを分割**することです。

![picture partitioning](/i/picture_partitioning.png "画像分割")

**しかしなぜ?** たくさんの理由があります。例えば、画像を分割すると小さなパーティションを動きのある小さな部分に使い、より大きなパーティションを静的な背景に使って、予測をより正確に行うことができます。

通常、コーデックは、スライス(もしくはタイル)、マクロ(もしくは符号ツリーユニット)やたくさんのサブパーティションで **パーティションを構成します**。これらのパーティションの最大サイズは様々で、HEVCでは64x64、AVC16x16ですが、サブパーティションは4x4までです。

**フレームはいくつかの形式に分けられている**のを学んだことを覚えていますか？！さて、**これらのアイデアをブロックに適用する**こともできます。つまりIスライス、Bスライス、Iマクロブロックなどを持つことができます。

> ### ハンズオン: パーティションを調べる
> [Intel Video Pro Analyzer](https://software.intel.com/en-us/intel-video-pro-analyzer) (有料ですが、最初の10フレームに制限された無料お試し版もあります)を使うこともできます。これが分析された[VP9パーティション](/encoding_pratical_examples.md#transcoding)です。
>
> ![VP9 partitions view inte ](/i/paritions_view_intel_video_pro_analyzer.png "VP9 パーティションビュー intel video pro analyzer")

## ステップ２ - 予測

パーティションに分割すると、それらについて予測を行うことができます。[インター予測](#時間的冗長性-インター予測)のために、**動きベクトルと差分を送信する**必要があり、また[イントラ予測](#空間的冗長性-イントラ予測)のために、**予測方向と差分を送信する**必要があります。

## ステップ３ - 変換

差分ブロック (`予測パーティション - 実際のパーティション`)を生成した後、それを**変換**することで**画質をある程度**保ったまま、どの**ピクセルを捨てられるか**が分かるようになります。それにはいくつかの変換が存在します。

[他の変換](https://en.wikipedia.org/wiki/List_of_Fourier-related_transforms#Discrete_transforms)もありますが、離散コサイン変換(DCT)をしっかり見ていきます。[**DCT**](https://en.wikipedia.org/wiki/Discrete_cosine_transform)の主な特徴は:

* **ピクセル**ブロックを同じサイズの**周波数係数**ブロックに**変換する**。
* エネルギーを**圧縮**して、空間的冗長性を削減しやすくする。
* **元に戻せる**、またはピクセルに戻せる

> 2017年2月2日にCintra, R. J.とBayer, F. Mが[14加算のみの画像圧縮用DCT近似変換](https://arxiv.org/abs/1702.00817)という論文を発表しました。

上記の箇条書きの利点を全て理解しなかったとしても心配いりません。その本当の価値を見い出すためにいくつかの実験を試みます。

次の**ピクセルのブロック**(8x8)を例にとりましょう:

![pixel values matrix](/i/pixel_matrice.png "ピクセル値マトリクス")

これはブロック画像(8x8)を描画します:

![pixel values matrix](/i/gray_image.png "ピクセル値マトリクス")

このピクセルのブロックに**DCTを適用する**と**係数のブロック** (8x8)を得ます:

![coefficients values](/i/dct_coefficient_values.png "係数の値")

この係数のブロックを描画すれば、次の画像が得られるでしょう:

![dct coefficients image](/i/dct_coefficient_image.png "dct係数画像")

元の画像とは似ても似つかないことが分かり、**最初の係数**は他の係数とは大きく異なっていることにお気づきかもしれません。この最初の係数はDC係数として知られ、入力配列の**サンプル全体**を表します。**平均に似た**何かです。

この係数のブロックは高周波数成分を低周波数成分から切り離すという面白い特性を持っています。

![dct frequency coefficients property](/i/dctfrequ.jpg "dct周波数係数特性")

画像では、**エネルギーのほとんど**は[**低周波**](https://web.archive.org/web/20150129171151/https://www.iem.thm.de/telekom-labor/zinke/mk/mpeg2beg/whatisit.htm)に集中されます。それで画像を周波数成分に変換して**高周波数係数を捨て**れば、画質をそれほど犠牲にせずに画像を表現するのに必要な**データ量を削減**できます。

> 周波数は信号がどれだけ速く変化するかを意味します。

では得られた知識を使って、元の画像をDCTを使って周波数(係数のブロック)に変換して、もっとも重要でない係数の部分を捨てる実験をしてみましょう。

まず、画像を**周波数領域**に変換します。

![coefficients values](/i/dct_coefficient_values.png "周波数値")

次に、係数の一部(67%)を捨てます。捨てるのはほとんどは右下の部分です。

![zeroed coefficients](/i/dct_coefficient_zeroed.png "ゼロにした係数")

最後に、この一部が捨てられた係数のブロックから画像を再生成し(元に戻せる必要があることを覚えておいてください)、元の画像と比較します。

![original vs quantized](/i/original_vs_quantized.png "元 vs 量子化後")

この画像は元の画像と似ていますが、多くの相違点が発生しています。**67.1875%を捨てました**が、 少なくとも元の画像に似ている画像を得ることができました。より賢い方法で係数を捨てて、もっと画質を良くすることもできたのですが、それは次のトピックで扱います。

> **それぞれの係数は画素全体を使って形成される**
>
> それぞれの係数は、１つの画素に直接マッピングしているわけではなく、画素全体の重み付き合計であることに留意することは重要です。下記の素晴らしいグラフは、1番目と2番目の係数が、それぞれのインデックスで異なる重みを使って、どのように計算されるかを示しています。
>
> ![dct calculation](/i/applicat.jpg "dct計算")
>
> 原典: https://web.archive.org/web/20150129171151/https://www.iem.thm.de/telekom-labor/zinke/mk/mpeg2beg/whatisit.htm
>
> DCT基底ごとの[単純な画像の形成を見てDCTを視覚化する](/dct_better_explained.ipynb)こともできます。例えば、下記はそれぞれの係数の重みを使って[１つの文字が形成されていく](https://en.wikipedia.org/wiki/Discrete_cosine_transform#Example_of_IDCT)過程です。
>
> ![](https://upload.wikimedia.org/wikipedia/commons/5/5e/Idct-animation.gif )

<br/>

> ### ハンズオン: 種々の係数を捨てる
> [DCT変換](/uniform_quantization_experience.ipynb)を実験しましょう。

## ステップ４ - 量子化

前のステップ (変換)で係数をいくつか捨てるときに、量子化のようなものを行いました。このステップでは、捨てる情報(**損失部分**)を選びます。単純な言葉でいうと、**圧縮を成し遂げるために係数を量子化**します。

どのように係数のブロックを量子化できるでしょうか？１つの単純な方法は、均一量子化でしょう。ブロックを**単一値** (10) **で割り**、小数点を切り捨てます。

![quantize](/i/quantize.png "量子化")

どのようにこの係数のブロックを**元に戻せる**(再量子化)でしょうか？**同じ値** (10)**を掛ける**ことにより戻すことができます。

![re-quantize](/i/re-quantize.png "再量子化")

この**やり方は最適な方法ではありません**。それぞれの係数の重要度を考慮していないからです。 単一値の代わりに**量子化マトリクス**を使うことができます。このマトリクスでDCTの特性を活かすことができます。右下を一番量子化して、左上はあまり量子化しません。[JPEGは似たやり方を使っています](https://www.hdm-stuttgart.de/~maucher/Python/MMCodecs/html/jpegUpToQuant.html)。[ソースコード上でこのマトリクスを見る](https://github.com/google/guetzli/blob/master/guetzli/jpeg_data.h#L40)ことができます。

> ### ハンズオン: 量子化
> [量子化](/dct_experiences.ipynb)を実験しましょう。

## ステップ５ - エントロピー符号化

データ(画像 ブロック/スライス/フレーム)を量子化した後、さらに可逆圧縮することができます。データ圧縮のためのたくさんの方法(アルゴリズム)が存在します。それらのいくつかを簡単に体験していきます。より深い理解のためには、この素晴らしい本[Understanding Compression: Data Compression for Modern Developers](https://www.amazon.com/Understanding-Compression-Data-Modern-Developers/dp/1491961538/)を読むとよいでしょう。

### 可変長符号:

記号のストリームを持っているとします: **a**、**e**、**r**、**t**とそれらの確率(0から1)がこのテーブルで表されています。

|             | a   | e   | r    | t   |
|-------------|-----|-----|------|-----|
| 確率 | 0.3 | 0.3 | 0.2 |  0.2 |

もっとも確率が高いものには(より小さな)ユニークなバイナリコードを、もっとも確率が低いものにはより大きなバイナリコードを割り当てることができます。

|             | a   | e   | r    | t   |
|-------------|-----|-----|------|-----|
| probability | 0.3 | 0.3 | 0.2 | 0.2 |
| binary code | 0 | 10 | 110 | 1110 |

ストリーム **eat**を圧縮してみましょう。それぞれの記号に8ビット使うと、圧縮なしで**24ビット**使うことになります。しかし、それぞれの記号をそのコードで置き換えると、スペースを節約できます。

まず記号**e**を符号化して`10`になります。２つ目の記号**a**を符号化すると、足されて(算数の方法ではなく) `[10][0]`となります。最後に３つ目の記号**t**を符号化すると、最終的な圧縮されたビットストリームは `[10][0][1110]`もしくは`1001110`となり、(もとより3.4倍小さなスペースである)**7ビット**しか使いません。

それぞれのコードはユニークな接頭符号を持つ必要があることに注意してください [ハフマンがこれらの数字を見つけることを助けてくれます](https://en.wikipedia.org/wiki/Huffman_coding)。いくつかの問題がありますが、この方法は[いくつかのビデオコーデックでまだサポート](https://en.wikipedia.org/wiki/Context-adaptive_variable-length_coding)しています。これは圧縮を必要とする多くのアプリケーションに有用なアルゴリズムです。

エンコーダーとデコーダーの両方がそのコードの記号テーブルを**知らなくてはいけません**。そのためテーブルも送信する必要があります。

### 算術符号:

記号: **a**, **e**, **r**, **s**, **t** のストリームを持っていて、それらの確率がこの表によって表されると仮定しましょう。

|             | a   | e   | r    | s    | t   |
|-------------|-----|-----|------|------|-----|
| probability | 0.3 | 0.3 | 0.15 | 0.05 | 0.2 |

この表を考慮に入れて、出現順にソートされた全ての可能な記号を含む範囲グラフを作ります。

![initial arithmetic range](/i/range.png "初期算術範囲")

さて、ストリーム **eat**を符号化してみましょう。最初の記号**e**を取り上げます。それは**0.3以上0.6未満**に位置しています。この部分範囲を取り上げ、それを再び同じ割合で分割します。

![second sub range](/i/second_subrange.png "2番目の部分範囲")

ストリーム**eat**の符号化を続けましょう。次に記号**a**を取り上げます。これは**0.3以上0.39未満**に位置しています。そして、最後の記号 **t**を取り上げます。もう一度同じ処理を行うと**0.354以上0.372未満**という最終的な範囲を得ます。

![final arithmetic range](/i/arithimetic_range.png "最終的な算術範囲")

最終範囲**0.354以上0.372未満**から１つの数値を取り上げる必要があります。**0.36**を取り上げましょう。しかしこの部分範囲内ならどんな数値を選んでもかまいません。この数値**だけで**、元のストリーム**eat**を復元することができます。これは、ストリームを符号化する為に範囲の範囲に線を引くかのように捉えることができます。
![final range traverse](/i/range_show.png "最終範囲横断")

**逆過程** (別名　復号化) は同様に簡単で、数値**0.36**と元の範囲を使って、同じ処理を行い、この数値から符号化されたストリームを明らかにします。 

最初の範囲で、その数値が１つの部分に一致し、それが最初の記号であることに気づきます。それから、その部分範囲を以前行ったようにまた分割します。すると**0.36**が記号**a**に合うことがわかり、同じ処理を繰り返すと、最後の記号である**t**を見つけます(符号前のストリーム*eat*を形成します)。

符号化と復号化の両方は、記号確率テーブルを**知る必要があります**。それでテーブルを送信する必要があります。

素晴らしいですよね。人々は本当に賢く、このような解決策を生み出しました。いくつかの[ビデオコーデック](https://en.wikipedia.org/wiki/Context-adaptive_binary_arithmetic_coding)はこの技法を使っています。(もしくは少なくともオプションとして提供しています)。

この考えは、量子化ビットストリームを可逆圧縮する為のものです。間違いなくこの記事では伝えきれていない詳細、理由、トレードオフ等が山のようにあります。しかし、読者はデベロッパーとして[もっと学ぶべきです](https://www.amazon.com/Understanding-Compression-Data-Modern-Developers/dp/1491961538/)。より新しいコーデックは別の[ANSのようなエントロピー符号化アルゴリズム](https://en.wikipedia.org/wiki/Asymmetric_Numeral_Systems)を使おうとしています。

> ### ハンズオン: CABAC対CAVLC
> [１つはCABAC、もう一方はCAVLCを使って２つのストリームを生成](https://github.com/leandromoreira/introduction_video_technology/blob/master/encoding_pratical_examples.md#cabac-vs-cavlc)し、生成する為にかかる**時間と最終的なサイズを比較**してみましょう。

## ステップ６ - ビットストリームフォーマット

これらのステップ全てを行った後、**圧縮されたフレームとこれらのステップまでのコンテキストを一つにまとめる**必要があります。 **エンコーダによってなされた決定**をデコーダへ明示的に知らせる必要があります。ビット深度、色空間、解像度、予測情報（動きベクトル、イントラ予測方向）、プロファイルレベル、フレームレート、フレームタイプ、フレーム数、その他多数です。

H.264ビットストリームについて表面的に学んでいきます。最初のステップは[最小限のH.264 <sup>*</sup>ビットストリームを生成する](/encoding_pratical_examples.md#generate-a-single-frame-h264-bitstream)ことです。このレポジトリと[ffmpeg](http://ffmpeg.org/)を使って、これができます。

```
./s/ffmpeg -i /files/i/minimal.png -pix_fmt yuv420p /files/v/minimal_yuv420.h264
```

> <sup>*</sup> ffmpegは、デフォルトで**SEI NAL**として符号化された全パラメータを加えます。NALが何であるかは後ほど定義します。

このコマンドは、**単一フレーム**、64x64、色空間がyuv420、次の画像をフレームとして使っている生のh264ビットストリームを生成します。

> ![used frame to generate minimal h264 bitstream](/i/minimal.png "最小h264ビットストリームを生成するフレームを使った")

### H.264ビットストリーム

AVC (H.264)標準は、情報が **[NAL (Network Abstraction Layer)](https://en.wikipedia.org/wiki/Network_Abstraction_Layer)** と呼ばれる **マクロフレーム** (ネットワーク的には)で送信されることを定義しています。NALの主な目的は、"ネットワークフレンドリー"なビデオ表現を提供することです。この標準は、TV (ストリームベース)、インターネット(パケットベース)やその他で動作しなければなりません。

![NAL units H.264](/i/nal_units.png "NALユニット H.264")

NALユニットの境界を定義する **[同期マーカー](https://en.wikipedia.org/wiki/Frame_synchronization)**があります。それぞれの同期マーカーは、最初は`0x00 0x00 0x00 0x01`で、それ以降は`0x00 0x00 0x01`の値を持ちます。もし生成されたh264ビットストリーム上で**16進ダンプ**を行えば、ファイルの最初の方に、少なくとも３つのNALを見つけることができます。

![synchronization marker on NAL units](/i/minimal_yuv420_hex.png "NALユニットの同期マーカー")

先に述べたとおり、デコーダは画像データだけではなく、動画、フレーム、色、使用されたパラメータ、その他の詳細を知る必要があります。それぞれのNALの**最初のバイト**は、そのカテゴリと**タイプ**を定義します。.

| NAL タイプID  | 説明  |
|---  |---|
| 0  |  未定義 |
| 1  |  非IDRピクチャの符号化スライス |
| 2  |  符号化スライスデータパーティション A |
| 3  |  符号化スライスデータパーティション B |
| 4  |  符号化スライスデータパーティション C |
| 5  |  IDRピクチャの**IDR**符号化スライス |
| 6  |  **SEI** 付加拡張情報 |
| 7  |  **SPS** シーケンスパラメータセット |
| 8  |  **PPS** ピクチャパラメータセット |
| 9  |  アクセスユニットデリミター |
| 10 |  シーケンスの最後 |
| 11 |  ストリームの最後 |
| ... |  ... |

通常、ビットストリームの最初のNALは**SPS**です。このNALの種類は、**プロファイル**、**レベル**、**解像度**やその他の汎用エンコーディング変数を知らせる役割を持ちます。

最初の同期マーカーを飛ばすと、**最初のバイト**を復号化して**NALのタイプ**が何かを知ることができます。

例えば、同期マーカーの最初のバイトは`01100111`です。最初のビット (`0`)は**forbidden_zero_bit**フィールドで、次の2ビット(`11`)は**nal_ref_idc**フィールドで、このNALが参照フィールドかどうかを示します。残りの5ビット (`00111`)は**nal_unit_type**フィールドで、この例では**SPS** (7) NALユニットです。

SPS NALの２バイト目(`２進数=01100100、１６進数=0x64、１０進数=100`)は**profile_idc**フィールドで、エンコーダが使ったプロファイルを示します。この例では、 **[制約付きハイプロファイル](https://en.wikipedia.org/wiki/H.264/MPEG-4_AVC#Profiles)** を使っています。これはB (双方向予測)スライスをサポートしないハイプロファイルです。

![SPS binary view](/i/minimal_yuv420_bin.png "SPSバイナリビュー")

SPS NALについてH.264ビットストリーム仕様を読むと、**パラメータ名**、**カテゴリ**、**説明**の表に多くの値を見つけるでしょう。例えば、`pic_width_in_mbs_minus_1`と`pic_height_in_map_units_minus_1`フィールドについて見てみましょう。

| パラメータ名  | カテゴリ  |  説明  |
|---  |---|---|
| pic_width_in_mbs_minus_1 |  0 | ue(v) |
| pic_height_in_map_units_minus_1 |  0 | ue(v) |

> **ue(v)**: 符号なし整数 [Exp-Golomb-coded](https://pythonhosted.org/bitstring/exp-golomb.html)

これらのフィールドの値に対してある計算をすると、**解像度**を得ることができます。`1920 x 1080`を`pic_width_in_mbs_minus_1`が`119 ( (119 + 1) * macroblock_size = 120 * 16 = 1920) `として表現することができます。空間をさらに節約するために、`1920`を符号化する代わりに、`119`を使っています。

生成されたビデオをバイナリビュー (例えば: `xxd -b -c 11 v/minimal_yuv420.h264`)で検査し続けると、最後のNALまで飛ばすことができます。それはフレーム自体です。

![h264 idr slice header](/i/slice_nal_idr_bin.png "h264 IDRスライスヘッダー")

最初の６バイトの値を見ましょう: `01100101 10001000 10000100 00000000 00100001 11111111`。すでに知ってる通り、最初のバイトでNALが何かを知ることができます。この例では、(`00101`)で **IDRスライス (5)** です。さらに検査してみます:

![h264 slice header spec](/i/slice_header.png "h264スライスヘッダ仕様")

仕様の情報を使い、スライスのタイプ (**slice_type**)、フレーム番号(**frame_num**)や他の重要なフィールドを復号することができます。

いくつかのフィールドの値を得るために(`ue(v)、me(v)、se(v)、te(v)`)、それを[Exponential-Golomb](https://pythonhosted.org/bitstring/exp-golomb.html)と呼ばれる特別なデコーダーを使って、デコードする必要があります。この方法は、デフォルト値が多いケースではたいてい、**変数値を符号化するのにとても効率的**です。

> このビデオの**slice_type**と**frame_num**の値は7 (Iスライス)と0 (最初のフレーム)です。

**ビットストリームをプロトコルとして**見ることができます。このビットストリームについてもっと学びたい、もしくは学ぶ必要があるなら、[ITU H.264 spec.]( http://www.itu.int/rec/T-REC-H.264-201610-I)を参照してください。下記はマクロ図表で、ピクチャデータ(圧縮YUV)がどこに位置するかを示しています。

![h264 bitstream macro diagram](/i/h264_bitstream_macro_diagram.png "h264ビットストリームマクロ図表")

[VP9ビットストリーム](https://storage.googleapis.com/downloads.webmproject.org/docs/vp9/vp9-bitstream-specification-v0.6-20160331-draft.pdf)や[H.265 (HEVC)](http://handle.itu.int/11.1002/1000/11885-en?locatt=format:pdf)や、さらには**新しいベストフレドである** [**AV1** ビットストリーム](https://medium.com/@mbebenita/av1-bitstream-analyzer-d25f1c27072b#.d5a89oxz8)のビットストリームを探索することができます。[それらはみんな似てますか？いいえ](http://www.gpac-licensing.com/2016/07/12/vp9-av1-bitstream-format/)、しかし1つを学ぶと、他は簡単に理解できます。

> ### ハンズオン: H.264ビットストリームを調べる
> [単一フレームのビデオを生成](https://github.com/leandromoreira/introduction_video_technology/blob/master/encoding_pratical_examples.md#generate-a-single-frame-video)し、[mediainfo](https://en.wikipedia.org/wiki/MediaInfo)を使ってH.264ビットストリームを検査してみましょう。実際、[h264 (AVC)ビットストリームをパースするソースコード](https://github.com/MediaArea/MediaInfoLib/blob/master/Source/MediaInfo/Video/File_Avc.cpp)を見ることもできます。
>
> ![mediainfo details h264 bitstream](/i/mediainfo_details_1.png "mediainfoがh264ビットストリームを詳述する")
>
> [Intel Video Pro Analyzer](https://software.intel.com/en-us/intel-video-pro-analyzer)を使うこともできます。有料ですが、最初の10フレームに制限された無料お試し版もあり、学習目的としては問題ありません。
>
> ![intel video pro analyzer details h264 bitstream](/i/intel-video-pro-analyzer.png "intel video pro analyzerがh264ビットストリームを詳述する")

## おさらい

多くの**現代のコーデックが、これまで学んできた同じモデルを使っている**ことに気づくでしょう。実際のビデオコーデックのブロック図をみてみましょう。これは学んできた全てのステップを含んでいます。少なくともコーデック関連の発明や文献についてより理解することができるようになったことになります。

![thor_codec_block_diagram](/i/thor_codec_block_diagram.png "thor_codec_block_diagram")

まず[720p解像度で30fpsで1時間のビデオファイルを保存するのに139GBのストレージ](#クロマサブサンプリング)が必要になることを計算しました。ここで学んだ技法つまり**インター予測、イントラ予測、変形、量子化、エントロピー符号化、その他**を駆使して、**ピクセルあたり0.031ビット**で表現できると仮定すると、**139GBに対したった367.82MBだけ**で同じ知覚画質のビデオを保存できます。

> 今回使用したビデオを元に**ピクセルあたり0.031ビット**が必要になることを導きました。

## どのようにH.265はH.264よりも良い圧縮率を実現しているのか?

今、コーデックの仕組みについてより理解しています。そのため、新しいコーデックがより高い解像度をより少ないビットでどのように配信できるのか簡単に理解できます。

AVCとHEVCを比較してみましょう。より多くのCPUサイクル(複雑さ)と圧縮率は、ほとんどいつでもトレードオフであることを心に止めておきましょう。

HEVCはAVCに比べて、より大きく、より多くの**パーティション** (と **サブパーティション**)のオプションを持っています。そしてより多くの**イントラ予測方向**、**改善されたエントロピー符号化**やその他を持っています。これら全ての改良のおかげで、H.265はH.264に比べて50%以上の圧縮をすることができるのです。

![H.264 vs H.265](/i/avc_vs_hevc.png "h264対h265")

# オンラインストリーミング
## 一般的なアーキテクチャ

![general architecture](/i/general_architecture.png "一般的なアーキテクチャ")

[TODO]

## プログレッシブダウンロードとアダプティブストリーミング

![progressive download](/i/progressive_download.png "プログレッシブダウンロード")

![adaptive streaming](/i/adaptive_streaming.png "アダプティブストリーミング")

[TODO]

## コンテンツ保護

**単純なトークンシステム**を使ってコンテンツを保護することができます。トークンを持っていないユーザーはビデオをリクエストしようとしても、CDNが禁止します。一方有効なトークンを持つユーザーはそのコンテンツを再生することができます。これはたいていのウェブ認証システムとほとんど同じように動作します。

![token_protection](/i/token_protection.png "トークン保護")

このトークンシステムの一人のユーザーが、あるユーザーにビデオをダウンロードさせて、それを配布させることもできます。**DRM (デジタル著作権管理)** システムを使ってこれを避けることができます。

![drm](/i/drm.png "drm")

実際の製品システムで、人々はしばしばこれら両方の技術を使って、認可と認証を提供します。

### DRM
#### メインシステム

* FPS - [**FairPlay Streaming**](https://developer.apple.com/streaming/fps/)
* PR - [**PlayReady**](https://www.microsoft.com/playready/)
* WV - [**Widevine**](http://www.widevine.com/)


#### What?

DRMは[Digital rights management(デジタル著作権管理)](https://sander.saares.eu/categories/drm-is-not-a-black-box/)を意味します。これは、ビデオやオーディオなどの**デジタルメディアに著作権保護を提供する**方法です。多くの場所で使われていますが、[広くは受け入れられていません](https://en.wikipedia.org/wiki/Digital_rights_management#DRM-free_works)。

#### Why?

コンテンツ製作者(たいていはスタジオ)は、デジタルメディアの不正な再配布を防ぐために、 知的財産が複製されることから守りたいためです。

#### How?

DRMの抽象的で一般的な形式を、とても単純な方法で説明していきます。

**コンテンツC1** (例えば hlsやdashビデオストリーミング)と**プレイヤーP1** (例えば shaka-clappr、exo-player、ios)が**デバイスD1** (例えば スマートフォン、テレビ、タブレット、デスクトップ/ノートブック)上にあり、**DRMシステムDRM1** (widevine、playready、FairPlayなど)を使っているとしましょう。

コンテンツC1は、システムDRM1からの**対称鍵K1**で暗号化され、**暗号化コンテンツC'1**を生成します。

![drm general flow](/i/drm_general_flow.jpeg "drm生成フロー")

デバイスD1のプレイヤーP1は２つの(非対称)鍵、**秘密鍵PRK1** (この鍵は保護され<sup>1</sup>**D1**にしか知られていない)と**公開鍵PUK1**を持っています。

> **<sup>1</sup>保護される**: この保護は、**ハードウェアを介して**なされます。例えば、この鍵は、特別な(読み取り専用)チップの中に保存されます。これは、復号を提供する[ブラックボックス](https://en.wikipedia.org/wiki/Black_box)のように働きます。もしくは(あまり安全でない)**ソフトウェアにより**なされます。DRM システムは、与えられたデバイスがどのタイプの保護を持っているかを知る方法を提供します。

**プレイヤーP1がコンテンツC'1を再生したい**とき、**DRMシステムDRM1**を使う必要があり、まず公開鍵**PUK1**を与えます。DRMシステムDRM1は クライアントの公開鍵**PUK1**で**暗号化された鍵K1**を返します。理論上、このレスポンスは**D1だけが復号可能**です。

`K1P1D1 = enc(K1, PUK1)`

**P1**は、DRMローカルシステム (それは特別なハードウェアかソフトウェアである[SOC](https://en.wikipedia.org/wiki/System_on_a_chip)もなりえる)を使います。このシステムは、秘密鍵PRK1を使って、コンテンツを**復号することができます**。**K1P1D1からの対称鍵K1**を復号化して、**C'1を再生**することができます。鍵がRAM上で外にさらされないのがベストです。

 ```
 K1 = dec(K1P1D1, PRK1)

 P1.play(dec(C'1, K1))
 ```

![drm decoder flow](/i/drm_decoder_flow.jpeg "drmデコードフロー")

# jupyterの使い方

**dockerがインストール**されていることを確認して、`./s/start_jupyter.sh`を実行し、ターミナル上の指示に従ってください。

# カンファレンス

* [DEMUXED](https://demuxed.com/) - [最後の２つのイベントプレゼンテーションをチェック](https://www.youtube.com/channel/UCIc_DkRxo9UgUSTvWVNCmpA)することができます。

# 参考文献

ここに最高のコンテンツがあります。このテキストで見られる全ては、ここから抽出されたか、元になっているか、何か影響を受けています。この驚くべきリンク、本、動画などで、知識をより深くすることができます。

オンラインコースとチュートリアル:

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

本:

* https://www.amazon.com/Understanding-Compression-Data-Modern-Developers/dp/1491961538/ref=sr_1_1?s=books&ie=UTF8&qid=1486395327&sr=1-1
* https://www.amazon.com/H-264-Advanced-Video-Compression-Standard/dp/0470516925
* https://www.amazon.com/Practical-Guide-Video-Audio-Compression/dp/0240806301/ref=sr_1_3?s=books&ie=UTF8&qid=1486396914&sr=1-3&keywords=A+PRACTICAL+GUIDE+TO+VIDEO+AUDIO
* https://www.amazon.com/Video-Encoding-Numbers-Eliminate-Guesswork/dp/0998453005/ref=sr_1_1?s=books&ie=UTF8&qid=1486396940&sr=1-1&keywords=jan+ozer

ビットストリーム仕様:

* http://www.itu.int/rec/T-REC-H.264-201610-I
* http://www.itu.int/ITU-T/recommendations/rec.aspx?rec=12904&lang=en
* https://storage.googleapis.com/downloads.webmproject.org/docs/vp9/vp9-bitstream-specification-v0.6-20160331-draft.pdf
* http://iphome.hhi.de/wiegand/assets/pdfs/2012_12_IEEE-HEVC-Overview.pdf
* http://phenix.int-evry.fr/jct/doc_end_user/current_document.php?id=7243
* http://gentlelogic.blogspot.com.br/2011/11/exploring-h264-part-2-h264-bitstream.html
* https://forum.doom9.org/showthread.php?t=167081
* https://forum.doom9.org/showthread.php?t=168947

ソフトウェア:

* https://ffmpeg.org/
* https://ffmpeg.org/ffmpeg-all.html
* https://ffmpeg.org/ffprobe.html
* https://trac.ffmpeg.org/wiki/
* https://software.intel.com/en-us/intel-video-pro-analyzer
* https://medium.com/@mbebenita/av1-bitstream-analyzer-d25f1c27072b#.d5a89oxz8

非ITUコーデック:

* https://aomedia.googlesource.com/
* https://github.com/webmproject/libvpx/tree/master/vp9
* https://people.xiph.org/~xiphmont/demo/daala/demo1.shtml
* https://people.xiph.org/~jm/daala/revisiting/
* https://www.youtube.com/watch?v=lzPaldsmJbk
* https://fosdem.org/2017/schedule/event/om_av1/

エンコードの概念:

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

テスト用ビデオシーケンス:

* http://bbb3d.renderfarming.net/download.html
* https://www.its.bldrdoc.gov/vqeg/video-datasets-and-organizations.aspx

その他:

* https://github.com/Eyevinn/streaming-onboarding
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
* https://sander.saares.eu/categories/drm-is-not-a-black-box/
