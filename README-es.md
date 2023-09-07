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
  * [Redundancia Temporal (inter prediction)](#redundancia-temporal-inter-prediction)
      - [Práctica: Observa los vectores de movimiento](#práctica-observa-los-vectores-de-movimiento)
  * [Redundancia Espacial (intra prediction)](#redundancia-espacial-intra-prediction)
      - [Práctica: Observa las intra predictions](#práctica-observa-las-intra-predictions)
- [¿Cómo funciona un códec de vídeo?](#cómo-funciona-un-códec-de-vídeo)
  * [¿Qué? ¿Por qué? ¿Cómo?](#qué-por-qué-cómo)
  * [Historia](#historia)
    + [El nacimiento de AV1](#el-nacimiento-de-av1)
  * [Un códec genérico](#un-códec-genérico)
  * [Paso 1 - Particionado de imágenes](#paso-1---particionado-de-imágenes)
    + [Práctica: Verificar particiones](#práctica-verificar-particiones)
  * [Paso 2 - Predicciones](#paso-2---predicciones)
  * [Paso 3 - Transformación](#paso-3---transformación)
    + [Práctica: Descartar diferentes coeficientes](#práctica-descartar-diferentes-coeficientes)
  * [Paso 4 - Cuantización](#paso-4---cuantización)
    + [Práctica: Cuantización](#práctica-cuantización)
  * [Paso 5 - Codificación de la entropía](#paso-5---codificación-de-la-entropía)
    + [Codificación VLC](#codificación-vlc)
    + [Codificación aritmética](#codificación-aritmética)
    + [Práctica: CABAC vs CAVLC](#práctica-cabac-vs-cavlc)
  * [Paso 6 - formato *bitstream*](#paso-6---formato-bitstream)
    + [H.264 bitstream](#h264-bitstream)
    + [Práctica: Inspeccionar el *bitstream* H.264](#práctica-inspeccionar-el-bitstream-h264)
  * [Repaso](#repaso)
  * [¿Cómo logra H.265 una mejor relación de compresión que H.264?](#cómo-logra-h265-una-mejor-relación-de-compresión-que-h264)
- [Online streaming](#online-streaming)
  * [Arquitectura general](#arquitectura-general)
  * [Descarga progresiva y streaming adaptativo](#descarga-progresiva-y-streaming-adaptativo)
  * [Protección de contenido](#protección-de-contenido)
- [¿Cómo usar jupyter?](#cómo-usar-jupyter)
- [Conferencias](#conferencias)
- [Referencias](#referencias)

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

## Redundancia temporal (inter prediction)

Vamos a explorar las opciones que tenemos para reducir las **repeticiones en el tiempo**, este tipo de redundancia se puede resolver con técnicas de **interpredicción**.

Intentaremos **utilizar menos bits** para codificar la secuencia de los fotogramas 0 y 1.

![original frames](/i/original_frames.png "original frames")

Una cosa que podemos hacer es una resta, simplemente **restamos el fotograma 1 del fotograma 0** y obtenemos lo que necesitamos para **codificar el residual**.

![delta frames](/i/difference_frames.png "delta frames")

Pero, ¿qué pasa si te digo que hay un **método mejor** que utiliza incluso menos bits? Primero, tratemos el `fotograma 0` como una colección de particiones bien definidas y luego intentaremos emparejar los bloques del `fotograma 0` en el `fotograma 1`. Podemos pensar en ello como una **estimación de movimiento**.

> ### Wikipedia - compensación de movimiento por bloques
> "La **compensación de movimiento por bloques** divide el fotograma actual en bloques no superpuestos, y el vector de compensación de movimiento **indica de dónde provienen esos bloques** (una idea errónea común es que el fotograma anterior se divide en bloques no superpuestos y los vectores de compensación de movimiento indican hacia dónde se mueven esos bloques). Los bloques de origen suelen superponerse en el fotograma fuente. Algunos algoritmos de compresión de vídeo ensamblan el fotograma actual a partir de piezas de varios fotogramas previamente transmitidos."

![delta frames](/i/original_frames_motion_estimation.png "delta frames")

Podríamos estimar que la pelota se movió de `x=0, y=25` a `x=6, y=26`, los valores de **x** e **y** son los **vectores de movimiento**. Un **paso adicional** que podemos dar para ahorrar bits es **codificar solo la diferencia del vector de movimiento** entre la última posición del bloque y la predicción, por lo que el vector de movimiento final sería `x=6 (6-0), y=1 (26-25)`.

> En una situación del mundo real, esta **pelota se dividiría en n particiones**, pero el proceso es el mismo.

Los objetos en el fotograma se **mueven de manera tridimensional**, la pelota puede volverse más pequeña cuando se mueve al fondo. Es normal que no encontremos una coincidencia perfecta con el bloque que intentamos encontrar. Aquí hay una vista superpuesta de nuestra estimación frente a la imagen real.

![motion estimation](/i/motion_estimation.png "motion estimation")

Pero podemos ver que cuando aplicamos la **estimación de movimiento**, los **datos a codificar son más pequeños** que cuando simplemente usamos técnicas de fotograma delta.

![motion estimation vs delta ](/i/comparison_delta_vs_motion_estimation.png "motion estimation delta")

> ### Cómo se vería la compensación de movimiento real
> Esta técnica se aplica a todos los bloques, muy a menudo una pelota se dividiría en más de un bloque.
>  ![real world motion compensation](/i/real_world_motion_compensation.png "real world motion compensation")
> Fuente: https://web.stanford.edu/class/ee398a/handouts/lectures/EE398a_MotionEstimation_2012.pdf

Puedes [experimentar con estos conceptos utilizando jupyter](/frame_difference_vs_motion_estimation_plus_residual.ipynb).

> #### Práctica: Observa los vectores de movimiento
> Podemos [generar un vídeo con la interpredicción (vectores de movimiento) con ffmpeg.](/encoding_pratical_examples.md#generate-debug-video)
>
> ![inter prediction (motion vectors) with ffmpeg](/i/motion_vectors_ffmpeg.png "inter prediction (motion vectors) with ffmpeg")
>
> O podemos usar el [Intel Video Pro Analyzer](https://software.intel.com/en-us/intel-video-pro-analyzer) (que es de pago, pero hay una versión de prueba gratuita que te limita a trabajar solo con los primeros 10 fotogramas).
>
> ![inter prediction intel video pro analyzer](/i/inter_prediction_intel_video_pro_analyzer.png "inter prediction intel video pro analyzer")

## Redundancia Espacial (intra prediction)

Si analizamos **cada fotograma** en un vídeo, veremos que también hay **muchas áreas que están correlacionadas**.

![](/i/repetitions_in_space.png)

Vamos a través de un ejemplo. Esta escena está compuesta principalmente por colores azules y blancos.

![](/i/smw_bg.png)

Este es un `I-frame` y **no podemos usar fotogramas anteriores** para hacer una predicción, pero aún podemos comprimirlo. Codificaremos la selección de bloques en rojo. Si **observamos a sus vecinos**, podemos **estimar** que hay una **tendencia de colores a su alrededor**.

![](/i/smw_bg_block.png)

Vamos a **predecir** que el fotograma continuará **extendiendo los colores verticalmente**, lo que significa que los colores de los **píxeles desconocidos mantendrán los valores de sus vecinos**.

![](/i/smw_bg_prediction.png)

Nuestra **predicción puede ser incorrecta**, por esa razón necesitamos aplicar esta técnica (**intra prediction**) y luego **restar los valores reales**, lo que nos da el bloque residual, lo que resulta en una matriz mucho más compresible en comparación con la original.

![](/i/smw_residual.png)

Existen muchos tipos diferentes de este tipo de predicción. La que se muestra aquí es una forma de predicción plana recta, donde los píxeles de la fila superior del bloque se copian fila por fila dentro del bloque. La predicción plana también puede tener una componente angular, donde se utilizan píxeles tanto de la izquierda como de la parte superior para ayudar a predecir el bloque actual. Y también existe la predicción DC, que implica tomar el promedio de las muestras justo arriba y a la izquierda del bloque.

> #### Práctica: Observa las intra predictions
> Puedes [generar con ffmpeg un vídeo con macrobloques y sus predicciones.](/encoding_pratical_examples.md#generate-debug-video) Por favor verifica la documentación de ffmpeg para comprender el [significado de cada bloque de color](https://trac.ffmpeg.org/wiki/Debug/MacroblocksAndMotionVectors?version=7#AnalyzingMacroblockTypes).
>
> ![intra prediction (macro blocks) with ffmpeg](/i/macro_blocks_ffmpeg.png "inter prediction (motion vectors) with ffmpeg")
>
> O puedes usar [Intel Video Pro Analyzer](https://software.intel.com/en-us/intel-video-pro-analyzer) (que es de pago, pero hay una versión de prueba gratuita que te limita a trabajar solo con los primeros 10 fotogramas).
>
> ![intra prediction intel video pro analyzer](/i/intra_prediction_intel_video_pro_analyzer.png "intra prediction intel video pro analyzer")

# ¿Cómo funciona un códec de vídeo?

## ¿Qué? ¿Por qué? ¿Cómo?

**¿Qué?** Es un software o hardware que comprime o descomprime vídeo digital. **¿Por qué?** El mercado y la sociedad demandan vídeos de mayor calidad con ancho de banda o almacenamiento limitados. ¿Recuerdas cuando [calculamos el ancho de banda necesario](#terminología-básica) para 30 fps, 24 bits por píxel, resolución de un vídeo de 480x240? Fueron **82.944 Mbps** sin aplicar compresión. Es la única forma de entregar HD/FullHD/4K en televisores e Internet. **¿Cómo?** Echaremos un vistazo breve a las técnicas principales aquí.

> **CODEC vs Contenedor**
>
> Un error común que cometen los principiantes es confundir el CODEC de vídeo digital y el [contenedor de vídeo digital](https://en.wikipedia.org/wiki/Container_format). Podemos pensar en los **contenedores** como un formato que contiene metadatos del vídeo (y posiblemente también audio), y el **vídeo comprimido** se puede ver como su contenido.
>
> Por lo general, la extensión de un archivo de vídeo define su contenedor de vídeo. Por ejemplo, el archivo `video.mp4` probablemente es un contenedor **[MPEG-4 Part 14](https://en.wikipedia.org/wiki/MP4_file_format)** y un archivo llamado `video.mkv` probablemente es un **[matroska](https://en.wikipedia.org/wiki/Matroska)**. Para estar completamente seguro sobre el códec y el formato del contenedor, podemos usar [ffmpeg o mediainfo](/encoding_pratical_examples.md#inspect-stream).

## Historia

Antes de adentrarnos en el funcionamiento interno de un códec genérico, echemos un vistazo atrás para comprender un poco mejor algunos códecs de vídeo antiguos.

El códec de vídeo [H.261](https://en.wikipedia.org/wiki/H.261) nació en 1990 (técnicamente en 1988) y fue diseñado para trabajar con **tasas de datos de 64 kbit/s**. Ya utilizaba ideas como el *chroma subsampling*, el macrobloque, etc. En el año 1995, se publicó el estándar de códec de vídeo **H.263** y continuó siendo extendido hasta 2001.

En 2003 se completó la primera versión de **H.264/AVC**. En el mismo año, **On2 Technologies** (anteriormente conocida como Duck Corporation) lanzó su códec de vídeo como una compresión de vídeo con pérdida **libre de regalías** llamada **VP3**. En 2008, **Google compró** esta empresa y lanzó **VP8** en el mismo año. En diciembre de 2012, Google lanzó **VP9**, el cual es **compatible con aproximadamente el ¾ del mercado de navegadores** (incluyendo móviles).

  **[AV1](https://en.wikipedia.org/wiki/AOMedia_Video_1)** es un nuevo códec de vídeo **libre de regalías** y de código abierto que está siendo diseñado por la [Alliance for Open Media (AOMedia)](http://aomedia.org/), la cual está compuesta por **empresas como Google, Mozilla, Microsoft, Amazon, Netflix, AMD, ARM, NVidia, Intel y Cisco**, entre otras. La **primera versión**, 0.1.0 del códec de referencia, **se publicó el 7 de abril de 2016**.

![codec history timeline](/i/codec_history_timeline.png "codec history timeline")

> #### El nacimiento de AV1
>
> A principios de 2015, Google estaba trabajando en [VP10](https://en.wikipedia.org/wiki/VP9#Successor:_from_VP10_to_AV1), Xiph (Mozilla) estaba trabajando en [Daala](https://xiph.org/daala/) y Cisco lanzó su códec de video libre de regalías llamado [Thor](https://tools.ietf.org/html/draft-fuldseth-netvc-thor-03).
>
> Entonces, MPEG LA anunció por primera vez límites anuales para HEVC (H.265) y tarifas 8 veces más altas que H.264, pero pronto cambiaron las reglas nuevamente:
> * **sin límite anual**,
> * **tarifa por contenido** (0.5% de los ingresos) y
> * **tarifas por unidad aproximadamente 10 veces más altas que H.264**.
>
> La [Alliance for Open Media](http://aomedia.org/about/) fue creada por empresas de fabricantes de hardware (Intel, AMD, ARM, Nvidia, Cisco), distribución de contenido (Google, Netflix, Amazon), mantenimiento de navegadores (Google, Mozilla) y otros.
>
> Las empresas tenían un objetivo común, un códec de vídeo libre de regalías, y así nació AV1 con una [licencia de patente mucho más simple](http://aomedia.org/license/patent/). **Timothy B. Terriberry** hizo una excelente presentación, que es la fuente de esta sección, sobre la [concepción de AV1, el modelo de licencia y su estado actual](https://www.youtube.com/watch?v=lzPaldsmJbk).
>
> Te sorprenderá saber que puedes **analizar el códec AV1 a través de tu navegador**, visita https://arewecompressedyet.com/analyzer/
>
> ![av1 browser analyzer](/i/av1_browser_analyzer.png "av1 browser analyzer")
>
> PD: Si deseas aprender más sobre la historia de los códecs, debes comprender los conceptos básicos detrás de las [patentes de compresión de vídeo](https://www.vcodex.com/video-compression-patents/).

## Un códec genérico

Vamos a presentar los **mecanismos principales detrás de un códec de vídeo genérico**, pero la mayoría de estos conceptos son útiles y se utilizan en códecs modernos como VP9, AV1 y HEVC. Asegúrate de entender que vamos a simplificar las cosas MUCHO. A veces usaremos un ejemplo real (principalmente H.264) para demostrar una técnica.

## Paso 1 - Particionado de imágenes

El primer paso es **dividir el fotograma** en varias **particiones, sub-particiones** y más allá.

![picture partitioning](/i/picture_partitioning.png "picture partitioning")

Pero, **¿por qué?**. Hay muchas razones, por ejemplo, cuando dividimos la imagen, podemos trabajar las predicciones de manera más precisa, utilizando pequeñas particiones para las partes móviles y particiones más grandes para un fondo estático.

Por lo general, los códecs **organizan estas particiones** en *slices* (o *tiles*), macrobloques (o unidades de árbol de codificación) y muchas sub-particiones. El tamaño máximo de estas particiones varía, HEVC establece 64x64 mientras que AVC usa 16x16, pero las sub-particiones pueden alcanzar tamaños de 4x4.

¿Recuerdas que aprendimos cómo se **clasifican los fotogramas**? Bueno, también puedes **aplicar esas ideas a los bloques**, por lo tanto, podemos tener *I-Slice*, *B-Slice*, *I-Macroblock*, etc.

> ### Práctica: Verificar particiones
> Podemos usar [Intel Video Pro Analyzer](https://software.intel.com/en-us/intel-video-pro-analyzer)  (que es de pago, pero hay una versión de prueba gratuita que limita el trabajo a los primeros 10 fotogramas). Aquí se analizan las [particiones de VP90](/encoding_pratical_examples.md#transcoding).
>
> ![VP9 partitions view intel video pro analyzer ](/i/paritions_view_intel_video_pro_analyzer.png "VP9 partitions view intel video pro analyzer")

## Paso 2 - Predicciones

Una vez que tenemos las particiones, podemos hacer predicciones sobre ellas. Para la [inter prediction](#redundancia-temporal-inter-prediction), necesitamos **enviar los vectores de movimiento y el residual**, y para la [intra prediction](#redundancia-espacial-intra-prediction), **enviaremos la dirección de predicción y el residual** también.

## Paso 3 - Transformación

Después de obtener el bloque residual (`partición predicha - partición real`), podemos **transformarlo** de tal manera que nos permita saber cuáles **píxeles podemos descartar** mientras mantenemos la **calidad general**. Hay algunas transformaciones para este comportamiento específico.

Aunque existen [otras transformaciones](https://en.wikipedia.org/wiki/List_of_Fourier-related_transforms#Discrete_transforms), examinaremos más de cerca la transformada coseno discreta (DCT). Las principales características de la [**DCT**](https://en.wikipedia.org/wiki/Discrete_cosine_transform) son las siguientes:

* **convierte** bloques de **píxeles** en bloques del mismo tamaño de los **coeficientes de frecuencia**.
* **compacta** la energía, lo que facilita eliminar la redundancia espacial.
* es **reversible**, es decir, se puede revertir a píxeles.

> El 2 de febrero de 2017, Cintra, R. J. y Bayer, F. M publicaron su artículo [DCT-like Transform for Image Compression Requires 14 Additions Only](https://arxiv.org/abs/1702.00817).

No te preocupes si no comprendiste los beneficios de cada punto, intentaremos realizar algunos experimentos para ver el valor real de esto.

Tomemos el siguiente **bloque de píxeles** (8x8):

![pixel values matrix](/i/pixel_matrice.png "pixel values matrix")

Lo cual se representa en la siguiente imagen de bloque (8x8):

![pixel values matrix](/i/gray_image.png "pixel values matrix")

Cuando **aplicamos la DCT** a este bloque de píxeles, obtenemos el **bloque de coeficientes** (8x8):

![coefficients values](/i/dct_coefficient_values.png "coefficients values")

Y si representamos este bloque de coeficientes, obtendremos esta imagen:

![dct coefficients image](/i/dct_coefficient_image.png "dct coefficients image")

Como puedes ver, no se parece en nada a la imagen original, podríamos notar que el **primer coeficiente** es muy diferente de todos los demás. Este primer coeficiente se conoce como el coeficiente DC, que representa **todas las muestras** en el array de entrada, algo **similar a un promedio**.

Este bloque de coeficientes tiene una propiedad interesante, que es que separa los componentes de alta frecuencia de los de baja frecuencia.

![dct frequency coefficients property](/i/dctfrequ.jpg "dct frequency coefficients property")

En una imagen, la **mayor parte de la energía** se concentrará en las [**frecuencias más bajas**](https://web.archive.org/web/20150129171151/https://www.iem.thm.de/telekom-labor/zinke/mk/mpeg2beg/whatisit.htm), por lo que si transformamos una imagen en sus componentes de frecuencia y **eliminamos los coeficientes de frecuencia más altos**, podemos r**educir la cantidad de datos necesarios** para describir la imagen sin sacrificar demasiada calidad de imagen.

> La frecuencia significa cuán rápido cambia una señal.

Intentemos aplicar el conocimiento que adquirimos en la prueba, convirtiendo la imagen original a su dominio de frecuencia (bloque de coeficientes) usando DCT y luego descartando parte (67%) de los coeficientes menos importantes, principalmente la parte inferior derecha.

Primero, lo convertimos a su **dominio de frecuencia**.

![coefficients values](/i/dct_coefficient_values.png "coefficients values")

A continuación, descartamos parte (67%) de los coeficientes, principalmente la parte inferior derecha.

![zeroed coefficients](/i/dct_coefficient_zeroed.png "zeroed coefficients")

Finalmente, reconstruimos la imagen a partir de este bloque de coeficientes descartados (recuerda, debe ser reversible) y la comparamos con la original.

![original vs quantized](/i/original_vs_quantized.png "original vs quantized")

Como podemos ver, se asemeja a la imagen original pero introduce muchas diferencias con respecto a la original. **Descartamos el 67.1875%** y aún así pudimos obtener algo similar a la original. Podríamos descartar de manera más inteligente los coeficientes para tener una mejor calidad de imagen, pero eso es el próximo tema.

> **Cada coeficiente se forma utilizando todos los píxeles**
>
> Es importante destacar que cada coeficiente no se asigna directamente a un solo píxel, sino que es una suma ponderada de todos los píxeles. Este gráfico asombroso muestra cómo se calcula el primer y segundo coeficiente, utilizando pesos únicos para cada índice.
>
> ![dct calculation](/i/applicat.jpg "dct calculation")
>
> Fuente: https://web.archive.org/web/20150129171151/https://www.iem.thm.de/telekom-labor/zinke/mk/mpeg2beg/whatisit.htm
>
> También puedes intentar [visualizar la DCT mirando una imagen simple](/dct_better_explained.ipynb) formada sobre la base de la DCT. Por ejemplo, aquí tienes cómo [se forma el carácter A](https://en.wikipedia.org/wiki/Discrete_cosine_transform#Example_of_IDCT) utilizando el peso de cada coeficiente.
>
> ![](https://upload.wikimedia.org/wikipedia/commons/5/5e/Idct-animation.gif )




<br/>

> ### Práctica: Descartar diferentes coeficientes
> Puedes jugar con la [transformación DCT](/uniform_quantization_experience.ipynb).

## Paso 4 - Cuantización

Cuando descartamos algunos de los coeficientes en el último paso (transformación), de alguna manera hicimos una forma de cuantización. En este paso es donde elegimos perder información (la **parte perdida**) o, en términos simples, **cuantificamos coeficientes para lograr la compresión**.

¿Cómo podemos cuantificar un bloque de coeficientes? Un método simple sería una cuantificación uniforme, donde tomamos un bloque, lo **dividimos por un valor único** (10) y redondeamos este valor.

![quantize](/i/quantize.png "quantize")

¿Cómo podemos **revertir** (re-cuantificar) este bloque de coeficientes? Podemos hacerlo **multiplicando el mismo valor** (10) por el que lo dividimos inicialmente.

![re-quantize](/i/re-quantize.png "re-quantize")

Este **enfoque no es el mejor** porque no tiene en cuenta la importancia de cada coeficiente. Podríamos usar una **matriz de cuantizadores** en lugar de un solo valor. Esta matriz puede explotar la propiedad de la DCT, cuantificando más los coeficientes de la parte inferior derecha y menos los de la parte superior izquierda. El [JPEG utiliza un enfoque similar](https://www.hdm-stuttgart.de/~maucher/Python/MMCodecs/html/jpegUpToQuant.html); puedes consultar el [código fuente para ver esta matriz](https://github.com/google/guetzli/blob/master/guetzli/jpeg_data.h#L40).

> ### Práctica: Cuantización
> Puedes experimentar con la [cuantización aquí](/dct_experiences.ipynb).

## Paso 5 - Codificación de la entropía

Después de cuantificar los datos (bloques/slices/fotogramas de imágenes), aún podemos comprimirlos de manera sin pérdida. Hay muchas formas (algoritmos) de comprimir datos. Vamos a experimentar brevemente con algunos de ellos. Para una comprensión más profunda, puedes leer el increíble libro [Understanding Compression: Data Compression for Modern Developers](https://www.amazon.com/Understanding-Compression-Data-Modern-Developers/dp/1491961538/).

### Codificación VLC

Supongamos que tenemos una secuencia de símbolos: **a**, **e**, **r** y **t**; y su probabilidad (de 0 a 1) se representa en esta tabla.

|             | a   | e   | r    | t   |
|-------------|-----|-----|------|-----|
| probabilidad| 0.3 | 0.3 | 0.2 |  0.2 |

Podemos asignar códigos binarios únicos (preferiblemente pequeños) a los más probables y códigos más grandes a los menos probables.

|             | a   | e   | r    | t   |
|-------------|-----|-----|------|-----|
| probabilidad | 0.3 | 0.3 | 0.2 | 0.2 |
| código binario | 0 | 10 | 110 | 1110 |

Comprimamos la secuencia **eat**, asumiendo que gastaríamos 8 bits para cada símbolo, gastaríamos **24 bits** sin ninguna compresión. Pero en caso de que reemplacemos cada símbolo por su código, podemos ahorrar espacio.

El primer paso es codificar el símbolo **e**, que es `10`, y el segundo símbolo es **a**, que se agrega (no en un sentido matemático) como `[10][0]`, y finalmente el tercer símbolo **t**, lo que hace que nuestra secuencia de bits comprimida final sea `[10][0][1110]` o `1001110`, que solo requiere **7 bits** (3.4 veces menos espacio que el original).

Observa que cada código debe ser un código único y prefijado [Huffman puede ayudarte a encontrar estos números](https://en.wikipedia.org/wiki/Huffman_coding). Aunque tiene algunos problemas, todavía hay [códecs de vídeo que ofrecen este método](https://en.wikipedia.org/wiki/Context-adaptive_variable-length_coding) y es el algoritmo para muchas aplicaciones que requieren compresión.

Tanto el codificador como el decodificador **deben conocer** la tabla de símbolos con sus códigos, por lo tanto, también debes enviar la tabla.

### Codificación aritmética

Supongamos que tenemos una secuencia de símbolos: **a**, **e**, **r**, **s** y **t**; y su probabilidad se representa en esta tabla.

|              | a   | e   | r    | s    | t   |
|--------------|-----|-----|------|------|-----|
| probabilidad | 0.3 | 0.3 | 0.15 | 0.05 | 0.2 |

Con esta tabla en mente, podemos construir rangos que contengan todos los posibles símbolos ordenados por los más frecuentes.

![initial arithmetic range](/i/range.png "initial arithmetic range")

Ahora codifiquemos la secuencia **eat**, tomamos el primer símbolo **e**, que se encuentra dentro del subrango **0.3 a 0.6** (pero no se incluye), y tomamos este subrango y lo dividimos nuevamente utilizando las mismas proporciones utilizadas anteriormente, pero dentro de este nuevo rango.

![second sub range](/i/second_subrange.png "second sub range")

Continuemos codificando nuestra secuencia **eat**, ahora tomamos el segundo símbolo **a**, que está dentro del nuevo subrango **0.3 a 0.39**, y luego tomamos nuestro último símbolo **t** y hacemos el mismo proceso nuevamente y obtenemos el último subrango **0.354 a 0.372**.

![final arithmetic range](/i/arithimetic_range.png "final arithmetic range")

Solo necesitamos elegir un número dentro del último subrango **0.354 a 0.372**, elijamos **0.36**, pero podríamos elegir cualquier número dentro de este subrango. Con **solo** este número podremos recuperar nuestra secuencia original **eat**. Si lo piensas, es como si estuviéramos dibujando una línea dentro de rangos de rangos para codificar nuestra secuencia.

![final range traverse](/i/range_show.png "final range traverse")

El **proceso inverso** (también conocido como decodificación) es igualmente sencillo, con nuestro número **0.36** y nuestro rango original, podemos realizar el mismo proceso pero ahora usando este número para revelar la secuencia codificada original detrás de este número.

Con el primer rango, notamos que nuestro número encaja en la porción, por lo tanto, es nuestro primer símbolo, ahora dividimos este subrango nuevamente, haciendo el mismo proceso que antes, y notamos que **0.36** encaja en el símbolo **a**, y después de repetir el proceso llegamos al último símbolo **t** (formando nuestra secuencia original codificada *eat*).

Tanto el codificador como el decodificador **tienen que conocer** la tabla de probabilidades de los símbolos, por lo tanto, también debes enviar la tabla.

¿Bastante ingenioso, verdad? Las personas son realmente inteligentes para idear una solución así. Algunos [códecs de vídeo utilizan esta técnica](https://en.wikipedia.org/wiki/Context-adaptive_binary_arithmetic_coding) (o al menos la ofrecen como opción).

La idea es comprimir sin pérdidas el flujo de bits cuantificados. Sin duda, este artículo carece de muchos detalles, razones, compensaciones, etc. Pero [puedes aprender más](https://www.amazon.com/Understanding-Compression-Data-Modern-Developers/dp/1491961538/). Los códecs más nuevos están tratando de utilizar diferentes[ algoritmos de codificación de entropía como ANS.](https://en.wikipedia.org/wiki/Asymmetric_Numeral_Systems)

> ### Práctica: CABAC vs CAVLC
> Puedes [generar 2 streams, uno con CABAC y otro con CAVLC](https://github.com/leandromoreira/introduction_video_technology/blob/master/encoding_pratical_examples.md#cabac-vs-cavlc) y **compara cuánto tiempo** toma generar cada uno de ellos, como así también el **tamaño final**.

## Paso 6 - formato *bitstream*

Después de completar todos estos pasos, necesitamos **empaquetar los fotogramas comprimidos y el contexto de estos pasos**. Debemos informar explícitamente al decodificador sobre **las decisiones tomadas por el codificador**, como el bit depth, el espacio de color, la resolución, la información de predicciones (vectores de movimiento, dirección de intra prediction), perfil, nivel, fps, tipo de fotograma, número de fotograma y mucho más.

Vamos a estudiar superficialmente el *bitstream* de H.264. Nuestro primer paso es [generar un *bitstream* H.264<sup>*</sup> mínimo](/encoding_pratical_examples.md#generate-a-single-frame-h264-bitstream), lo podemos hacer utilizando nuestro propio repositorio y [ffmpeg](http://ffmpeg.org/).

```
./s/ffmpeg -i /files/i/minimal.png -pix_fmt yuv420p /files/v/minimal_yuv420.h264
```

> <sup>*</sup> fmpeg agrega, por defecto, todos los parámetros de codificación como un **SEI NAL**, pronto definiremos qué es un NAL.

Este comando generará un *bitstream* H.264 en bruto con un **único fotograma**, de 64x64 píxeles, con espacio de color yuv420, utilizando la siguiente imagen como fotograma.

> ![used frame to generate minimal h264 bitstream](/i/minimal.png "used frame to generate minimal h264 bitstream")

### H.264 bitstream

El estándar AVC (H.264) define que la información se enviará en **macro frames** (en el sentido de red), llamadas **[NAL](https://en.wikipedia.org/wiki/Network_Abstraction_Layer)** (Network Abstraction Layer). El objetivo principal de la NAL es proporcionar una representación de vídeo "amigable para la red". Este estándar debe funcionar en televisores (basados en transmisión) y en Internet (basado en paquetes), entre otros.

![NAL units H.264](/i/nal_units.png "NAL units H.264")

Hay un **[marcador de sincronización](https://en.wikipedia.org/wiki/Frame_synchronization)** para definir los límites de las unidades NAL. Cada marcador de sincronización tiene un valor de `0x00 0x00 0x01`, excepto el primero, que es `0x00 0x00 0x00 0x01`. Si ejecutamos el comando **hexdump** en el flujo de bits H.264 generado, podemos identificar al menos tres NAL al principio del archivo.

![synchronization marker on NAL units](/i/minimal_yuv420_hex.png "synchronization marker on NAL units")

Como mencionamos antes, el decodificador necesita conocer no solo los datos de la imagen, sino también los detalles del vídeo, el fotograma, los colores, los parámetros utilizados y otros. El primer byte de cada NAL define su categoría y **tipo**.

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

Normalmente, el primer NAL de un flujo de bits es un **SPS** (Sequence Parameter Set). Este tipo de NAL es responsable de proporcionar información sobre las variables de codificación generales como **perfil**, **nivel**, **resolución** y otros.

Si omitimos el primer marcador de sincronización, podemos decodificar el **primer byte** para saber qué **tipo de NAL** es el primero.

Por ejemplo, el primer byte después del marcador de sincronización es `01100111`, donde el primer bit (`0`) es el campo **forbidden_zero_bit**, los siguientes 2 bits (`11`) nos indican el campo **nal_ref_idc**, que indica si este NAL es un campo de referencia o no, y los siguientes 5 bits (`00111`) nos informan sobre el campo **nal_unit_type**, en este caso, es un NAL de tipo **SPS** (7).

El segundo byte (`binary=01100100, hex=0x64, dec=100`) de un NAL SPS es el campo **profile_idc**, que muestra el perfil que el codificador ha utilizado. En este caso, hemos utilizado el **[high profile](https://en.wikipedia.org/wiki/H.264/MPEG-4_AVC#Profiles)**. Además, el tercer byte contiene varias banderas que determinan el perfil exacto (como restringido o progresivo). Pero en nuestro caso, el tercer byte es 0x00 y, por lo tanto, el codificador ha utilizado solo el *high profile*.

![SPS binary view](/i/minimal_yuv420_bin.png "SPS binary view")

Cuando leemos la especificación de flujo de bits H.264 para un NAL SPS, encontraremos muchos valores para el **parameter name**, **category** y **description**. Por ejemplo, veamos los campos `pic_width_in_mbs_minus_1` y `pic_height_in_map_units_minus_1`.

| Parameter name  | Category  |  Description  |
|---  |---|---|
| pic_width_in_mbs_minus_1 |  0 | ue(v) |
| pic_height_in_map_units_minus_1 |  0 | ue(v) |

> **ue(v)**: unsigned integer [Exp-Golomb-coded](https://ghostarchive.org/archive/JBwdI)

Si realizamos algunos cálculos con el valor de estos campos, obtendremos la **resolución**. Podemos representar `1920 x 1080` usando un valor de `pic_width_in_mbs_minus_1` de `119 ((119 + 1) * macroblock_size = 120 * 16 = 1920)`, nuevamente ahorrando espacio, en lugar de codificar `1920`, lo hicimos con `119`.

Si continuamos examinando nuestro vídeo creado con una vista binaria (por ejemplo, `xxd -b -c 11 v/minimal_yuv420.h264`), podemos saltar al último NAL que es el propio cuadro.

![h264 idr slice header](/i/slice_nal_idr_bin.png "h264 idr slice header")

Podemos ver los valores de sus primeros 6 bytes: `01100101 10001000 10000100 00000000 00100001 11111111`. Como ya sabemos, el primer byte nos dice qué tipo de NAL es, en este caso, (`00101`) es un **IDR Slice (5)** y podemos inspeccionarlo más a fondo:

![h264 slice header spec](/i/slice_header.png "h264 slice header spec")

Utilizando la información de la especificación, podemos decodificar qué tipo de slice (**slice_type**), el número de fotograma (**frame_num**) y otros campos importantes.

Para obtener los valores de algunos campos (`ue(v), me(v), se(v) o te(v)`), debemos decodificarlos utilizando un decodificador especial llamado [Exponential-Golomb](https://ghostarchive.org/archive/JBwdI). Este método es **muy eficiente para codificar valores variables**, sobre todo cuando hay muchos valores predeterminados.

> Los valores de **slice_type** y **frame_num** de este vídeo son 7 (I slice) y 0 (el primer fotograma).

Podemos ver el ***bitstream* como un protocolo**, y si deseas aprender más sobre este *bitstream*, consulta la especificación [ITU H.264]( http://www.itu.int/rec/T-REC-H.264-201610-I). Aquí tienes un diagrama macro que muestra dónde reside los datos de la imagen (YUV comprimido).

![h264 bitstream macro diagram](/i/h264_bitstream_macro_diagram.png "h264 bitstream macro diagram")

Podemos explorar otros *bitstreams* como el [*bitstreams* VP9](https://storage.googleapis.com/downloads.webmproject.org/docs/vp9/vp9-bitstream-specification-v0.6-20160331-draft.pdf), [H.265 (HEVC)](http://handle.itu.int/11.1002/1000/11885-en?locatt=format:pdf) o incluso nuestro **nuevo mejor amigo** el [*bitstream* AV1](https://medium.com/@mbebenita/av1-bitstream-analyzer-d25f1c27072b#.d5a89oxz8), [¿se ven todos similares, no?](http://www.gpac-licensing.com/2016/07/12/vp9-av1-bitstream-format/) Pero una vez que aprendes uno, puedes entender fácilmente los demás.

> ### Práctica: Inspeccionar el *bitstream* H.264
> Podemos [generar un video de un solo fotograma](https://github.com/leandromoreira/introduction_video_technology/blob/master/encoding_pratical_examples.md#generate-a-single-frame-video) y usar [mediainfo](https://en.wikipedia.org/wiki/MediaInfo) para inspeccionar su *bitstream* H.264. De hecho, incluso puedes ver el [código fuente que analiza el *bitstream* h264 (AVC)](https://github.com/MediaArea/MediaInfoLib/blob/master/Source/MediaInfo/Video/File_Avc.cpp).
>
> ![mediainfo details h264 bitstream](/i/mediainfo_details_1.png "mediainfo details h264 bitstream")
>
> También podemos utilizar el [Intel Video Pro Analyzer](https://software.intel.com/en-us/intel-video-pro-analyzer) que es de pago, pero hay una versión de prueba gratuita que limita el trabajo a solo los primeros 10 fotogramas, lo cual está bien para fines de aprendizaje.
>
> ![intel video pro analyzer details h264 bitstream](/i/intel-video-pro-analyzer.png "intel video pro analyzer details h264 bitstream")

## Repaso

Es evidente que muchos de los **códecs modernos utilizan el mismo modelo que aprendimos**. De hecho, echemos un vistazo al diagrama de bloques del códec de vídeo Thor, que contiene todos los pasos que estudiamos. La idea es que ahora deberías ser capaz de al menos comprender mejor las innovaciones y los documentos de esta área.

![thor_codec_block_diagram](/i/thor_codec_block_diagram.png "thor_codec_block_diagram")

Anteriormente calculamos que necesitaríamos [139GB de almacenamiento para mantener un archivo de vídeo de una hora a una resolución de 720p y 30 fps](#chroma-subsampling) si utilizamos las técnicas que aprendimos aquí, como **inter e intra predictions, transformación, cuantización, codificación de entropía y otras**. Podemos lograrlo, asumiendo que estamos utilizando **0.031 bit por píxel**, el mismo vídeo de calidad perceptible **requiriendo solo 367.82MB en lugar de 139GB** de almacenamiento.

> Elegimos usar **0.031 bit por píxel** basándonos en el ejemplo de vídeo proporcionado aquí.

## ¿Cómo logra H.265 una mejor relación de compresión que H.264?

Ahora que sabemos más sobre cómo funcionan los códecs, es fácil entender cómo los nuevos códecs pueden ofrecer mayores resoluciones con menos bits.

Compararemos AVC y HEVC, ten en cuenta que casi siempre hay un equilibrio entre más ciclos de CPU (complejidad) y la velocidad de compresión.

HEVC tiene más opciones de **particiones** (y **sub-particiones**) que AVC, más **direcciones/ángulos de intra predictions**, **codificación de entropía mejorada** y más, todas estas mejoras hicieron que H.265 fuera capaz de comprimir un 50% más que H.264.

![h264 vs h265](/i/avc_vs_hevc.png "H.264 vs H.265")

# Online streaming
## Arquitectura general

![general architecture](/i/general_architecture.png "general architecture")

[TODO]

## Descarga progresiva y streaming adaptativo

![progressive download](/i/progressive_download.png "progressive download")

![adaptive streaming](/i/adaptive_streaming.png "adaptive streaming")

[TODO]

## Protección de contenido

Podemos utilizar **un sistema de tokens simple** para proteger el contenido. El usuario sin un token intenta solicitar un video y la CDN (Red de Entrega de Contenido, del inglés *Content Delivery Network*) le prohíbe el acceso, mientras que un usuario con un token válido puede reproducir el contenido, funciona de manera bastante similar a la mayoría de los sistemas de autenticación web.

![token protection](/i/token_protection.png "token_protection")

El uso exclusivo de este sistema de tokens todavía permite que un usuario descargue un video y lo distribuya. Es aquí dónde, los sistemas de **DRM (gestión de derechos digitales, del inglés *digital rights management*)** se pueden utilizar para tratar de evitar esto.

![drm](/i/drm.png "drm")

En los sistemas de producción del mundo real, a menudo se utilizan ambas técnicas para proporcionar autorización y autenticación.

### DRM
#### Soluciones principales

* FPS - [**FairPlay Streaming**](https://developer.apple.com/streaming/fps/)
* PR - [**PlayReady**](https://www.microsoft.com/playready/)
* WV - [**Widevine**](http://www.widevine.com/)


#### ¿Qué es?

DRM significa [*Digital Rights Management* o gestión de derechos digitales](https://sander.saares.eu/categories/drm-is-not-a-black-box/), es una forma de proporcionar protección de derechos de autor para medios digitales, como vídeo y audio digitales. Aunque se utiliza en muchos lugares, no es universalmente aceptado.

#### ¿Por qué?

Los creadores de contenido (principalmente estudios) desean proteger su propiedad intelectual contra la copia para prevenir la redistribución no autorizada de medios digitales.

#### ¿Cómo?

Vamos a describir una forma abstracta y genérica de DRM de manera muy simplificada.

Dado un **contenido C1** (por ejemplo, un vídeo en streaming HLS o DASH), con un **reproductor P1** (por ejemplo, shaka-clappr, exo-player o iOS) en un **dispositivo D1** (por ejemplo, un teléfono inteligente, una televisión, una tableta o una computadora de escritorio/portátil) utilizando un **sistema DRM llamado DRM1** (widevine, playready o FairPlay).

El contenido C1 está encriptado con una **clave simétrica K1** del sistema DRM1, generando el **contenido encriptado C'1**.

![drm general flow](/i/drm_general_flow.jpeg "drm general flow")

El reproductor P1, de un dispositivo D1, tiene dos claves (asimétricas), una **clave privada PRK1** (esta clave está protegida<sup>1</sup> y solo la conoce **D1**) y una **clave pública PUK1**.

> <sup>1</sup>Protegida: esta protección puede ser **mediante hardware**, por ejemplo, esta clave puede almacenarse dentro de un chip especial (de solo lectura) que funciona como [una caja negra](https://en.wikipedia.org/wiki/Black_box) para proporcionar la descifrado, o **por software** (menos seguro), el sistema DRM proporciona medios para saber qué tipo de protección tiene un dispositivo dado.

Cuando el **reproductor P1 quiere reproducir** el **contenido C'1**, debe interactuar con el **sistema DRM DRM1**, proporcionando su clave pública **PUK1**. El sistema DRM DRM1 devuelve la **clave K1 cifrada** con la clave pública del cliente **PUK1**. En teoría, esta respuesta es algo que **solo D1 es capaz de descifrar**.

`K1P1D1 = enc(K1, PUK1)`

**P1** utiliza su sistema local de DRM (puede ser un [SOC](https://en.wikipedia.org/wiki/System_on_a_chip), hardware especializado o software), este sistema es **capaz de descifrar** el contenido utilizando su clave privada PRK1, puede descifrar **la clave simétrica K1 de la K1P1D1** y **reproducir C'1**. En el mejor caso, las claves no se exponen a través de la RAM.

 ```
 K1 = dec(K1P1D1, PRK1)

 P1.play(dec(C'1, K1))
 ```

![drm decoder flow](/i/drm_decoder_flow.jpeg "drm decoder flow")

# ¿Cómo usar jupyter?

Asegúrate de tener **docker instalado**, ejecuta `./s/start_jupyter.sh` y sigue las instrucciones en la consola.

# Conferencias

* [DEMUXED](https://demuxed.com/) - puedes [mirar las ediciones pasadas aquí.](https://www.youtube.com/channel/UCIc_DkRxo9UgUSTvWVNCmpA).

# Referencias

El contenido más rico se encuentra aquí, es de donde se extrajo, basó o inspiró toda la información que vimos en este texto. Puedes profundizar tu conocimiento con estos increíbles enlaces, libros, vídeos, etc.

Cursos online y tutoriales:

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

Libros:

* https://www.amazon.com/Understanding-Compression-Data-Modern-Developers/dp/1491961538/ref=sr_1_1?s=books&ie=UTF8&qid=1486395327&sr=1-1
* https://www.amazon.com/H-264-Advanced-Video-Compression-Standard/dp/0470516925
* https://www.amazon.com/High-Efficiency-Video-Coding-HEVC/dp/3319068946
* https://www.amazon.com/Practical-Guide-Video-Audio-Compression/dp/0240806301/ref=sr_1_3?s=books&ie=UTF8&qid=1486396914&sr=1-3&keywords=A+PRACTICAL+GUIDE+TO+VIDEO+AUDIO
* https://www.amazon.com/Video-Encoding-Numbers-Eliminate-Guesswork/dp/0998453005/ref=sr_1_1?s=books&ie=UTF8&qid=1486396940&sr=1-1&keywords=jan+ozer

Material de *onboarding*:

* https://github.com/Eyevinn/streaming-onboarding
* https://howvideo.works/
* https://www.aws.training/Details/eLearning?id=17775
* https://www.aws.training/Details/eLearning?id=17887
* https://www.aws.training/Details/Video?id=24750

Especificaciones de *Bitstream*:

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

Códecs *Non-ITU*:

* https://aomedia.googlesource.com/
* https://github.com/webmproject/libvpx/tree/master/vp9
* https://ghostarchive.org/archive/0W0d8 (was: https://people.xiph.org/~xiphmont/demo/daala/demo1.shtml)
* https://people.xiph.org/~jm/daala/revisiting/
* https://www.youtube.com/watch?v=lzPaldsmJbk
* https://fosdem.org/2017/schedule/event/om_av1/
* https://jmvalin.ca/papers/AV1_tools.pdf

Conceptos de codificación:

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

Ejemplos de vídeos para pruebas:

* http://bbb3d.renderfarming.net/download.html
* https://www.its.bldrdoc.gov/vqeg/video-datasets-and-organizations.aspx

Miscelánea:

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
