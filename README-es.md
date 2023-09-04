[🇺🇸](/README.md "English")
[🇨🇳](/README-cn.md "Simplified Chinese")
[🇯🇵](/README-ja.md "Japanese")
[🇮🇹](/README-it.md "Italian")
[🇰🇷](/README-ko.md "Korean")
[🇷🇺](/README-ru.md "Russian")
[🇧🇷](/README-pt.md "Portuguese")
[🇪🇸](/README-es.md "Spanish")

[![license](https://img.shields.io/badge/license-BSD--3--Clause-blue.svg)](https://img.shields.io/badge/license-BSD--3--Clause-blue.svg)

# Introducción

Esto es una breve introducción a la tecnología de vídeo, principalmente dirigido a desarrolladores o ingenieros de software. La intención es que sea **fácil de aprender para cualquier persona**. La idea nació durante un [breve taller para personas nuevas en vídeo](https://docs.google.com/presentation/d/17Z31kEkl_NGJ0M66reqr9_uTG6tI5EDDVXpdPKVuIrs/edit#slide=id.p).

El objetivo es introducir algunos conceptos de vídeo digital con un **vocabulario simple, muchas figuras y ejemplos prácticos** en cuanto sea posible, y dejar disponible este conocimiento. Por favor, siéntete libre de enviar correcciones, sugerencias y mejoras.

Habrán **prácticas** que requiere tener instalado **docker** y este repositorio clonado. 

```bash
git clone https://github.com/leandromoreira/digital_video_introduction.git
cd digital_video_introduction
./setup.sh
```
> **ADVERTENCIA**: cuando observes el comando `./s/ffmpeg` o `./s/mediainfo`, significa que estamos ejecutando la **versión contenerizada** del mismo, que a su vez incluye todos los requerimientos necesarios.

Todas las **prácticas deberán ser ejecutadas desde el directorio donde has clonado** este repositorio. Para ejecutar los **ejemplos de jupyter** deberás primero iniciar el servicio `./s/start_jupyter.sh`, copiar la URL y pegarla en tu navegador.

# Control de cambios

* Detalles sobre sistemas DRM
* Versión 1.0.0 liberada
* Traducción a Chino Simplificado
* Ejemplo de FFmpeg oscilloscope filter
* Traducción a Portugués (Brasil)
* Traducción a Español

# Tabla de contenidos

- [Introducción](#introducción)
- [Tabla de contenidos](#tabla-de-contenidos)
- [Terminología Básica](#terminología-básica)
  * [Otras formas de codificar una imagen a color](#otras-formas-de-codificar-una-imagen-a-color)
  * [Práctica: juguemos con una imagen y colores](#práctica-juguemos-con-una-imagen-y-colores)
  * [DVD es DAR 4:3](#dvd-es-dar-43)
  * [Práctica: Verifiquemos las propiedades del vídeo](#práctica-verifiquemos-las-propiedades-del-vídeo)
- [Eliminación de Redundancias](#eliminación-de-redundancias)
  * [Colores, Luminancia y nuestros ojos](#colores-luinancia-y-nuestros-ojos)
    + [Modelo de color](#modelo-de-color)
    + [Conversiones entre YCbCr y RGB](#conversiones-entre-ycbcr-y-rgb)
    + [Chroma subsampling](#chroma-subsampling)
    + [Práctica: Observemos el histograma YCbCr](#práctica-observemos-el-histograma-ycbcr)
    + [Color, luma, luminancia, gamma](#color-luma-luminancia-gamma)
    + [Práctica: Observa la intensidad YCbCr](#práctica-observa-la-intensidad-ycbcr)
  * [Tipos de fotogramas](#tipos-de-fotogramas)
    + [I Frame (intra, keyframe)](#i-frame-intra-keyframe)
    + [P Frame (predicted)](#p-frame-predicted)
      - [Práctica: Un vídeo con un solo I-frame](#práctica-un-vídeo-con-un-solo-i-frame)
    + [B Frame (bi-predictive)](#b-frame-bi-predictive)
      - [Práctica: Compara vídeos con B-frame](#práctica-compara-videos-con-b-frame)
    + [Resumen](#resumen)
  * [Temporal redundancy (inter prediction)](#temporal-redundancy-inter-prediction)
      - [Hands-on: See the motion vectors](#hands-on-see-the-motion-vectors)
  * [Spatial redundancy (intra prediction)](#spatial-redundancy-intra-prediction)
      - [Hands-on: Check intra predictions](#hands-on-check-intra-predictions)
- [How does a video codec work?](#how-does-a-video-codec-work)
  * [What? Why? How?](#what-why-how)
  * [History](#history)
    + [The birth of AV1](#the-birth-of-av1)
  * [A generic codec](#a-generic-codec)
  * [1st step - picture partitioning](#1st-step---picture-partitioning)
    + [Hands-on: Check partitions](#hands-on-check-partitions)
  * [2nd step - predictions](#2nd-step---predictions)
  * [3rd step - transform](#3rd-step---transform)
    + [Hands-on: throwing away different coefficients](#hands-on-throwing-away-different-coefficients)
  * [4th step - quantization](#4th-step---quantization)
    + [Hands-on: quantization](#hands-on-quantization)
  * [5th step - entropy coding](#5th-step---entropy-coding)
    + [VLC coding](#vlc-coding)
    + [Arithmetic coding](#arithmetic-coding)
    + [Hands-on: CABAC vs CAVLC](#hands-on-cabac-vs-cavlc)
  * [6th step - bitstream format](#6th-step---bitstream-format)
    + [H.264 bitstream](#h264-bitstream)
    + [Hands-on: Inspect the H.264 bitstream](#hands-on-inspect-the-h264-bitstream)
  * [Review](#review)
  * [How does H.265 achieve a better compression ratio than H.264?](#how-does-h265-achieve-a-better-compression-ratio-than-h264)
- [Online streaming](#online-streaming)
  * [General architecture](#general-architecture)
  * [Progressive download and adaptive streaming](#progressive-download-and-adaptive-streaming)
  * [Content protection](#content-protection)
- [How to use jupyter](#how-to-use-jupyter)
- [Conferences](#conferences)
- [References](#references)

# Terminología Básica

Una **imagen** puede ser pensada como una **matriz 2D**. Si pensamos en **colores**, podemos extrapolar este concepto a que una imagen es una **matriz 3D** donde la **dimensión adicional** es usada para indicar la **información de color**.

Si elegimos representar esos colores usando los [colores primarios (rojo, verde y azul)](https://es.wikipedia.org/wiki/Color_primario), definimos tres planos: el primero para el **rojo**, el segundo para el **verde**, y el último para el **azul**.

![una imagen es una matriz 3D RGB](/i/image_3d_matrix_rgb.png "Una imagen es una matriz 3D")

Llamaremos a cada punto en esta matriz **un píxel** (del inglés, *picture element*). Un píxel representa la **intensidad** (usualmente un valor numérico) de un color dado. Por ejemplo, un **píxel rojo** significa 0 de verde, 0 de azul y el máximo de rojo. El **píxel de color rosa** puede formarse de la combinación de estos tres colores. Usando la representación numérica con un rango desde 0 a 255, el píxel rosa es definido como **Rojo=255, Verde=192 y Azul=203**.

> #### Otras formas de codificar una imagen a color
> Otros modelos pueden ser utilizados para representar los colores que forman una imagen. Por ejemplo, podemos usar una paleta indexada donde necesitaremos solamente un byte para representar cada píxel en vez de los 3 necesarios cuando usamos el modelo RGB. En un modelo como este, podemos utilizar una matriz 2D para representar nuestros colores, esto nos ayudaría a ahorrar memoria aunque tendríamos menos colores para representar.
>
> ![NES palette](/i/nes-color-palette.png "NES palette")

Observemos la figura que se encuentra a continuación. La primer cara muestra todos los colores utilizados. Mientras las demás muestran a intencidad de cada plano rojo, verde y azul (representado en escala de grises).

![Intensidad de los canales RGB](/i/rgb_channels_intensity.png "Intensidad de los canales RGB")

Podemos ver que el **color rojo** es el que **contribuye más** (las partes más brillantes en la segunda cara) mientras que en la cuarta cara observamos que el **color azul** su contribución se **limita a los ojos de Mario** y parte de su ropa. También podemos observar como **todos los planos no contribuyen demasiado** (partes oscuras) al **bigote de Mario**.

Cada intensidad de color requiere de una cantidad de bits para ser representada, esa cantidad es conocida como **bit depth**. Digamos que utilizamos **8 bits** (aceptando valores entre 0 y 255) por color (plano), entonces tendremos una **color depth** (profundidad de color) de **24 bits** (8 bits * 3 planos R/G/B), por lo que podemos inferir que tenemos disponibles 2^24 colores diferentes.

> **Es asombroso** aprender [como una imagen es capturada desde el Mundo a los bits](http://www.cambridgeincolour.com/tutorials/camera-sensors.htm).

Otra propiedad de una images es la **resolución**, que es el número de píxeles en una dimensión. Frecuentemente es presentado como ancho × alto (*width × height*), por ejemplo, la siguiente imagen es **4×4**.

![image resolution](/i/resolution.png "image resolution")

> #### Práctica: juguemos con una imagen y colores
> Puedes [jugar con una imagen y colores](/image_as_3d_array.ipynb) usando [jupyter](#how-to-use-jupyter) (python, numpy, matplotlib, etc).
>
> También puedes aprender [cómo funcionan los filtros de imágenes (edge detection, sharpen, blur...)](/filters_are_easy.ipynb).

Trabajando con imágenes o vídeos, te encontrarás con otra propiedad llamada **aspect ratio** (relación de aspecto) que simplemente describe la relación proporcional que existe entre el ancho y alto de una imagen o píxel.

Cuando las personas dicen que una película o imagen es **16x9** usualmente se están refiriendo a la relación de aspecto de la pantalla (**Display Aspect Ratio (DAR)**), sin embargo podemos tener diferentes formas para cada píxel, a ello le llamamos relación de aspecto del píxel (**Pixel Aspect Ratio (PAR)**).

![display aspect ratio](/i/DAR.png "display aspect ratio")

![pixel aspect ratio](/i/PAR.png "pixel aspect ratio")

> #### DVD es DAR 4:3
> La resolución del formato de DVD es 704x480, igualmente mantiente una relación de aspecto (DAR) de 4:3 porque tiene PAR de 10:11 (704x10/480x11)

Finalmente, podemos definir a un **vídeo** como una **sucesión de *n* fotogramas** en el **tiempo**, la cual la podemos definir como otra dimensión, *n* es el *frame rate* o fotogramas por segundo (**FPS**, del inglés *frames per second*).

![video](/i/video.png "video")

El número necesario de bits por segundo para mostrar un vídeo es llamado **bit rate**.

> bit rate = ancho * alto * bit depth * FPS

Por ejemplo, un vídeo de 30 fotogramas por segundo, 24 bits por píxel, 480x240 de resolución necesitaría de **82,944,000 bits por segundo** o 82.944 Mbps (30x480x240x24) si no queremos aplicar ningún tipo de compresión.

Cuando el **bit rate** es casi constante es llamado bit rate constante (**CBR**, del inglés *constant bit rate*), pero también puede ser variable por lo que lo llamaremos bit rate variable (**VBR**, del inglés *variable bit rate*).

> La siguiente gráfica muestra como utilizando VBR no se necesita gastar demasiados bits para un fotograma es negro.
>
> ![constrained vbr](/i/vbr.png "constrained vbr")

En otros tiempos, unos ingenieros idearon una técnica para duplicar la cantidad de fotogramas por segundo percividos en una pantalla **sin consumir ancho de banda adicional**. Esta técnica es conocida como **vídeo entrelazado** (*interlaced video*); básicamente envía la mitad de la pantalla en un "fotograma" y la otra mitad en el siguiente "fotograma".  

Hoy en día, las pantallas representan imágenes principalmente utilizando la **técnica de escaneo progresivo** (*progressive vídeo*). El vídeo progresivo es una forma de mostrar, almacenar o transmitir imágenes en movimiento en la que todas las líneas de cada fotograma se dibujan en secuencia.

![entrelazado vs. progresivo](/i/interlaced_vs_progressive.png "entrelazado vs. progresivo")

Ahora ya tenemos una idea acerca de cómo una **imagen** es representada digitalmente, cómo sus **colores** son codificados, cuántos **bits por segundo** necesitamos para mostrar un vídeo, si es constante (CBR) o variable (VBR), con una **resolución** dada a determinado **frame rate** y otros términos como entrelazado, PAR, etc.

> #### Práctica: Verifiquemos las propiedades del vídeo
> Puedes [verificar la mayoría de las propiedades mencionadas con ffmpeg o mediainfo.](https://github.com/leandromoreira/introduction_video_technology/blob/master/encoding_pratical_examples.md#inspect-stream)

# Eliminación de Redundancias

Aprendimos que no es factible utilizar vídeo sin ninguna compresión; **un solo vídeo de una hora** a una resolución de 720p y 30fps **requeriría 278GB<sup>*</sup>**. Dado que **utilizar únicamente algoritmos de compresión de datos sin pérdida** como DEFLATE (utilizado en PKZIP, Gzip y PNG), **no disminuiría** suficientemente el ancho de banda necesario, debemos encontrar otras formas de comprimir el vídeo.

> <sup>*</sup> Encontramos este número multiplicando 1280 x 720 x 24 x 30 x 3600 (ancho, alto, bits por píxel, fps y tiempo en segundos).

Para hacerlo, podemos **aprovechar cómo funciona nuestra visión**. Somos mejores para distinguir el brillo que los colores, las **repeticiones en el tiempo**, un vídeo contiene muchas imágenes con pocos cambios, y las **repeticiones dentro de la imagen**, cada fotograma también contiene muchas áreas que utilizan colores iguales o similares.

## Colores, Luminancia y nuestros ojos
Nuestros ojos son [más sensibles al brillo que a los colores](http://vanseodesign.com/web-design/color-luminance/), puedes comprobarlo por ti mismo, mira esta imagen.

![luminance vs color](/i/luminance_vs_color.png "luminance vs color")

Si no puedes ver que los colores de los **cuadrados A y B son idénticos** en el lado izquierdo, no te preocupes, es nuestro cerebro jugándonos una pasada para que **prestemos más atención a la luz y la oscuridad que al color**. Hay un conector, del mismo color, en el lado derecho para que nosotros (nuestro cerebro) podamos identificar fácilmente que, de hecho, son del mismo color.

> **Explicación simplista de cómo funcionan nuestros ojos**
> El [ojo es un órgano complejo](http://www.biologymad.com/nervoussystem/eyenotes.htm), compuesto por muchas partes, pero principalmente nos interesan las células de conos y bastones. El ojo [contiene alrededor de 120 millones de células de bastones y 6 millones de células de conos](https://en.wikipedia.org/wiki/Photoreceptor_cell).
>
> Para **simplificar absurdamente**, intentemos relacionar los colores y el brillo con las funciones de las partes del ojo. Los **[bastones](https://es.wikipedia.org/wiki/Bast%C3%B3n_(c%C3%A9lula)) son principalmente responsables del brillo**, mientras que los **[conos](https://es.wikipedia.org/wiki/Cono_(c%C3%A9lula)) son responsables del color**. Hay tres tipos de conos, cada uno con un pigmento diferente, a saber: [Tipo S (azul), Tipo M (verde) y Tipo L (rojos)](https://upload.wikimedia.org/wikipedia/commons/1/1e/Cones_SMJ2_E.svg).
>
> Dado que tenemos muchas más células de bastones (brillo) que células de conos (color), se puede inferir que somos más capaces de distinguir el contraste entre la luz y la oscuridad que los colores.
>
> ![eyes composition](/i/eyes.jpg "eyes composition")
>
> **Funciones de sensibilidad al contraste**
>
> Los investigadores de psicología experimental y muchas otras disciplinas han desarrollado varias teorías sobre la visión humana. Una de ellas se llama funciones de sensibilidad al contraste. Están relacionadas con el espacio y el tiempo de la luz y su valor se presenta en una luz inicial dada, cuánto cambio se requiere antes de que un observador informe que ha habido un cambio. Observa el plural de la palabra "función", esto se debe a que podemos medir las funciones de sensibilidad al contraste no solo con blanco y negro, sino también con colores. El resultado de estos experimentos muestra que en la mayoría de los casos nuestros ojos son más sensibles al brillo que al color.

Una vez que sabemos que somos más sensibles a la **luminancia** (*luma*, el brillo en una imagen), podemos aprovecharlo.
### Modelo de color

Primero aprendimos [cómo funcionan las imágenes en color](#terminología-básica) utilizando el **modelo RGB**, pero existen otros modelos también. De hecho, hay un modelo que separa la luminancia (brillo) de la crominancia (colores) y se conoce como **YCbCr**<sup>*</sup>.

> <sup>*</sup> hay más modelos que hacen la misma separación.

Este modelo de color utiliza **Y** para representar el brillo y dos canales de color, **Cb** (croma azul) y **Cr** (croma rojo). El [YCbCr](https://es.wikipedia.org/wiki/YCbCr) se puede derivar a partir de RGB y también se puede convertir de nuevo a RGB. Utilizando este modelo, podemos crear imágenes a todo color, como podemos ver a continuación.

![ycbcr example](/i/ycbcr.png "ycbcr example")

### Conversiones entre YCbCr y RGB

Algunos pueden preguntarse, ¿cómo podemos producir **todos los colores sin usar el verde**?

Para responder a esta pregunta, vamos a realizar una conversión de RGB a YCbCr. Utilizaremos los coeficientes del **[estándar BT.601](https://en.wikipedia.org/wiki/Rec._601)** que fue recomendado por el **[grupo ITU-R<sup>*</sup>](https://en.wikipedia.org/wiki/ITU-R)**. El primer paso es **calcular la luminancia**, utilizaremos las constantes sugeridas por la ITU y sustituiremos los valores RGB.

```
Y = 0.299R + 0.587G + 0.114B
```

Una vez obtenida la luminancia, podemos **separar los colores** (croma azul y croma rojo):

```
Cb = 0.564(B - Y)
Cr = 0.713(R - Y)
```

Y también podemos **covertirlo de vuelta** e incluse obtener el **verde utilizando YCbCr**.

```
R = Y + 1.402Cr
B = Y + 1.772Cb
G = Y - 0.344Cb - 0.714Cr
```

> <sup>*</sup> Los grupos y estándares son comunes en el vídeo digital y suelen definir cuáles son los estándares, por ejemplo, [¿qué es 4K? ¿qué FPS debemos usar? ¿resolución? ¿modelo de color?](https://en.wikipedia.org/wiki/Rec._2020)

Generalmente, las **pantallas** (monitores, televisores, etc.) utilizan **solo el modelo RGB**, organizado de diferentes maneras, como se muestra a continuación:

![pixel geometry](/i/new_pixel_geometry.jpg "pixel geometry")

### Chroma subsampling

Con la imagen representada en componentes de luminancia y crominancia, podemos aprovechar la mayor sensibilidad del sistema visual humano a la resolución de luminancia en lugar de la crominancia para eliminar selectivamente información. El **chroma subsampling** es la técnica de codificar imágenes utilizando **menor resolución para la crominancia que para la luminancia**.

![ycbcr subsampling resolutions](/i/ycbcr_subsampling_resolution.png "ycbcr subsampling resolutions")


¿Cuánto debemos reducir la resolución de la crominancia? Resulta que ya existen algunos esquemas que describen cómo manejar la resolución y la combinación (`color final = Y + Cb + Cr`).

Estos esquemas se conocen como sistemas de *subsampling* y se expresan como una relación de 3 partes: `a:x:y`, que define la resolución de la crominancia en relación con un bloque `a x 2` de píxeles de luminancia.

 * `a` es la referencia de muestreo horizontal (generalmente 4).
 * `x` es el número de muestras de crominancia en la primera fila de `a` píxeles (resolución horizontal en relación con `a`).
 * `y` es el número de cambios de muestras de crominancia entre la primera y segunda filas de a píxeles.

> Una excepción a esto es el 4:1:0, que proporciona una sola muestra de crominancia dentro de cada bloque de `4 x 4` píxeles de resolución de luminancia.

Los esquemas comunes utilizados en códecs modernos son: **4:4:4** *(sin subsampling)*, **4:2:2, 4:1:1, 4:2:0, 4:1:0 y 3:1:1**.

> Puedes seguir algunas discusiones para [aprender más sobre el Chroma Subsampling](https://github.com/leandromoreira/digital_video_introduction/issues?q=YCbCr).

> **Fusión YCbCr 4:2:0**
>
> Aquí tienes una parte fusionada de una imagen utilizando YCbCr 4:2:0, observa que solo utilizamos 12 bits por píxel.
>
> ![YCbCr 4:2:0 merge](/i/ycbcr_420_merge.png "YCbCr 4:2:0 merge")

Puedes ver la misma imagen codificada por los principales tipos de *chroma subsampling*, las imágenes en la primera fila son las YCbCr finales, mientras que la última fila de imágenes muestra la resolución de crominancia. Es realmente una gran ganancia con una pérdida tan pequeña.

![chroma subsampling examples](/i/chroma_subsampling_examples.jpg "chroma subsampling examples")

Anteriormente habíamos calculado que necesitábamos [278 GB de almacenamiento para mantener un archivo de video con una hora de resolución de 720p y 30 fps](#eliminación-de-redundancias). Si usamos **YCbCr 4:2:0**, podemos reducir **este tamaño a la mitad (139 GB)**<sup>*</sup>, pero aún está lejos del ideal.

> <sup>*</sup> encontramos este valor multiplicando el ancho, alto, bits por píxel y fps. Anteriormente necesitábamos 24 bits, ahora solo necesitamos 12.

<br/>

> ### Práctica: Observemos el histograma YCbCr
> Puedes [observar el histograma YCbCr con ffmpeg](/encoding_pratical_examples.md#generates-yuv-histogram). Esta excena tiene una mayor contribución de azul la cual se muestra en el [histograma](https://es.wikipedia.org/wiki/Histograma).
>
> ![ycbcr color histogram](/i/yuv_histogram.png "ycbcr color histogram")

### Color, luma, luminancia, gamma

Mira este increíble video que explica qué es la luma y aprende sobre luminancia, gamma y color.
**Vídeo en Inglés**
[![Analog Luma - A history and explanation of video](http://img.youtube.com/vi/Ymt47wXUDEU/0.jpg)](http://www.youtube.com/watch?v=Ymt47wXUDEU)

> ### Práctica: Observa la intensidad YCbCr
> Puedes visualizar la intensidad Y (luma) para una línea específica de un vídeo utilizando el [filtro de osciloscopio de FFmpeg](https://ffmpeg.org/ffmpeg-filters.html#oscilloscope).
> ```bash
> ffplay -f lavfi -i 'testsrc2=size=1280x720:rate=30000/1001,format=yuv420p' -vf oscilloscope=x=0.5:y=200/720:s=1:c=1
> ```
> ![y color oscilloscope](/i/ffmpeg_oscilloscope.png "y color oscilloscope")

## Tipos de fotogramas

Ahora podemos continuar y tratar de eliminar la **redundancia en el tiempo**, pero antes de hacerlo, establezcamos algunas terminologías básicas. Supongamos que tenemos una película con 30 fps. Aquí están sus primeros 4 fotogramas.

![ball 1](/i/smw_background_ball_1.png "ball 1") ![ball 2](/i/smw_background_ball_2.png "ball 2") ![ball 3](/i/smw_background_ball_3.png "ball 3")
![ball 4](/i/smw_background_ball_4.png "ball 4")

Podemos ver **muchas repeticiones** dentro de los fotogramas, como **el fondo azul**, que no cambia del fotograma 0 al fotograma 3. Para abordar este problema, podemos **categorizarlos abstractamente** en tres tipos de fotogramas.

### I Frame (intra, keyframe)

Un *I-frame* (*reference*, *keyframe*, *intra*, en español fotograma o cuadro de referencia) es un **fotograma autónomo**. No depende de nada para ser renderizado, un *I-frame* se parece a una fotografía estática. Por lo general, el primer fotograma es un *I-frame*, pero veremos *I-frames* insertados regularmente entre otros tipos de fotogramas.

![ball 1](/i/smw_background_ball_1.png "ball 1")

### P Frame (predicted)

Un *P-frame* (en español, fotograma o cuadro predictivo) aprovecha el hecho de que casi siempre l**a imagen actual se puede renderizar utilizando el fotograma anterior**. Por ejemplo, en el segundo fotograma, el único cambio fue que la pelota se movió hacia adelante. Podemos **reconstruir el fotograma 1, utilizando solo la diferencia y haciendo referencia al fotograma anterior**.

![ball 1](/i/smw_background_ball_1.png "ball 1") <-  ![ball 2](/i/smw_background_ball_2_diff.png "ball 2")

> #### Práctica: Un vídeo con un solo I-frame
> Dado que un fotograma P utiliza menos datos, ¿por qué no podemos codificar un [video entero con un solo *I-frame* y todos los demás siendo *P-frames*?](/encoding_pratical_examples.md#1-i-frame-and-the-rest-p-frames)
>
> Después de codificar este vídeo, comienza a verlo y **busca una parte avanzada** del vídeo; notarás que **toma algo de tiempo** llegar realmente a esa parte. Esto se debe a que un ***P-frame* necesita un fotograma de referencia** (como un *I-frame*, por ejemplo) para renderizarse.
>
> Otra prueba rápida que puedes hacer es codificar un vídeo utilizando un solo *I-frame* y luego [codificarlo insertando un *I-frame* cada 2 segundos](/encoding_pratical_examples.md#1-i-frames-per-second-vs-05-i-frames-per-second) y **comprobar el tamaño de cada versión**.

### B Frame (bi-predictive)

¿Qué pasa si hacemos referencia a los fotogramas pasados y futuros para proporcionar una compresión aún mejor? Eso es básicamente lo que hace un *B-frame*.

![ball 1](/i/smw_background_ball_1.png "ball 1") <-  ![ball 2](/i/smw_background_ball_2_diff.png "ball 2") -> ![ball 3](/i/smw_background_ball_3.png "ball 3")

> #### Práctica: Compara vídeos con B-frame
> Puedes generar dos versiones, una con *B-frames* y otra sin ningún [*B-frame* en absoluto](/encoding_pratical_examples.md#no-b-frames-at-all) y verificar el tamaño del archivo y la calidad.

### Resumen

Estos tipos de fotogramas se utilizan para **proporcionar una mejor compresión**. Veremos cómo sucede esto en la próxima sección, pero por ahora podemos pensar en un ***I-frame* como costoso, un *P-frame* como más económico y el más económico es el *B-frame*.**

![frame types example](/i/frame_types.png "frame types example")

## Temporal redundancy (inter prediction)

Let's explore the options we have to reduce the **repetitions in time**, this type of redundancy can be solved with techniques of **inter prediction**.


We will try to **spend fewer bits** to encode the sequence of frames 0 and 1.

![original frames](/i/original_frames.png "original frames")

One thing we can do it's a subtraction, we simply **subtract frame 1 from frame 0** and we get just what we need to **encode the residual**.

![delta frames](/i/difference_frames.png "delta frames")

But what if I tell you that there is a **better method** which uses even fewer bits?! First, let's treat the `frame 0` as a collection of well-defined partitions and then we'll try to match the blocks from `frame 0` on `frame 1`. We can think of it as **motion estimation**.

> ### Wikipedia - block motion compensation
> "**Block motion compensation** divides up the current frame into non-overlapping blocks, and the motion compensation vector **tells where those blocks come from** (a common misconception is that the previous frame is divided up into non-overlapping blocks, and the motion compensation vectors tell where those blocks move to). The source blocks typically overlap in the source frame. Some video compression algorithms assemble the current frame out of pieces of several different previously-transmitted frames."

![delta frames](/i/original_frames_motion_estimation.png "delta frames")

We could estimate that the ball moved from `x=0, y=25` to `x=6, y=26`, the **x** and **y** values are the **motion vectors**. One **further step** we can do to save bits is to **encode only the motion vector difference** between the last block position and the predicted, so the final motion vector would be `x=6 (6-0), y=1 (26-25)`

> In a real-world situation, this **ball would be sliced into n partitions** but the process is the same.

The objects on the frame **move in a 3D way**, the ball can become smaller when it moves to the background. It's normal that **we won't find the perfect match** to the block we tried to find a match. Here's a superposed view of our estimation vs the real picture.

![motion estimation](/i/motion_estimation.png "motion estimation")

But we can see that when we apply **motion estimation** the **data to encode is smaller** than using simply delta frame techniques.

![motion estimation vs delta ](/i/comparison_delta_vs_motion_estimation.png "motion estimation delta")

> ### How real motion compensation would look
> This technique is applied to all blocks, very often a ball would be partitioned in more than one block.
>  ![real world motion compensation](/i/real_world_motion_compensation.png "real world motion compensation")
> Source: https://web.stanford.edu/class/ee398a/handouts/lectures/EE398a_MotionEstimation_2012.pdf

You can [play around with these concepts using jupyter](/frame_difference_vs_motion_estimation_plus_residual.ipynb).

> #### Hands-on: See the motion vectors
> We can [generate a video with the inter prediction (motion vectors)  with ffmpeg.](/encoding_pratical_examples.md#generate-debug-video)
>
> ![inter prediction (motion vectors) with ffmpeg](/i/motion_vectors_ffmpeg.png "inter prediction (motion vectors) with ffmpeg")
>
> Or we can use the [Intel Video Pro Analyzer](https://software.intel.com/en-us/intel-video-pro-analyzer) (which is paid but there is a free trial version which limits you to only work with the first 10 frames).
>
> ![inter prediction intel video pro analyzer](/i/inter_prediction_intel_video_pro_analyzer.png "inter prediction intel video pro analyzer")

## Spatial redundancy (intra prediction)

If we analyze **each frame** in a video we'll see that there are also **many areas that are correlated**.

![](/i/repetitions_in_space.png)

Let's walk through an example. This scene is mostly composed of blue and white colors.

![](/i/smw_bg.png)

This is an `I-frame` and we **can't use previous frames** to predict from but we still can compress it. We will encode the red block selection. If we **look at its neighbors**, we can **estimate** that there is a **trend of colors around it**.

![](/i/smw_bg_block.png)

We will **predict** that the frame will continue to **spread the colors vertically**, it means that the colors of the **unknown pixels will hold the values of its neighbors**.

![](/i/smw_bg_prediction.png)

Our **prediction can be wrong**, for that reason we need to apply this technique (**intra prediction**) and then **subtract the real values** which gives us the residual block, resulting in a much more compressible matrix compared to the original.

![](/i/smw_residual.png)

There are many different types of this sort of prediction. The one you see pictured here is a form of straight planar prediction, where the pixels from the row above the block are copied row to row within the block. Planar prediction also can involve an angular component, where pixels from both the left and the top are used to help predict the current block. And there is also DC prediction, which involves taking the average of the samples right above and to the left of the block. 

> #### Hands-on: Check intra predictions
> You can [generate a video with macro blocks and their predictions with ffmpeg.](/encoding_pratical_examples.md#generate-debug-video) Please check the ffmpeg documentation to understand the [meaning of each block color](https://trac.ffmpeg.org/wiki/Debug/MacroblocksAndMotionVectors#AnalyzingMacroblockTypes).
>
> ![intra prediction (macro blocks) with ffmpeg](/i/macro_blocks_ffmpeg.png "inter prediction (motion vectors) with ffmpeg")
>
> Or we can use the [Intel Video Pro Analyzer](https://software.intel.com/en-us/intel-video-pro-analyzer) (which is paid but there is a free trial version which limits you to only work with the first 10 frames).
>
> ![intra prediction intel video pro analyzer](/i/intra_prediction_intel_video_pro_analyzer.png "intra prediction intel video pro analyzer")

# How does a video codec work?

## What? Why? How?

**What?** It's a piece of software / hardware that compresses or decompresses digital video. **Why?** Market and society demands higher quality videos with limited bandwidth or storage. Remember when we [calculated the needed bandwidth](#basic-terminology) for 30 frames per second, 24 bits per pixel, resolution of a 480x240 video? It was **82.944 Mbps** with no compression applied. It's the only way to deliver HD/FullHD/4K in TVs and the Internet. **How?** We'll take a brief look at the major techniques here.

> **CODEC vs Container**
>
> One common mistake that beginners often do is to confuse digital video CODEC and [digital video container](https://en.wikipedia.org/wiki/Digital_container_format). We can think of **containers** as a wrapper format which contains metadata of the video (and possible audio too), and the **compressed video** can be seen as its payload.
>
> Usually, the extension of a video file defines its video container. For instance, the file `video.mp4` is probably a **[MPEG-4 Part 14](https://en.wikipedia.org/wiki/MPEG-4_Part_14)** container and a file named `video.mkv` it's probably a **[matroska](https://en.wikipedia.org/wiki/Matroska)**. To be completely sure about the codec and container format we can use [ffmpeg or mediainfo](/encoding_pratical_examples.md#inspect-stream).

## History

Before we jump into the inner workings of a generic codec, let's look back to understand a little better about some old video codecs.

The video codec [H.261](https://en.wikipedia.org/wiki/H.261)  was born in 1990 (technically 1988), and it was designed to work with **data rates of 64 kbit/s**. It already uses ideas such as chroma subsampling, macro block, etc. In the year of 1995, the **H.263** video codec standard was published and continued to be extended until 2001.

In 2003 the first version of **H.264/AVC** was completed. In the same year, **On2 Technologies**  (formerly known as the Duck Corporation) released their video codec as a **royalty-free** lossy video compression called **VP3**. In 2008, **Google bought** this company, releasing **VP8** in the same year. In December of 2012, Google released the **VP9** and it's  **supported by roughly ¾ of the browser market** (mobile included).

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
> The [alliance for open media](http://aomedia.org/about/) was created by companies from hardware manufacturer (Intel, AMD, ARM , Nvidia, Cisco), content delivery (Google, Netflix, Amazon), browser maintainers (Google, Mozilla), and others.
>
> The companies had a common goal, a royalty-free video codec and then AV1 was born with a much [simpler patent license](http://aomedia.org/license/patent/). **Timothy B. Terriberry** did an awesome presentation, which is the source of this section, about the [AV1 conception, license model and its current state](https://www.youtube.com/watch?v=lzPaldsmJbk).
>
> You'll be surprised to know that you can **analyze the AV1 codec through your browser**, go to https://arewecompressedyet.com/analyzer/
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
> We can also use the [Intel Video Pro Analyzer](https://software.intel.com/en-us/intel-video-pro-analyzer) (which is paid but there is a free trial version which limits you to only work with the first 10 frames). Here are [VP9 partitions](/encoding_pratical_examples.md#transcoding) analyzed.
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

As you can see it looks nothing like the original image, we might notice that the **first coefficient** is very different from all the others. This first coefficient is known as the DC coefficient which represents **all the samples** in the input array, something **similar to an average**.

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

The second byte (`binary=01100100, hex=0x64, dec=100`) of an SPS NAL is the field **profile_idc** which shows the profile that the encoder has used, in this case, we used the **[high profile](https://en.wikipedia.org/wiki/H.264/MPEG-4_AVC#Profiles)**. Also the third byte contains several flags which determine the exact profile (like constrained or progressive). But in our case the third byte is 0x00 and therefore the encoder has used just high profile.

![SPS binary view](/i/minimal_yuv420_bin.png "SPS binary view")

When we read the H.264 bitstream spec for an SPS NAL we'll find many values for the **parameter name**, **category** and a **description**, for instance, let's look at `pic_width_in_mbs_minus_1` and `pic_height_in_map_units_minus_1` fields.

| Parameter name  | Category  |  Description  |
|---  |---|---|
| pic_width_in_mbs_minus_1 |  0 | ue(v) |
| pic_height_in_map_units_minus_1 |  0 | ue(v) |

> **ue(v)**: unsigned integer [Exp-Golomb-coded](https://ghostarchive.org/archive/JBwdI)

If we do some math with the value of these fields we will end up with the **resolution**. We can represent a `1920 x 1080` using a `pic_width_in_mbs_minus_1` with the value of `119 ( (119 + 1) * macroblock_size = 120 * 16 = 1920) `, again saving space, instead of encode `1920` we did it with `119`.

If we continue to examine our created video with a binary view (ex: `xxd -b -c 11 v/minimal_yuv420.h264`), we can skip to the last NAL which is the frame itself.

![h264 idr slice header](/i/slice_nal_idr_bin.png "h264 idr slice header")

We can see its first 6 bytes values: `01100101 10001000 10000100 00000000 00100001 11111111`. As we already know the first byte tell us about what type of NAL it is, in this case, (`00101`) it's an **IDR Slice (5)** and we can further inspect it:

![h264 slice header spec](/i/slice_header.png "h264 slice header spec")

Using the spec info we can decode what type of slice (**slice_type**), the frame number (**frame_num**) among others important fields.

In order to get the values of some fields (`ue(v), me(v), se(v) or te(v)`) we need to decode it using a special decoder called [Exponential-Golomb](https://ghostarchive.org/archive/JBwdI), this method is **very efficient to encode variable values**, mostly when there are many default values.

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
> We can also use the [Intel Video Pro Analyzer](https://software.intel.com/en-us/intel-video-pro-analyzer) which is paid but there is a free trial version which limits you to only work with the first 10 frames but that's okay for learning purposes.
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

HEVC has bigger and more **partitions** (and **sub-partitions**) options than AVC, more **intra predictions directions/angles**, **improved entropy coding** and more, all these improvements made H.265 capable to compress 50% more than H.264.

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

DRM means [Digital rights management](https://sander.saares.eu/categories/drm-is-not-a-black-box/), it's a way **to provide copyright protection for digital media**, for instance, digital video and audio. Although it's used in many places [it's not universally accepted](https://en.wikipedia.org/wiki/Digital_rights_management#DRM-free_works).

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
* https://wiki.multimedia.cx
* https://mahanstreamer.net
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
* https://www.amazon.com/High-Efficiency-Video-Coding-HEVC/dp/3319068946
* https://www.amazon.com/Practical-Guide-Video-Audio-Compression/dp/0240806301/ref=sr_1_3?s=books&ie=UTF8&qid=1486396914&sr=1-3&keywords=A+PRACTICAL+GUIDE+TO+VIDEO+AUDIO
* https://www.amazon.com/Video-Encoding-Numbers-Eliminate-Guesswork/dp/0998453005/ref=sr_1_1?s=books&ie=UTF8&qid=1486396940&sr=1-1&keywords=jan+ozer

Onboarding material:

* https://github.com/Eyevinn/streaming-onboarding
* https://howvideo.works/
* https://www.aws.training/Details/eLearning?id=17775
* https://www.aws.training/Details/eLearning?id=17887
* https://www.aws.training/Details/Video?id=24750

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
* https://mediaarea.net/en/MediaInfo
* https://www.jongbel.com/
* https://trac.ffmpeg.org/wiki/
* https://software.intel.com/en-us/intel-video-pro-analyzer
* https://medium.com/@mbebenita/av1-bitstream-analyzer-d25f1c27072b#.d5a89oxz8

Non-ITU Codecs:

* https://aomedia.googlesource.com/
* https://github.com/webmproject/libvpx/tree/master/vp9
* https://ghostarchive.org/archive/0W0d8 (was: https://people.xiph.org/~xiphmont/demo/daala/demo1.shtml)
* https://people.xiph.org/~jm/daala/revisiting/
* https://www.youtube.com/watch?v=lzPaldsmJbk
* https://fosdem.org/2017/schedule/event/om_av1/
* https://jmvalin.ca/papers/AV1_tools.pdf

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
* https://videoblerg.wordpress.com/2017/11/10/ffmpeg-and-how-to-use-it-wrong/

Video Sequences for Testing:

* http://bbb3d.renderfarming.net/download.html
* https://www.its.bldrdoc.gov/vqeg/video-datasets-and-organizations.aspx

Miscellaneous:

* https://github.com/Eyevinn/streaming-onboarding
* http://stackoverflow.com/a/24890903
* http://stackoverflow.com/questions/38094302/how-to-understand-header-of-h264
* http://techblog.netflix.com/2016/08/a-large-scale-comparison-of-x264-x265.html
* http://vanseodesign.com/web-design/color-luminance/
* http://www.biologymad.com/nervoussystem/eyenotes.htm
* http://www.compression.ru/video/codec_comparison/h264_2012/mpeg4_avc_h264_video_codecs_comparison.pdf
* https://web.archive.org/web/20100728070421/http://www.csc.villanova.edu/~rschumey/csc4800/dct.html (was: http://www.csc.villanova.edu/~rschumey/csc4800/dct.html)
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
