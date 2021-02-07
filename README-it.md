[🇨🇳](/README-cn.md "Simplified Chinese")
[🇯🇵](/README-ja.md "Japanese")
[🇮🇹](/README-it.md "Italian")
[🇰🇷](/README-ko.md "Korean")

[![license](https://img.shields.io/badge/license-BSD--3--Clause-blue.svg)](https://img.shields.io/badge/license-BSD--3--Clause-blue.svg)

# Introduzione

Una introduzione alla tecnologia del video digitale, destinata prevalentemente a ingegneri o sviluppatori software, ma sufficientemente **semplice per consentire a chiunque di imparare**. L'idea è nata durante un [workshop sulla tecnologia video per principianti](https://docs.google.com/presentation/d/17Z31kEkl_NGJ0M66reqr9_uTG6tI5EDDVXpdPKVuIrs/edit#slide=id.p).

L'obiettivo è introdurre alcuni importanti concetti sul video digitale, usando un **vocabolario semplice, molte figure e esempi pratici** quando possibile, e rendere questa conoscenza disponibile ovunque. Non esitare a inviare correzioni o suggerimenti!

Ci saranno delle sezioni con esempi e esercizi che richiedono di avere Docker installato e una copia di questa repository scaricata in locale.

```bash
git clone https://github.com/leandromoreira/digital_video_introduction.git
cd digital_video_introduction
./setup.sh
```
> **ATTENZIONE**: quando vedi scritto un comando come `./s/ffmpeg` oppure `./s/mediainfo`, significa che si sta eseguendo quel programma all'interno di un container Docker, che contiene tutte le dipendenze richieste per funzionare.

**Tutti gli esempi pratici devono essere eseguiti dalla repository locale che hai scaricato**. Per gli esempi di jupyter, devi avviare il server eseguendo `./s/start_jupyter.sh`, e aprire in un browser l'URL mostrato.

# Indice

- [Introduzione](#introduzione)
- [Indice](#indice)
- [Terminologia base](#terminologia-di-base)
  * [Altri modi per codificare un'immagine a colori](#altri-modi-per-codificare-unimmagine-a-colori)
  * [Esercizio: sperimentare con le immagini e i colori](#esercizio-sperimentare-con-le-immagini-e-i-colori)
  * [I DVD hanno un DAR 4:3](#i-dvd-hanno-un-dar-43)
  * [Esercizio: controllare le proprietà di un file video](#esercizio-controllare-le-propriet%C3%A0-di-un-file-video)
- [Rimozione delle informazioni ridondanti](#rimozione-delle-informazioni-ridondanti)
  * [I colori, la luminanza e i nostri occhi](#i-colori-la-luminanza-e-i-nostri-occhi)
    + [Modelli di colore](#modelli-di-colore)
    + [Conversione tra YCbCr e RGB](#conversione-tra-ycbcr-e-rgb)
    + [Sottocampionamento della crominanza](#sottocampionamento-della-crominanza)
    + [Esercizio: vedere l'istogramma YCbCr](#esercizio-vedere-listogramma-ycbcr)
  * [Tipi di fotogramma](#tipi-di-fotogramma)
    + [I Frame (intra, keyframe)](#i-frame-intra-keyframe)
    + [P Frame (predicted)](#p-frame-predicted)
      - [Esercizio: un video con un solo I-frame](#esercizio-un-video-con-un-solo-i-frame)
    + [B Frame (bi-predictive)](#b-frame-bi-predictive)
      - [Esercizio: confronta video con e senza B-frame](#esercizio-confronta-video-con-e-senza-b-frame)
    + [Sommario](#sommario)
  * [Ridondanza temporale (predizione inter-frame)](#ridondanza-temporale-predizione-inter-frame)
      - [Esercizio: vedere i vettori di movimento](#esercizio-vedere-i-vettori-del-moto)
  * [Ridondanza spaziale (predizione intra-frame)](#ridondanza-spaziale-predizione-intra-frame)
      - [Esercizio: vedere la predizione intra-frame](#esercizio-vedere-la-predizione-intra-frame)
- [Come funziona un codec video?](#come-funziona-un-codec-video)
  * [Cosa? Perché? Come?](#cosa-perch%C3%A9-come)
  * [Storia](#storia)
    + [La nascita di AV1](#la-nascita-di-av1)
  * [Un codec generico](#un-codec-generico)
  * [1° passo - partizionamento dell'immagine](#1-passo---partizionamento-dellimmagine)
    + [Esercizio: vedere le partizioni](#esercizio-vedere-le-partizioni)
  * [2° passo - predizioni](#2-passo---predizioni)
  * [3° passo - trasformazione](#3-passo---trasformazione)
    + [Esercizio: scartare diversi coefficienti](#esercizio-scartare-diversi-coefficienti)
  * [4° passo - quantizzazione](#4-passo---quantizzazione)
    + [Esercizio: quantizzazione](#esercizio-quantizzazione)
  * [5° passo - codifica dell'entropia](#5-passo---codifica-dellentropia)
    + [Codifica VLC](#codifica-vlc)
    + [Codifica aritmetica](#codifica-aritmetica)
    + [Esercizio: CABAC vs CAVLC](#esercizio-cabac-vs-cavlc)
  * [6° passo - formato bitstream](#6-passo---formato-bitstream)
    + [Bitstream di H.264](#bitstream-di-h264)
    + [Esercizio: ispezionare il bitstream H.264](#esercizio-ispezionare-il-bitstream-h264)
  * [Ripasso](#ripasso)
  * [Come fa H.265 a comprimere più di H.264?](#come-fa-h265-a-comprimere-pi%C3%B9-di-h264)
- [Streaming online](#streaming-online)
  * [Architettura generale](#architettura-generale)
  * [Download progressivo e download adattivo](#download-progressivo-vs-streaming-adattivo)
  * [Protezione dei contenuti](#protezione-dei-contenuti)
- [Come usare jupyter](#come-usare-jupyter)
- [Conferenze](#conferenze)
- [Riferimenti](#riferimenti)

# Terminologia di base

Un'**immagine** può essere pensata come una **matrice bidimensionale**. Se pensiamo al fatto che ci sono anche i **colori**, possiamo evolvere questa idea pensando l'immagine come una **matrice tridimensionale**, dove la **terza dimensione** (o le dimensioni aggiuntive) viene utilizzata per memorizzare le **informazioni sul colore**.

Se scegliamo di rappresentare i colori utilizzando i [tre colori primari (rosso, verde e blu)](https://it.wikipedia.org/wiki/Colore_primario), possiamo definire tre piani: uno per il **rosso**, uno per il **verde** e uno per il **blu**.

![un'immagine è una matrice 3D](/i/image_3d_matrix_rgb.png "Un'immagine è una matrice 3D")

Chiameremo ogni punto di questa matrice un **pixel** (dall'inglese *picture element*). Un pixel rappresenta l'**intensità** (che in genere è un valore numerico) di un determinato colore. Ad esempio, un **pixel rosso** può essere rappresentato con zero verde, zero blu e il massimo rosso possibile. Un **pixel di colore rosa** può essere formato con una combinazione di tre colori: usando una rappresentazione numerica in un intervallo che va da 0 a 255, il rosa può essere definito come **Rosso=255, Verde=192 e Blu=203**.

> #### Altri modi per codificare un'immagine a colori
> Si possono utilizzare molti altri modelli per rappresentare i colori che compongono un'immagine. Potremmo ad esempio utilizzare una tavolozza di colori (con un indice associato a ciascun colore), rappresentando poi i pixel colorati con l'indice del colore nella tavolozza. In questo modo ogni pixel richiederebbe soltanto un byte di memoria, anziché tre byte come nel caso del modello RGB. Il vantaggio di un modello a _palette_ è quello di occupare meno memoria, riducendo però il numero di colori a disposizione.
>
> ![Tavolozza NES](/i/nes-color-palette.png "Tavolozza NES")

Per fare un esempio, guarda le immagini qui sotto. La prima figura è completamente colorata. Le altre mostrano rispettivamente i piani (o canali) rosso, verde e blu, in scala di grigi.

![Intensità dei canali RGB](/i/rgb_channels_intensity.png "Intensità dei canali RGB")

Possiamo notare che il **colore rosso** è quello che **contribuisce di più** a creare il colore finale (si notino le parti più chiare nella seconda figura, sotto "Red"), mentre il **colore blu** contribuisce prevalentemente a rendere il colore degli **occhi di Mario** e parte dei suoi vestiti (ultima figura a destra). Si può anche notare come nessun canale RGB dia un forte contributo a realizzare i colori scuri, come i baffi di Mario.

Ogni colore richiede un certo numero di bit per essere rappresentato. Questo valore si chiama **profondità di bit**. Se ad esempio decidiamo di utilizzare **8 bit** per canale RGB (potendo rappresentare quindi valori che vanno da 0 a 255), avremo una **profondità di colore** di **8 * 3 = 24 bit**, per un totale di 2<sup>24</sup> colori diversi.

> **È molto interessante** imparare [come un'immagine viene catturata dal mondo reale e convertita in bit](http://www.cambridgeincolour.com/tutorials/camera-sensors.htm).

Un'altra proprietà delle immagini è la **risoluzione**, cioè il numero di pixel per ogni dimensione. Viene spesso indicata utilizzando la notazione "larghezza x altezza", ad esempio **4x4** per indicare un'immagine larga 4 pixel e alta 4 pixel.

![Risoluzione dell'immagine](/i/resolution.png "Risoluzione dell'immagine")

> #### Esercizio: sperimentare con le immagini e i colori
> Puoi esercitarti [con le immagini e i colori](/image_as_3d_array.ipynb) utilizzando [jupyter](#how-to-use-jupyter) (python, numpy, matplotlib, ecc.).
>
> Puoi anche imparare [come funzionano i filtri (rilevazione dei contorni, nitidezza, sfocatura, ecc.)](/filters_are_easy.ipynb).

Lavorando con immagini e video incontreremo anche una proprietà che si chiama **rapporto d'aspetto**, che descrive la relazione di proporzionalità tra la larghezza e l'altezza di un'immagine o di un pixel.

Quando senti dire che un film o un'immagine è in 16:9, di solito ci si riferisce al **rapporto d'aspetto dell'immagine** (anche chiamato *DAR*, dall'inglese *Display Aspect Ratio*). Tuttavia, anche i pixel possono avere forme diverse, per cui si parla di rapporto d'aspetto anche per i pixel (più precisamente *PAR*, dall'inglese **Pixel Aspect Ratio**).

![Rapporto d'aspetto dell'immagine](/i/DAR.png "Rapporto d'aspetto dell'immagine")

![Rapporto d'aspetto del pixel](/i/PAR.png "Rapporto d'aspetto del pixel")

> #### I DVD hanno un DAR 4:3
> Anche se la risoluzione video di un DVD è 704x480, il rapporto d'aspetto è 4:3, perché i pixel hanno un PAR di 10:11 (704x10/480x11).

Infine, possiamo definire un **video** come una **successione di *n* fotogrammi per unità di tempo**. Il valore *n* è la frequenza dei fotogrammi (*frame rate* in inglese), spesso abbreviata con FPS (fotogrammi al secondo).

![Video](/i/video.png "Video")

Il numero dei bit necessari per rappresentare un secondo di video è chiamato **bitrate**, o meno comunemente *frequenza di bit*.

> bitrate = larghezza * altezza * profondità di bit * fotogrammi al secondo

Ad esempio, un video con 30 fotogrammi al secondo e 24 bit per pixel, con una risoluzione di 480x240 ha bisogno (se non utilizziamo nessun tipo di compressione) di **82˙944˙000 bit al secondo**, cioè 82,944 Mbps (il calcolo è 30x480x240x24 byte).

Quando il **bitrate** rimane quasi uguale nel tempo, parliamo di **bitrate costante (CBR)**, mentre quando varia di **bitrate variabile (VBR)**.

> Il grafico mostra il bitrate di un video codificato in modalità VBR limitata (dai valori min e max). Si può notare come il bitrate è più basso quando il fotogramma è nero.
>
> ![VBR limitato](/i/vbr.png "VBR limitato")

Molto tempo fa è stata inventata una tecnica per **raddoppiare il framerate percepito** da chi sta guardando un video, **senza richiedere l'utilizzo di dati aggiuntivi**. Questa tecnica è conosciuta come **interlacciamento**. Semplificando, in un video interlacciato metà dell'immagine è contenuta in un fotogramma, mentre l'altra metà nel fotogramma successivo.

Al giorno d'oggi la maggior parte degli schermi utilizza la **scansione progressiva**, una tecnica per cui la trasmissione, memorizzazione e visualizzazione delle immagini in movimento avviene disegnando progressivamente e in sequenza tutte le linee che compongono il fotogramma.

![Interlacciato vs progressivo](/i/interlaced_vs_progressive.png "Interlacciato vs progressivo")

A questo punto abbiamo un'idea di come un'**immagine** viene rappresentata digitalmente, come i suoi **colori** sono disposti, quanti **bit al secondo** sono richiesti per mostrare un video, con bitrate costante (CBR) o variabile (VBR), e cosa sono i  concetti di **risoluzione**, **framerate** (FPS), interlacciamento, PAR, ecc.

> #### Esercizio: controllare le proprietà di un file video
> Puoi vedere la maggior parte delle proprietà che abbiamo appena visto [usando ffmpeg oppure mediainfo](https://github.com/leandromoreira/introduction_video_technology/blob/master/encoding_pratical_examples.md#inspect-stream) su un file video.

# Rimozione delle informazioni ridondanti

Abbiamo imparato che memorizzare un video senza nessuna compressione è impraticabile. **Un'ora di video** a una risoluzione 720p30 (720 linee verticali con scansione progressiva, con 30 fotogrammi al secondo) **richiederebbe 278 GB**<sup>\*</sup>. Dato che utilizzando i normali algoritmi di compressione lossless (come DEFLATE, utilizzato in PKZIP, Gzip e PNG) non otterremmo una diminuzione significativa della dimensione del file, dobbiamo trovare altri modi per comprimere il video.

> <sup>\*</sup>Si può ottenere questo risultato moltiplicando 1280 x 720 x 24 x 30 x 3600 (larghezza, altezza, bit per pixel, fps e durata in secondi).

Per farlo possiamo sfruttare il modo in cui la nostra vista funziona. Possiamo infatti sfruttare il fatto che l'occhio riesce a distinguere meglio diverse luminosità che diversi colori. È importante anche considerare le **ripetizioni nel tempo** (un video contiene molti fotogrammi molto simili, con poche differenze) e le **ripetizioni all'interno delle immagini** (un fotogramma può contenere aree che hanno lo stesso colore o un colore molto simile).

## I colori, la luminanza e i nostri occhi

I nostri occhi sono [più sensibili alla luminosità che ai colori](http://vanseodesign.com/web-design/color-luminance/), puoi vederlo tu stesso con l'immagine seguente.

![Luminanza vs colore](/i/luminance_vs_color.png "Luminanza vs colore")

Se nell'immagine a sinistra non riesci a vedere che **i colori dei quadrati A e B sono identici**, è normale. È il nostro cervello che ci induce a **prestare più attenzione alla luce e al buio che al colore**. Nell'immagine a destra i due quadrati sono collegati con una striscia dello stesso colore dei quadrati, così riusciamo molto più facilmente a vedere che A e B sono effettivamente dello stesso colore.

> **Spiegazione semplificata del funzionamento dell'occhio**
>
> L'occhio [è un organo complesso](http://www.biologymad.com/nervoussystem/eyenotes.htm): è composto da molte parti ma siamo prevalentemente interessati alle cellule fotorecettrici, i coni e i bastoncelli. L'occhio contiene [circa 120 milioni di bastoncelli e 6 milioni di coni](https://it.wikipedia.org/wiki/Fotorecettore).
>
> In modo **molto semplificato**, proviamo ad associare colori e luminosità alle parti degli occhi. I **[bastoncelli](https://it.wikipedia.org/wiki/Bastoncello) sono quasi solo responsabili della luminosità**, mentre **[i coni](https://it.wikipedia.org/wiki/Cellula_cono) sono responsabili del colore**. I coni sono di tre tipi, ognuno con un pigmento diverso e sensibile a un colore diverso. In particolare, esistono [coni S (blu), coni M (verde) e coni L (rosso)](https://upload.wikimedia.org/wikipedia/commons/1/1e/Cones_SMJ2_E.svg).
>
> Dato che l'occhio ha molti più bastoncelli (luminosità) che coni (colore), si può dedurre che l'occhio è più bravo a distinguere il chiaro dallo scuro che i colori.
>
> ![Composizione dell'occhio](/i/eyes.jpg "Composizione dell'occhio")
>
> **Curve di sensibilità al contrasto**
>
> I ricercatori di psicologia sperimentale (e altri campi) hanno sviluppato molte teorie sull'occhio umano. Una di queste si chiama "curve di sensibilità al contrasto", e studia le funzioni che descrivono il legame spaziotemporale della luce, il loro valore data una certa quantità di luce iniziale, e quanto cambiamento è richiesto prima che un osservatore si accorga che c'è stato un cambiamento. Il plurale della parola "curve" è dovuto al fatto che possiamo usare queste funzioni non solo per studiare il bianco e il nero, ma anche i colori. Il risultato di questi esperimenti mostra che nella maggior parte dei casi l'occhio è più sensibile alla luce che al colore.

Ora che sappiamo che siamo più sensibili alla lumimanza (la luminosità di un'immagine), possiamo provare a sfruttare questo fatto.

### Modelli di colore

Abbiamo inizialmente imparato [come colorare le immagini](#terminologia-di-base) usando il **modello RGB**, ma esistono altri modelli. Ad esempio esiste un modello che separa la luminanza (la luminosità) dalla crominanza (i colori), ed è conosciuto come **YCbCr**<sup>\*</sup>.

> <sup>\*</sup>esistono anche altri modelli che fanno la stessa distinzione.

Questo modello di colore utilizza la **Y** per rappresentare la luminosità, e due canali **Cb** (*chroma blue*) e **Cr** (*chroma red*) per i colori. Il modello [YCbCr](https://it.wikipedia.org/wiki/YCbCr) può essere derivato da RGB, e viceversa. Con i tre canali possiamo creare immagini pienamente colorate, come mostrato nell'immagine:

![Esempio YCbCr](/i/ycbcr.png "Esempio YCbCr")

### Conversione tra YCbCr e RGB

Qualcuno si potrebbe chiedere: "**come è possibile produrre tutti i colori senza usare il verde?**"

Per rispondere a questa domanda, proveremo a fare una conversione da RGB a YCbCr. Utilizzeremo i coefficienti definiti dallo **[standard BT.601](https://it.wikipedia.org/wiki/BT.601)**, una delle raccomandazioni del gruppo [ITU-R](https://it.wikipedia.org/wiki/ITU-R)<sup>\*</sup>.

Il primo passo è **calcolare la luminanza**, utilizzando le costanti suggerite dall'ITU e i valori RGB.

```
Y = 0.299R + 0.587G + 0.114B
```

Ora che abbiamo la luminanza, possiamo **dividere i colori** (colore blu e rosso):

```
Cb = 0.564(B - Y)
Cr = 0.713(R - Y)
```

Possiamo anche **tornare indietro** facendo la conversione inversa, e anche **ottenere il valore del verde utilizzando YCbCr**.

```
R = Y + 1.402Cr
B = Y + 1.772Cb
G = Y - 0.344Cb - 0.714Cr
```

> <sup>\*</sup> i gruppi e gli standard sono comuni nel mondo del video digitale, di solito definiscono quali sono gli standard da usare, ad esempio [cosa si intende con 4K? quale framerate dovrei usare? quale risoluzione e modello di colore?](https://it.wikipedia.org/wiki/BT.2020)

In genere i display (monitor, tv, schermi, ecc.) utilizzano **solo il modello RGB**, anche se con geometrie dei pixel diverse, come si vede nelle immagini, che rappresentano schermi di tipo diverso, ingranditi.

![Geometrie dei pixel](/i/new_pixel_geometry.jpg "Geometrie dei pixel")

### Sottocampionamento della crominanza

Con la rappresentazione dell'immagine in termini di luminanza e crominanza, possiamo trarre vantaggio dalle caratteristiche dell'occhio (che privilegiano la luminanza) per rimuovere selettivamente delle informazioni. La tecnica di **sottocampionamento della crominanza** fa proprio questo, e cioè utilizza **meno risoluzione per la crominanza rispetto alla luminanza**.

![Sottocampionamento della crominanza con YCbCr](/i/ycbcr_subsampling_resolution.png "Sottocampionamento della crominanza con YCbCr")

Quanto dovremmo ridurre la risoluzione della crominanza? Si scopre che esistono già degli schemi che descrivono come gestire la risoluzione e l'unione `colore finale = Y + Cb + Cr`.

Questi schemi sono noti come **sistemi di sottocampionamento** e sono espressi utilizzando un rapporto composto da tre valori. In particolare `a:x:y` definisce la risoluzione di crominanza di un blocco di pixel di luminanza di dimensione `a x 2` pixel.

 * `a` numero di pixel orizzontali di riferimento per il campionamento (di solito 4)
 * `x` numero di campioni di crominanza nella prima riga di `a` pixel (risoluzione orizzontale in relazione a `a`)
 * `y` numero di cambiamenti di campioni di crominanza tra la prima e la seconda riga della griglia `a x 2`

> C'è un'eccezione a questa definizione, in particolare nello schema 4:1:0, che prevede un singolo campione di crominanza per ogni blocco `4 x 4` di luminanza.

Tra gli schemi più comuni nei codec moderni ci sono **4:4:4** *(nessun sottocampionamento)*, **4:2:2, 4:1:1, 4:2:0, 4:1:0 and 3:1:1**.

> **Unione di YCbCr 4:2:0**
>
> Ecco un esempio di come funziona l'unione di un'immagine usando YCbCr con schema di sottocampionamento della crominanza 4:2:0. Nota che vengono utilizzati soltanto 12 bit per pixel.
>
> ![Unione di YCbCr 4:2:0](/i/ycbcr_420_merge.png "Unione di YCbCr 4:2:0")

Le immagini che seguono mostrano la stessa foto codificata con diversi tipi di sottocampionamento della crominanza. Le immagini della prima riga sono quelle finali, mentre quelle della seconda riga mostrano la risoluzione della crominanza. Il risultato è ottimo dato che la perdita di qualità nell'immagine a colori è molto bassa.

![Esempi di sottocampionamento della crominanza](/i/chroma_subsampling_examples.jpg "Esempi di sottocampionamento della crominanza")

Prima abbiamo calcolato che sono necessari [278 GB di spazio per archiviare un file video dalla durata di un'ora, con risoluzione 720p e framerate di 30 fps](#rimozione-delle-informazioni-ridondanti). Se utilizziamo il modello colore **YCbCr 4:2:0**, possiamo **dimezzare la dimensione (139 GB)**<sup>\*</sup>, anche se siamo ben lontani dall'ideale.

> <sup>\*</sup>si ottiene questo valore moltiplicando tra loro larghezza, altezza, bit per pixel e fps. Con il modello RGB avevamo bisogno di 24 bit per pixel, ora ne abbiamo bisogno soltanto 12.

<br/>

> ### Esercizio: vedere l'istogramma YCbCr
> Puoi controllare [l'istogramma di un video YCbCr con ffmpeg](/encoding_pratical_examples.md#generates-yuv-histogram). Ad esempio, in questa scena il colore blu porta un alto contributo, come evidenziato dall'[istogramma](https://it.wikipedia.org/wiki/Istogramma).
>
> ![Istogramma colori YCbCr](/i/yuv_histogram.png "Istogramma colori YCbCr")

## Tipi di fotogramma

Prima di occuparci della **ridondanza delle informazioni nel tempo**, chiariamo la terminologia che useremo. Supponiamo di avere un filmato con 30 fps, i cui primi 4 fotogrammi sono:

![Fotogramma 1](/i/smw_background_ball_1.png "Fotogramma 1") ![Fotogramma 2](/i/smw_background_ball_2.png "Fotogramma 2") ![Fotogramma 3](/i/smw_background_ball_3.png "Fotogramma 3")
![Fotogramma 4](/i/smw_background_ball_4.png "Fotogramma 4")

È evidente che ci sono **molte ripetizioni** all'interno e tra i fotogrammi. Ad esempio lo sfondo blu non cambia tra il primo e l'ultimo fotogramma. Per sfruttare questa caratteristica dei fotogrammi, possiamo **categorizzare in modo astratto** i fotogrammi in [tre tipi diversi](https://it.wikipedia.org/wiki/Tipi_di_fotogramma_nella_compressione_video).

### I-frame (intra, keyframe)

Un I-frame (chiamato anche *reference frame*, *keyframe*, *intra-frame*) è un fotogramma **indipendente**. Non si affida a nessun'altra informazione esterna per essere renderizzato. È come una foto statica. Di solito il primo fotogramma di un video è un I-frame, ma vedremo che ce ne possono essere più di uno in un video, mischiati tra gli altri fotogrammi di tipo diverso.

![Fotogramma 1](/i/smw_background_ball_1.png "Fotogramma 1")

### P-frame (predicted)

Un P-frame (*fotogramma predetto*) sfrutta il fatto che quasi sempre il fotogramma può essere **renderizzato utilizzando il fotogramma precedente**. Ad esempio, nel secondo fotogramma l'unico cambiamento rispetto al precedente è il movimento della palla. Possiamo quindi **ricostruire questo fotogramma utilizzando le differenze rispetto al precedente**.

![Fotogramma 1](/i/smw_background_ball_1.png "Fotogramma 1") <-  ![Fotogramma 2](/i/smw_background_ball_2_diff.png "Fotogramma 2")

> #### Esercizio: un video con un solo I-frame
> Dato che un P-frame utilizza meno dati rispetto a un I-frame, perché non possiamo codificare un intero video [usando solo un I-frame e poi solo P-frame?](/encoding_pratical_examples.md#1-i-frame-and-the-rest-p-frames)
>
> Per esercizio codifica il video esempio, riproducilo e **salta a una posizione avanzata** del video. Noterai che sarà **richiesto del tempo** perché il player completi l'operazione di *seek*. Questo avviene perché un **P-frame ha bisogno di un fotogramma di riferimento** (ad esempio un I-Frame, ma non per forza) per essere renderizzato.
>
> Un altro veloce esperimento che puoi fare è [codificare un video sia utilizzando un singolo I-frame che impostato un I-frame ogni 2 secondi](/encoding_pratical_examples.md#1-i-frames-per-second-vs-05-i-frames-per-second), e confrontare la  **dimensione dei due file risultanti**.

### B-frame (bi-predictive)

E se potessimo fare riferimento sia a fotogrammi passati che futuri, per ottenere una compressione migliore? È proprio come funzionano i B-frame, o frame bi-predittivi.

![Fotogramma 1](/i/smw_background_ball_1.png "Fotogramma 1") <-  ![Fotogramma 2](/i/smw_background_ball_2_diff.png "Fotogramma 2") -> ![Fotogramma 3](/i/smw_background_ball_3.png "Fotogramma 3")

> #### Esercizio: confronta video con e senza B-frame
> Genera due video, uno con i B-frame e uno [senza B-frame](/encoding_pratical_examples.md#no-b-frames-at-all), e confronta la differenza di dimensione del file e la qualità dei risultati.

### Sommario

Diversi tipi di frame possono essere utilizzati per **fornire una migliore compressione**. Scopriremo meglio come nella prossima sezione, ma per ora è importante capire che **gli I-frame sono costosi, i P-frame un po' meno, e infine i B-frame sono i più leggeri**.

![Esempio tipi di fotogramma](/i/frame_types.png "Esempio tipi di fotogramma")

## Ridondanza temporale (predizione inter-frame)

Esploriamo le possibilità che abbiamo per cercare di ridurre la **ripetizione delle informazioni nel tempo**. Questo tipo di ridondanza può essere affrontata usando la **predizione tra fotogrammi** (*inter-frame prediction* o *inter prediction*).

L'obiettivo è **utilizzare meno bit** per codificare la sequenza di fotogrammi 0 e 1.

![Fotogrammi originali](/i/original_frames.png "Fotogrammi originali")

Una cosa che potremmo fare è **sottrarre il fotogramma 1 dal fotogramma 0**, in modo da ottenere soltanto il **residuo da codificare**.

![Differenza tra fotogrammi](/i/difference_frames.png "Differenza tra fotogrammi")

E se ti dicessi che esiste un **metodo migliore**, che consente di utilizzare ancora meno informazione? Consideriamo il `fotogramma 0` come un insieme di partizioni (riquadri) ben definite, e proviamo a creare un'associazione tra i blocchi del `fotogramma 0` e il `fotogramma 1`. Possiamo pensare a questo meccanismo come una **stima del moto**.

> ### Da Wikipedia: compensazione del moto dei blocchi
> "La **compensazione del moto dei blocchi** divide il fotogramma corrente in blocchi non sovrapposti, e il vettore di compensazione del moto **indica da dove si sono spostati quei blocchi** (una convinzione comune ma errata è che il fotogramma precedente viene diviso in blocchi non sovrapposti, e i vettori di compensazione del moto indicano dove i blocchi si sposteranno). I blocchi sorgente tipicamente si sovrappongono nel fotogramma sorgente. Alcuni algoritmi di compressione video costruiscono il fotogramma corrente utilizzando pezzi di diversi fotogrammi creati precedentemente."

![Differenza tra fotogrammi](/i/original_frames_motion_estimation.png "Differenza tra fotogrammi")

Possiamo stimare che la palla si è spostata dalla posizione `x=0, y=25` alla posizione `x=6, y=26`. I valori di **x** e **y** determinano i **vettori del moto**. Un passo aggiuntivo che possiamo fare per risparmiare spazio è **codificare soltanto il vettore di spostamento ottenuto dalla differenza** tra l'ultima posizione del blocco e quella predetta. Nell'esempio sopra il vettore del moto sarebbe quindi `x=6 (6-0), y=1 (26-25)`.

> In una situazione di codifica reale, **la palla sarebbe divisa tra più partizioni**, ma il procedimento è lo stesso.

Gli oggetti nel fotogramma **si muovono in 3 dimensioni**, cioè ad esempio la palla può diventare più piccola se si muove verso lo sfondo. È quindi normale non trovare **la corrispondenza perfetta** tra blocchi. Ad esempio questo è il risultato della nostra stima del moto in confronto alla figura reale:

![Stima del moto](/i/motion_estimation.png "Stima del moto")

Il vantaggio di applicare la tecnica della **stima del moto** è che **i dati da codificare sono di meno** in confronto a una semplice differenza tra fotogrammi.

![Differenza tra fotogrammi vs stima del moto](/i/comparison_delta_vs_motion_estimation.png "Differenza tra fotogrammi vs stima del moto")

> ### Come funziona realmente la compensazione del moto
> La tecnica appena vista viene applicata a tutti i blocchi, ma probabilmente la palla dell'esempio verrebbe partizionata in più di un blocco.
>  ![Compensazione del moto nella realtà](/i/real_world_motion_compensation.png "Compensazione del moto nella realtà")
> Fonte: https://web.stanford.edu/class/ee398a/handouts/lectures/EE398a_MotionEstimation_2012.pdf

Puoi esercitarti con questi concetti [usando jupyter](/frame_difference_vs_motion_estimation_plus_residual.ipynb).

> #### Esercizio: vedere i vettori del moto
> Possiamo generare un video [che mostra la predizione tra frame (e i vettori del moto) con ffmpeg.](/encoding_pratical_examples.md#generate-debug-video)
>
> ![Predizione tra frame (vettori del moto) con ffmpeg](/i/motion_vectors_ffmpeg.png "Predizione tra frame (vettori del moto) con ffmpeg")
>
> In alternativa possiamo usare il software [Intel Video Pro Analyzer](https://software.intel.com/en-us/intel-video-pro-analyzer) (è a pagamento ma esiste una versione di prova che limita l'analisi ai primi 10 fotogrammi).
>
> ![Intel Video Pro Analyzer](/i/inter_prediction_intel_video_pro_analyzer.png "Intel Video Pro Analyzer")

## Ridondanza spaziale (predizione intra-frame)

Se analizziamo un **singolo fotogramma** di un video noteremo che ci sono **molte aree correlate**.

![](/i/repetitions_in_space.png)

Facciamo un esempio. Questa scena è composta prevalentemente dai colori blu e bianco:

![](/i/smw_bg.png)

Questo fotogramma è un `I-frame`, per cui **non possiamo usare fotogrammi precedenti** per costruirlo. Possiamo però comunque comprimerlo. Proviamo ad esempio a codificare il blocco evidenziato in rosso. Se guardiamo **intorno al blocco** possiamo **stimare** che c'è una **tendenza di colore attorno al blocco**.

![](/i/smw_bg_block.png)

Possiamo ad esempio **predire** che i pixel colorati sopra il blocco **continuino allo stesso modo verticalmente**. In altre parole **i pixel del blocco che hanno colore sconosciuto assumeranno attraverso la predizione il colore dei pixel che si trovano sopra** (in questo caso).

![](/i/smw_bg_prediction.png)

La **predizione che abbiamo fatto può essere sbagliata**, per cui dopo aver applicato la predizione dobbiamo **sottrarre i valori reali** dei pixel, in modo da ottenere un blocco residuo. Il risultato è una matrice molto più facilmente comprimibile in confronto all'originale.

![](/i/smw_residual.png)

> #### Esercizio: vedere la predizione intra-frame
> Puoi [generare un video con i macro-blocchi e le sue predizioni con ffmpeg](/encoding_pratical_examples.md#generate-debug-video). Consulta la documentazione di ffmpeg per comprendere meglio [il significato dei colori dei blocchi](https://trac.ffmpeg.org/wiki/Debug/MacroblocksAndMotionVectors#AnalyzingMacroblockTypes).
>
> ![Predizione intra-frame (macro-blocchi) con ffmpeg](/i/macro_blocks_ffmpeg.png "Predizione intra-frame (macro-blocchi) con ffmpeg")
>
> In alternativa puoi anche usare il software [Intel Video Pro Analyzer](https://software.intel.com/en-us/intel-video-pro-analyzer) (è a pagamento ma esiste una versione di prova che limita l'analisi ai primi 10 fotogrammi).
>
> ![Predizione intra-frame con Intel Video Pro Analyzer](/i/intra_prediction_intel_video_pro_analyzer.png "Predizione intra-frame con Intel Video Pro Analyzer")

# Come funziona un codec video?

## Cosa? Perché? Come?

**Cos'è?** È un software o un dispositivo hardware che comprime o decomprime un video digitale. **Perché?** Il mercato e la società richiedono video di qualità alta con banda o spazio di archiviazione limitati. Ti ricordi che abbiamo [calcolato la banda necessaria](#terminologia-di-base) per trasmettere un video con 30 fotogrammi al secondo, 24 bit per pixel e una risoluzione di 480x240 pixel? Risultava **83 Mbps**, senza applicare alcuna compressione. I codec sono l'unico modo per fornire video HD/Full HD/UHD alle tv e tramite Internet. **Come?** Stiamo per dare un'occhiata alle principali tecniche usate.

> **CODEC vs Container**
>
> Un errore che viene spesso fatto dai principianti è confondere il CODEC video con il [contenitore video](https://it.wikipedia.org/wiki/Formato_contenitore). Possiamo pensare al **contenitore** come un formato "wrapper" che contiene i metadati sulle tracce video (e audio), e il vero e proprio **video compresso** come carico pagante (*payload*).
>
> Solitamente l'estensione di un file video determina il suo formato contenitore. Ad esempio, un file `video.mp4` indica con molta probabilità il formato **[MPEG-4 Part 14](https://it.wikipedia.org/wiki/MPEG-4_Part_14)**, mentre un file chiamato `video.mkv` si riferisce al formato **[Matroska](https://it.wikipedia.org/wiki/Matroska)**. Per controllare con certezza il codec e il formato contenitore di un file possiamo utilizzare [ffmpeg oppure mediainfo](/encoding_pratical_examples.md#inspect-stream).

## Storia

Prima di passare ad analizzare il funzionamento interno di un codec generico, facciamo un salto indietro nella storia per comprendere meglio alcuni vecchi codec.

Il codec video [H.261](https://it.wikipedia.org/wiki/H.261) nacque nel 1990 (tecnicamente nel 1988) e fu progettato per funzionare con **bitrate di 64 kbit/s**. Il codec utilizzava già idee come il sottocampionamento della crominanza, i macro-blocchi, ecc. Nell'anno 1955 lo standard del codec video **H.263** fu pubblicato, poi modificato ed esteso fino al 2001.

Nel 2003 la prima versione del codec **H.264/AVC** fu completata. Nello stesso anno, un'azienda chiamata **TrueMotion** rilasciò un altro codec per la compressione video, lossy e **royalty-free**, chiamato **VP3**. Nel 2008, **Google acquisto l'azienda**, rilasciando **VP8** nello stesso anno. Nel dicembre del 2012, Google rilasciò **VP9**, oggi **supportato da circa ¾ dei browser sul mercato** (mobile incluso).

**[AV1](https://it.wikipedia.org/wiki/AOMedia_Video_1)** è un nuovo codec video **royalty-free** e open source che è stato progettato dalla [Alliance for Open Media (AOMedia)](http://aomedia.org/), composta da grandi aziende come **Google, Mozilla, Microsoft, Amazon, Netflix, AMD, ARM, NVidia, Intel e Cisco**. La **prima versione** 0.1.0 del codec di riferimento è stata pubblicata il 7 aprile 2016.

![Linea del tempo della storia dei codec](/i/codec_history_timeline.png "Linea del tempo della storia dei codec")

> #### La nascita di AV1
>
> All'inizio del 2015, Google stava lavorando su [VP10](https://en.wikipedia.org/wiki/VP9#Successor:_from_VP10_to_AV1), Xiph (Mozilla) su [Daala](https://xiph.org/daala/) e Cisco ha reso open source il suo codec video royalty-free chiamato [Thor](https://tools.ietf.org/html/draft-fuldseth-netvc-thor-03).
>
> MPEG LA ha annunciato dei limiti annuali per HEVC (H.265) e canoni di utilizzo 8 volte superiori a H.264, per poi cambiare le regole di nuovo:
> * **nessun limite annuale**,
> * **commissione sui contenuti** (lo 0,5% delle entrate)
> * **commissioni per unità circa 10 volte più alte di H.264**.
>
> La [*Alliance for Open Media*](http://aomedia.org/about/) è stata creata da aziende produttrici di hardware (Intel, AMD, ARM , Nvidia, Cisco), aziende che forniscono contenuti (Google, Netflix, Amazon), browser (Google, Mozilla), e altre.
>
> Le aziende si sono poste un obiettivo comune: un video codec royalty-free. È quindi nato AV1, con un [sistema di licenze molto più semplice](http://aomedia.org/license/patent/). **Timothy B. Terriberry** ha fatto [un'ottima presentazione](https://www.youtube.com/watch?v=lzPaldsmJbk) (fonte di questa sezione) sul concepimento di AV1, il modello di licenza e lo stato attuale del codec.
>
> Ti sorprenderà sapere che puoi **analizzare il codec AV1 tramite il tuo browser**, andando alla pagina http://aomanalyzer.org/
>
> ![av1 browser analyzer](/i/av1_browser_analyzer.png "av1 browser analyzer")
>
> P.S.: se vuoi imparare di più sulla storia dei codec è importante conoscere le basi che stanno dietro ai [brevetti legati alla compressione video](https://www.vcodex.com/video-compression-patents/).

## Un codec generico

Introdurremo ora i **meccanismi principali che stanno dietro a un generico codec video**, ma che si applicano anche ai principali codec moderni come VP9, AV1 e HEVC. Tieni presente che la spiegazione sarà *molto* semplificata rispetto alla realtà, anche se useremo qualche esempio reale (come H.264) per mostrare il funzionamento di una tecnica.

## 1° passo - partizionamento dell'immagine

Il primo passo è **dividere il fotogramma** in molte **partizioni, sotto-partizioni** e via dicendo.

![Partizionamento dell'immagine](/i/picture_partitioning.png "Partizionamento dell'immagine")

**Perché si fa?** Ci sono molte ragioni: ad esempio, dividendo l'immagine possiamo calcolare le predizioni più precisamente, e utilizzare le partizioni più piccole per le parti in movimento, mentre quelle più grandi per rappresentare sfondi statici.

Solitamente, i CODEC **organizzano le partizioni** in *slice* (o *tile*), *macro* (o *coding tree unit*) e tante altre sotto-partizioni. La dimensione massima di queste partizioni varia, ad esempio per HEVC è 64x64 pixel, per AVC (H.264) è 16x16, con le sotto-partizioni che possono essere piccole fino a 4x4 pixel.

Ti ricordi che i fotogrammi possono essere di **diverso tipo**? Si può **applicare la stessa idea anche ai blocchi**, per cui possiamo avere I-slice, B-slice, I-macroblock, ecc.

> ### Esercizio: vedere le partizioni
> Puoi usare il software [Intel Video Pro Analyzer](https://software.intel.com/en-us/intel-video-pro-analyzer) (è a pagamento ma esiste una versione di prova che limita l'analisi ai primi 10 fotogrammi). Ecco un esempio che mostra le [partizioni di VP9](/encoding_pratical_examples.md#transcoding).
>
> ![Partizioni di VP9 con Intel Video Pro Analyzer](/i/paritions_view_intel_video_pro_analyzer.png "Partizioni di VP9 con Intel Video Pro Analyzer")

## 2° passo - predizioni

Ora che abbiamo le partizioni, possiamo usarle per fare le predizioni. Per la predizione [inter-frame](#ridondanza-temporale-predizione-inter-frame) dobbiamo raccogliere informazioni sui **vettori del moto e sul residuo**, mentre per la predizione [intra-frame](#ridondanza-spaziale-predizione-intra-frame) ci servono **la direzione della predizione e il residuo**.

## 3° passo - trasformazione

Una volta che abbiamo il blocco residuo (ottenuto da `partizione predetta - partizione reale`), possiamo **trasformarlo** in un modo che ci consenta di vedere **quali pixel possiamo scartare** pur mantenendo la **qualità generale**. Ci sono diverse trasformazioni che ci permettono di farlo.

Anche se esistono [molte altre trasformazioni](https://en.wikipedia.org/wiki/List_of_Fourier-related_transforms#Discrete_transforms), daremo uno sguardo più approfondito alla trasformata discreta del coseno (*DCT*). La [DCT](https://it.wikipedia.org/wiki/Trasformata_discreta_del_coseno) ci permette di:

* **convertire** blocchi di pixel in blocchi di **coefficienti di frequenza** della stessa dimensione
* **compattare** l'energia, aiutandoci a eliminare la ridondanza spaziale
* **invertire** il processo, cioè tornare a blocchi di pixel

> Il 2 febbraio 2017, Cintra, R. J. e Bayer, F. M hanno pubblicato l'articolo scientifico [DCT-like Transform for Image Compression Requires 14 Additions Only](https://arxiv.org/abs/1702.00817).

Non preoccuparti se non hai capito a pieno i benefici di ciascun punto, faremo qualche esperimento in modo da capire meglio il reale valore della trasformata.

Prendiamo il seguente **blocco di pixel** (8x8):

![Matrice di valori di pixel](/i/pixel_matrice.png "Matrice di valori di pixel")

Che corrisponde alla seguente immagine (8x8):

![Immagine a colori 8x8](/i/gray_image.png "Immagine a colori 8x8")

**Applicando la DCT** a questo blocco di pixel otteniamo un **blocco dei coefficienti** (8x8):

![Valori dei coefficienti](/i/dct_coefficient_values.png "Valori dei coefficienti")

Il blocco dei coefficienti ottenuto, convertito in un'immagine, appare così:

![Immagine dei coefficienti DCT](/i/dct_coefficient_image.png "Immagine dei coefficienti DCT")

Come puoi vedere non assomiglia per niente all'immagine originale. Si può anche notare che il **primo coefficiente** è molto diverso dagli altri. Questo perché il primo coefficiente della DCT è quello che rappresenta **tutti i campioni** della matrice di ingresso, qualcosa di **simile a una media**.

Il blocco dei coefficienti ha un'interessante proprietà, e cioè che separa i componenti relativi alle alte frequenze da quelli delle basse frequenze.

![Alte e basse frequenza della DCT](/i/dctfrequ.jpg "Alte e basse frequenza della DCT")

In un'immagine, **la maggior parte dell'energia** è concentrata nelle [**basse frequenze**](https://web.archive.org/web/20150129171151/https://www.iem.thm.de/telekom-labor/zinke/mk/mpeg2beg/whatisit.htm), quindi dopo aver applicato la trasformata possiamo **scartare i coefficienti delle alte frequenze**, in modo da **ridurre la quantità di dati** richiesta per descrivere l'immagine, pur senza sacrificare troppo la qualità dell'immagine.

> la frequenza determina quando rapidamente un segnale cambia.

Proviamo ad applicare le conoscenze acquisite: convertiamo l'immagine originale nelle sue frequenze usando la DCT, e poi scartiamo i coefficienti meno importanti.

Per prima cosa, convertiamo il blocco nel **dominio della frequenza**.

![Valori dei coefficienti](/i/dct_coefficient_values.png "Valori dei coefficienti")

Poi, scartiamo parte dei coefficienti (il 67%), prevalentemente nell'angolo in basso a destra del blocco.

![Coefficienti azzerati](/i/dct_coefficient_zeroed.png "Coefficienti azzerati")

Infine, ricostruiamo l'immagine utilizzando il blocco dei coefficienti modificato, e confrontiamo il risultato con l'immagine originale.

![Originale vs quantizzata](/i/original_vs_quantized.png "Originale vs quantizzata")

L'immagine a destra è simile a quella originale, ma introduce anche molte differenze. Abbiamo però **buttato via il 67,1875%** delle informazioni e comunque siamo in grado di ottenere un'immagine che assomiglia a quella originale. Il prossimo passo è capire come modificare i coefficienti in modo più intelligente, per ottenere così una migliore qualità dell'immagine.

> **Ogni coefficiente viene calcolato utilizzando tutti i pixel**
>
> È importante evidenziare che ogni coefficiente del blocco non corrisponde direttamente a un singolo pixel, ma è una somma pesata di tutti i pixel. Il grafico che segue mostra come il primo e il secondo coefficiente vengono calcolati, utilizzando persi che sono diversi per ogni indice.
>
> ![Calcolo DCT](/i/applicat.jpg "Calcolo DCT")
>
> Fonte: https://web.archive.org/web/20150129171151/https://www.iem.thm.de/telekom-labor/zinke/mk/mpeg2beg/whatisit.htm
>
> Puoi anche provare a [osservare visivamente la DCT con la formazione di un'immagine](/dct_better_explained.ipynb). Ad esempio, qua puoi vedere [la formazione della lettera A](https://en.wikipedia.org/wiki/Discrete_cosine_transform#Example_of_IDCT) utilizzando diversi pesi per i coefficienti.
>
> ![](https://upload.wikimedia.org/wikipedia/commons/5/5e/Idct-animation.gif )

<br/>

> ### Esercizio: scartare diversi coefficienti
> Puoi sperimentare con [la trasformata DCT](/uniform_quantization_experience.ipynb).

## 4° passo - quantizzazione

Quando scartiamo dei coefficienti, come abbiamo fatto alla fine dell'ultimo passo, stiamo già facendo una sorta di quantizzazione. Questo passo è quello in cui decidiamo quali informazioni "perdere", e lo facciamo **quantizzando i coefficienti per ottenere della compressione**.

Come possiamo quantizzare un blocco di coefficienti? Un metodo semplice potrebbe essere una quantizzazione uniforme, in cui prendiamo un blocco e **dividiamo tutti i valori per lo stesso numero** (10), per poi arrotondare.

![Quantizzazione](/i/quantize.png "Quantizzazione")

Come possiamo **invertire** (ri-quantizzare) il blocco dei coefficienti? È sufficiente **moltiplicare i valori ottenuti per lo stesso numero** con cui li abbiamo divisi (10).

![Ri-quantizzazione](/i/re-quantize.png "Ri-quantizzazione")

**Questo approccio non è però il migliore**, perché non tiene in considerazione l'importanza dei diversi coefficienti. Anziché un singolo valore per la divisione, potremmo utilizzare una **matrice di quantizzazione**, che sfrutterebbe quindi le proprietà della DCT quantizzando maggiormente l'angolo in basso a destra e in modo minore quello in alto a sinistra. La [compressione JPEG](https://www.hdm-stuttgart.de/~maucher/Python/MMCodecs/html/jpegUpToQuant.html) utilizza un metodo simile, e puoi vedere un esempio di matrice di quantizzazione [nel codice sorgente](https://github.com/google/guetzli/blob/master/guetzli/jpeg_data.h#L40) di un compressore JPEG.

> ### Esercizio: quantizzazione
> Puoi sperimentare [con la quantizzazione](/dct_experiences.ipynb).

## 5° passo - codifica dell'entropia

Dopo aver quantizzato i dati (i blocchi/slice/fotogrammi), possiamo comprimerli ulteriormenti utilizzando metodi di compressione lossless (senza perdita). Ci sono moltissimi algoritmi per comprimere i dati, e andremo a vederne alcuni. Per comprendere a fondo i concetti legati alla compressione dei dati, una lettura consigliata è il fantastico libro [Understanding Compression: Data Compression for Modern Developers](https://www.amazon.it/Understanding-Compression-Data-Modern-Developers/dp/1491961538/).

### Codifica VLC:

Supponiamo di avere un flusso di simboli: **a**, **e**, **r** e **t**, con le seguenti probabilità (valori da 0 a 1) di comparire nel flusso.

|             | a   | e   | r   | t   |
|-------------|-----|-----|-----|-----|
| probabilità | 0,3 | 0,3 | 0,2 | 0,2 |

Possiamo assegnare un codice binario (preferibilmente piccolo) al simbolo più probabile, e un codice più lungo ai simboli meno probabili.

|                | a   | e   | r   | t    |
|----------------|-----|-----|-----|------|
| probabilità    | 0,3 | 0,3 | 0,2 | 0,2  |
| codice binario | 0   | 10  | 110 | 1110 |

Proviamo ora a comprimere il flusso rappresentato dalla parola **eat**. Assumendo di utilizzare 8 bit per ogni simbolo (carattere), avremmo bisogno di **24 bit** per rappresenta la parola, senza utilizzare nessun metodo di compressione. Ma se invece utilizziamo i codici binari associati alle lettere, possiamo risparmiare spazio.

Il primo passo è codificare il simbolo **e**, che corrisponde a `10`, per poi passare a **a**, con cui otteniamo `[10][0]` e infine il simbolo **t**, per ottenere `[10][0][1110]`, o `1001110`. Il risultato richiede soltanto **7 bit** per essere memorizzato, 3,4 volte volte in meno rispetto ai 24 bit iniziali.

È importante notare che ogni codice binario deve avere un prefisso unico (*proprietà del prefisso*). La [codifica di Huffman](https://it.wikipedia.org/wiki/Codifica_di_Huffman) aiuta a calcolare questi codici. Nonostante questa tecnica abbia qualche problema, ci sono ancora [alcuni codec video che la offrono](https://en.wikipedia.org/wiki/Context-adaptive_variable-length_coding) come opzione.

Sia il codificatore (encoder) che il decodificatore (decoder) **devono conoscere la tabella simboli-codici**, per cui è necessario salvare anche la tabella.

### Codifica aritmetica:

Supponiamo di avere il flusso di simboli **a**, **e**, **r**, **s** e **t**, le cui probabilità sono rappresentate dalla tabella.

|             | a   | e   | r    | s    | t   |
|-------------|-----|-----|------|------|-----|
| probabilità | 0,3 | 0,3 | 0,15 | 0,05 | 0,2 |

Usando le probabilità possiamo associare degli intervalli ai simboli, ordinandoli per probabilità decrescente.

![Intervalli aritmetici iniziali](/i/range.png "Intervalli aritmetici iniziali")

Ora codifichiamo il flusso **eat**: prendiamo il primo simbolo **a**, il cui intervallo va **da 0,3 a 0,6** (non incluso). Lo dividiamo nuovamente, usando le stesse proporzioni della divisione originale, solo che applicate al sottointervallo.

![Secondo sottointervallo](/i/second_subrange.png "Secondo sottointervallo")

Continuiamo con la codifica del flusso **eat**, prendendo il simbolo **a** che corrisponde ora all'intervallo che va **da 0,3 a 0,39**. Infine ripetiamo il processo con il simbolo **t**, ottenendo l'ultimo intervallo tra **0,354 e 0,372**.

![Intervallo aritmetico finale](/i/arithimetic_range.png "Intervallo aritmetico finale")

Dobbiamo ora semplicemente prendere un qualsiasi valore contenuto tra **0,354 e 0,372**, ad esempio **0,36**, ma potremmo prenderne uno qualsiasi. Con **solo** questo numero siamo in grado di ricostruire il flusso di simboli originale **eat**. Se ci pensi, è come se stessimo tracciando una riga che attraversa gli intervalli e i sottointervalli per codificare il flusso.

![Attraversamento degli intervalli](/i/range_show.png "Attraversamento degli intervalli")

Il **processo inverso** (la decodifica) è ugualmente facile. Avendo a disposizione il numero **0,36** e l'intervallo originale possiamo seguire la stessa procedura, usando il numero per scoprire sottointervallo per sottointervallo il flusso di simboli associato.

In pratica, usando il primo intervallo troviamo che il numero è compreso nell'intervallo del simbolo **e**, per cui prendiamo quell'intervallo e lo dividiamo di nuovo. Ripetiamo quanto appena fatto per trovare che il valore **0,36** è compreso nell'intervallo di **a**, che è quindi il secondo simbolo del flusso. Infine troviamo l'ultimo simbolo **t**, che va a completare il flusso finale **eat**.

Sia l'encoder che il decoder **devono conoscere** la tabella dei simboli con le probabilità, per cui la tabella deve essere salvata e trasmessa.

Interessante vero? Ci devono essere persone incredibilmente intelligenti per riuscire a inventare una soluzione del genere, che oggi viene usata [in molti codec video](https://en.wikipedia.org/wiki/Context-adaptive_binary_arithmetic_coding).

L'idea che deve restare è che si può prendere il flusso di bit (bitstream) risultante dalla quantizzazione e comprimerlo in modo lossless, cioè senza perdita di informazioni. Sicuramente questo articolo manca di molti dettagli, spiegazioni, vantaggi e compromessi, ma puoi [imparare facilmente di più se sei uno sviluppatore](https://www.amazon.it/Understanding-Compression-Data-Modern-Developers/dp/1491961538/). I nuovi codec stanno iniziando ad usare differenti sistemi di codifica dell'entropia, [come ANS](https://en.wikipedia.org/wiki/Asymmetric_numeral_systems).

> ### Esercizio: CABAC vs CAVLC
> Puoi [generare due video, uno con codifica dell'entropia CABAC e l'altro con CAVLC](https://github.com/leandromoreira/introduction_video_technology/blob/master/encoding_pratical_examples.md#cabac-vs-cavlc), e **confrontare il tempo di codifica**, così come la **dimensione del file finale**.

## 6° passo - formato bitstream

Dopo aver completato tutti questi passaggi, ora dobbiamo **compattare tutti i fotogrammi compressi con le loro informazioni di contesto**. Dobbiamo informare in modo esplicito il decoder delle **decisioni che sono state prese dall'encoder durante la codifica**, tra cui la profondità di bit, lo spazio colore, la risoluzione, le predizioni (vettori di moto inter-frame, direzione della predizione intra-frame), il profilo, il livello, il frame rate, il tipo di fotogramma, il numero di fotogramma e molto altro.

Stiamo per studiare, superficialmente, il bitstream del codec H.264. La prima cosa da fare è [generare un bitstream H.264 minimo<sup>\*</sup>](/encoding_pratical_examples.md#generate-a-single-frame-h264-bitstream), usando [ffmpeg](http://ffmpeg.org/).

```
./s/ffmpeg -i /files/i/minimal.png -pix_fmt yuv420p /files/v/minimal_yuv420.h264
```

> <sup>\*</sup>ffmpeg aggiunge, in modo predefinito, tutti i parametri di codifica come un **NAL SEI**. Presto definiremo che cos'è un NAL.

Il comando genera un bitstream H.264 "raw" (senza formato contenitore), con un **singolo fotogramma**, di dimensione 64x64 pixel, con spazio colore yuv420 (cioè YCbCr 4:2:0) e usando l'immagine seguente come fotogramma.

> ![Fotogramma usato per generare il bitstream H.264](/i/minimal.png "Fotogramma usato per generare il bitstream H.264")

### Bitstream di H.264

Lo standard AVC (H.264) stabilisce che le informazioni vengano trasmesse in **macro frame** (nel significato legato alle reti di telecomunicazioni), chiamati **[NAL](https://en.wikipedia.org/wiki/Network_Abstraction_Layer)** (Network Abstraction Layer). L'obiettivo principale dei NAL è fornire una rappresentazione del video che sia adatta per la trasmissione in rete, considerato che lo standard deve funzionare sulle tv (basate su flussi) e tramite Internet (basato su pacchetti), tra gli altri.

![Unità di NAL H.264](/i/nal_units.png "Unità di NAL H.264")

Viene usato un **[segnale di sincronizzazione](https://en.wikipedia.org/wiki/Frame_synchronization)** (*synchronization marker*) per delimitare le unità NAL. Ogni segnale di sincronizzazione corrisponde al valore fisso `0x00 0x00 0x01`, ad eccezione del primo che ha il valore `0x00 0x00 0x00 0x01`. Se eseguiamo il comando **hexdump** sul bitstream H.264 che abbiamo generato, riusciamo facilmente ad identificare almeno tre unità NAL all'inizio del file.

![Segnali di sincronizzazione delle unità NAL](/i/minimal_yuv420_hex.png "Segnali di sincronizzazione delle unità NAL")

Come detto prima, il decodificatore ha bisogno non solo dei dati dell'immagine, ma anche di dettagli come il numero di fotogramma, i colori, i parametri usati e altro. Il **primo byte** di ciascun NAL definisce la sua categoria e il **tipo**.

| ID del tipo di NAL | Descrizione  |
|---  |---|
| 0  |  Non definito |
| 1  |  Slice codificato di un'immagine non IDR |
| 2  |  Slice codificato di una partizione A |
| 3  |  Slice codificato di una partizione B |
| 4  |  Slice codificato di una partizione C |
| 5  |  **IDR** Slice codificato di un'immagine IDR |
| 6  |  **SEI** Informazioni aggiuntive (*supplemental enhancement information*) |
| 7  |  **SPS** Insieme parametri di sequenza (*sequence parameter set*) |
| 8  |  **PPS** Insieme parametri d'immagine (*picture parameter set*) |
| 9  |  Delimitatore di unità di accesso |
| 10 |  Fine della sequenza |
| 11 |  Fine del flusso |
| ... |  ... |

Solitamente il primo NAL di un bitstream è di tipo **SPS**. Questo tipo di NAL contiene informazioni generiche sulle variabili di codifica, come il **profilo**, il **livello**, la **risoluzione** e altro.

Se saltiamo il primo segnale di sincronizzazione possiamo decodificare il **primo byte** per capire il **tipo del primo NAL** del bitstream di esempio.

Ad esempio in questo caso il primo byte dopo la sincronizzazione è `01100111`, dove il primo bit (`0`) si riferisce al campo **forbidden_zero_bit**, i due bit successivi (`11`) indicano il campo **nal_ref_idc**, che stabilisce se il NAL è un campo di riferimento oppure no, e infine gli ultimi cinque bit (`00111`) sono il campo **nal_unit_type**, cioè il tipo di NAL, in questo caso **SPS** (7).

Il secondo byte (`bin=01100100, hex=0x64, dec=100`) di un NAL SPS è il campo **profile_idc**, che indica il profilo che è stato usato per la codifica. In questo esempio è stato usato il profilo ["Constrained High"](https://en.wikipedia.org/wiki/H.264/MPEG-4_AVC#Profiles), che è un profilo "alto" senza il supporto agli slice di tipo B (bi-predittive).

![Il NAL SPS in binario](/i/minimal_yuv420_bin.png "Il NAL SPS in binario")

Se leggiamo le specifiche del bitstream H.264 troveremo diversi valori per i campi **nome parametro**, **categoria** e **descrizione**. Ad esempio consideriamo i campi `pic_width_in_mbs_minus_1` e `pic_height_in_map_units_minus_1`.

| Nome parametro  | Categoria  |  Descrizione  |
|---  |---|---|
| pic_width_in_mbs_minus_1 |  0 | ue(v) |
| pic_height_in_map_units_minus_1 |  0 | ue(v) |

> **ue(v)**: intero senza segno [codificato con Exp-Golomb](https://pythonhosted.org/bitstring/exp-golomb.html)

Facendo un po' di calcoli possiamo utilizzare il valore di questi campi per ricavare la **risoluzione**. Ad esempio una risoluzione di `1920 x 1080` può essere ottenuta dando al parametro `pic_width_in_mbs_minus_1` il valore di `119 ( (119 + 1) * dimensione_macroblocco = 120 * 16 = 1920)`. Abbiamo risparmiato spazio, memorizzando `119` anziché `1920`.

Se continuiamo a esaminare il video creato con un visualizzatore binario (es. `xxd -b -c 11 v/minimal_yuv420.h264`), possiamo saltare all'ultimo NAL che è il fotogramma vero e proprio.

![Header di uno slice IDR H.264](/i/slice_nal_idr_bin.png "Header di uno slice IDR H.264")

Il valore dei primi 6 byte è `01100101 10001000 10000100 00000000 00100001 11111111`. Come abbiamo visto dal primo byte si può ricavare il tipo di NAL, in questo caso `00101`, che corrisponde a **Slice IDR (5)**. Continuiamo con l'ispezione.

![Specifica header slice H.264](/i/slice_header.png "Specifica header slice H.264")

Utilizzando le specifiche dell'header degli slice H.264 possiamo decodificare il tipo di slice (**slice_type**), il numero del fotogramma (**frame_num**), assieme ad altre importanti informazioni.

Per ottenere il reale valore di alcuni campi (`ue(v), me(v), se(v), te(v)`) dobbiamo decodificarli utilizzando un metodo speciale chiamato [Exponential-Golomb](https://pythonhosted.org/bitstring/exp-golomb.html), che è un **modo molto efficiente per codificare valori variabili**, specialmente quando vengono usati molti valori predefiniti.

> I valori **slice_type** e **frame_num** sono 7 (slice di tipo I) e 0 (primo fotogramma).

Possiamo vedere il **bitstream come un protocollo**, e se vuoi o devi imparare di più a proposito del bitstream fai riferimento alle [specifiche H.264 dell'ITU](http://www.itu.int/rec/T-REC-H.264-201610-I). Ecco un diagramma semplificato che mostra dove vengono memorizzati i dati dell'immagine vera e propria (YCbCr/YUV compresso).

![Diagramma bitstream H.264](/i/h264_bitstream_macro_diagram.png "Diagramma bitstream H.264")

Possiamo esplorare altri bitstream come [quello di VP9](https://storage.googleapis.com/downloads.webmproject.org/docs/vp9/vp9-bitstream-specification-v0.6-20160331-draft.pdf), [H.265 (HEVC)](http://handle.itu.int/11.1002/1000/11885-en?locatt=format:pdf) o anche il nostro **nuovo miglior amico** [**AV1**](https://medium.com/@mbebenita/av1-bitstream-analyzer-d25f1c27072b#.d5a89oxz8
). Si assomigliano? [No, ma una volta imparato uno capire gli altri è facile](http://www.gpac-licensing.com/2016/07/12/vp9-av1-bitstream-format/).

> ### Esercizio: ispezionare il bitstream H.264
> Possiamo [generare un video con un singolo fotogramma](https://github.com/leandromoreira/introduction_video_technology/blob/master/encoding_pratical_examples.md#generate-a-single-frame-video) e usare [mediainfo](https://en.wikipedia.org/wiki/MediaInfo) per ispezionare il suo bitstream H.264. Infatti puoi anche vedere il [codice sorgente che si occupa del parsing del bitstream H.264 (AVC)](https://github.com/MediaArea/MediaInfoLib/blob/master/Source/MediaInfo/Video/File_Avc.cpp).
>
> ![Dettagli sul bitstream H.264 mostrati da mediainfo](/i/mediainfo_details_1.png "Dettagli sul bitstream H.264 mostrati da mediainfo")
>
> In alternativa possiamo usare il software [Intel Video Pro Analyzer](https://software.intel.com/en-us/intel-video-pro-analyzer) (è a pagamento ma esiste una versione di prova che limita l'analisi ai primi 10 fotogrammi).
>
> ![Bitstream H.264 analizzato con Intel Video Pro Analyzer](/i/intel-video-pro-analyzer.png "Bitstream H.264 analizzato con Intel Video Pro Analyzer")

## Ripasso

Molti dei **codec moderni utilizzano lo stesso modello di codifica che abbiamo imparato**. Ad esempio, diamo un'occhiata al diagramma a blocchi del codec video Thor, che contiene tutti i passi che abbiamo studiato. A questo punto dovresti essere in grado almeno di comprendere meglio le innovazioni e gli articoli che riguardano questi argomenti.

![Diagramma a blocchi codec video Thor](/i/thor_codec_block_diagram.png "Diagramma a blocchi codec video Thor")

Inizialmente abbiamo calcolato che ci servono [139 GB di spazio per archiviare un file di un'ora nel formato 720p30](#sottocampionamento-della-crominanza). Se applichiamo le tecniche imparate qui, come **la predizione intra-frame e inter-frame, la trasformata, la quantizzazione, la codifica dell'entropia**, assumendo che spendiamo **0,031 bit per pixel** possiamo raggiungere la stessa qualità percepita utilizzando soltanto **368 MB anziché 139 GB**.

> Abbiamo scelto di usare **0,031 bit per pixel** basandoci sull'esempio precedente.

## Come fa H.265 a comprimere più di H.264?

Ora che sappiamo come funziona un codec, risulta più facile capire come i nuovi codec sono in grado di memorizzare risoluzioni più alte usando meno bit.

Confronteremo AVC e HEVC, tenendo in mente che il processo è quasi sempre un compromesso tra la complessità dell'algoritmo (cicli di CPU) e il tasso di compressione.

HEVC ha **partizioni** (e **sottopartizioni**) più grandi e più numerose rispetto ad AVC, inoltre ha **più direzioni di predizione intra-frame**, una **migliore codifica dell'entropia**, e altro. Tutto insieme fa in modo che H.265 sia in grado di comprimere il 50% in più rispetto ad H.264.

![h264 vs h265](/i/avc_vs_hevc.png "H.264 vs H.265")

# Streaming online
## Architettura generale

![Architettura generale](/i/general_architecture.png "Architettura generale")

[TODO]

## Download progressivo vs streaming adattivo

![Download progressivo](/i/progressive_download.png "Download progressivo")

![Streaming adattivo](/i/adaptive_streaming.png "Streaming adattivo")

[TODO]

## Protezione dei contenuti

Possiamo usare un semplice **sistema a token** (gettone) per proteggere i contenuti. Un utente senza token che prova a richiedere un video viene bloccato dalla CDN, mentre un utente con un token valido può riprodurre il contenuto. Funziona in modo abbastanza simile alla maggior parte dei sistemi di autenticazione sul web.

![Protezione con token](/i/token_protection.png "Protezione con token")

L'utilizzo di questo sistema consente comunque all'utente di scaricare e ridistribuire il video. Un sistema **DRM (digital rights management)** permette di evitare anche questo problema.

![DRM](/i/drm.png "DRM")

I sistemi di produzione nel mondo reale in genere usano entrambe le tecniche, per offrire sia autorizzazione che autenticazione.

### DRM
#### Sistemi principali

* FPS - [**FairPlay Streaming**](https://developer.apple.com/streaming/fps/)
* PR - [**PlayReady**](https://www.microsoft.com/playready/)
* WV - [**Widevine**](http://www.widevine.com/)


#### Cos'è?

DRM sta per *gestione dei diritti digitali* (*Digital Rights Management*) ed è un modo per **aggiungere una protezione del diritto d'autore ai contenuti digitali**, quindi anche al video e all'audio. Nonostante sia molto usato, [non è universalmente accettato](https://en.wikipedia.org/wiki/Digital_rights_management#DRM-free_works).

#### Perché?

I creatori di contenuti (principalmente gli studi) vogliono proteggere la proprietà intellettuale dalla copia, per prevenire la ridistribuzione non autorizzata dei contenuti digitali.

#### Come?

Descriveremo un modello generico ed astratto di DRM in un modo molto semplificato.

Sia dato un **contenuto C1** (es. uno streaming video HLS o DASH), con un **player P1** (es. shaka-clappr, exo-player o iOS) e un **dispositivo D1** (es. uno smartphone, una tv, un tablet o un computer), che utilizzano un **sistema DRM che chiamiamo DRM1** (es. Widevine, PlayReady, FairPlay).

Il contenuto C1 viene cifrato con una **chiave simmetrica K1** fornita dal sistema DRM1, così da ottenere il **contenuto cifrato C'1**.

![Flusso generale DRM](/i/drm_general_flow.jpeg "Flusso generale DRM")

Il player P1 del dispositivo D1 possiede due chiavi (asimmetriche), cioè una **chiave privata PRK1** (questa chiave è protetta<sup>1</sup> e conosciuta solo da **D1**) e una **chiave pubblica PUK1**.

> **<sup>1</sup>protetta**: questa protezione può essere ottenuta sia **tramite hardware**, memorizzando la chiave all'interno di un chip speciale in sola lettura che agisce come una [scatola nera](https://it.wikipedia.org/wiki/Modello_black_box) per fornire la decifratura, sia **tramite software** (in modo meno sicuro). Il sistema DRM offre dei modi per sapere quale tipo di protezione il dispositivo ha a disposizione.

Quando il **player P1 vuole riprodurre il contenuto C'1**, deve contrattare con il **sistema DRM1**, fornendogli la sua chiave pubblica **PUK1**. Il sistema DRM1 ritorna la **chiave K1 cifrata** con la chiave pubblica **PUK1** del client. A livello teorico, questa risposta è qualcosa che **soltanto D1 è in grado di decifrare**.

`K1P1D1 = enc(K1, PUK1)`

Il player **P1** utilizza il suo sistema DRM locale (che potrebbe essere un [SoC](https://it.wikipedia.org/wiki/System-on-a-chip), una parte di software o hardware specializzata), **in grado di decifrare** il contenuto utilizzando la sua chiave privata PRK1. In questo modo può **decifrare la chiave simmetrica K1 da K1P1D1** e quindi riprodurre **C'1**. Nel migliore dei casi, le chiavi non sono esposte nella memoria RAM.

 ```
 K1 = dec(K1P1D1, PRK1)

 P1.play(dec(C'1, K1))
 ```

![Flusso di decodifica DRM](/i/drm_decoder_flow.jpeg "Flusso di decodifica DRM")

# Come usare jupyter

Assicurati di avere **Docker installato** e avvia `./s/start_jupyter.sh`. Segui poi le istruzioni mostrate nel terminale.

# Conferenze

* [DEMUXED](https://demuxed.com/) - puoi [guardare le presentazioni degli ultimi 2 eventi](https://www.youtube.com/channel/UCIc_DkRxo9UgUSTvWVNCmpA).

# Riferimenti

Il contenuto più ricco è qua, puoi trovare le informazioni che hanno ispirato questo testo e da cui sono stati estratti i concetti. Puoi approfondire la tua conoscenza leggendo questi link, libri, video, ecc.

Corsi online e tutorial:

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

Libri:

* https://www.amazon.com/Understanding-Compression-Data-Modern-Developers/dp/1491961538/ref=sr_1_1?s=books&ie=UTF8&qid=1486395327&sr=1-1
* https://www.amazon.com/H-264-Advanced-Video-Compression-Standard/dp/0470516925
* https://www.amazon.com/Practical-Guide-Video-Audio-Compression/dp/0240806301/ref=sr_1_3?s=books&ie=UTF8&qid=1486396914&sr=1-3&keywords=A+PRACTICAL+GUIDE+TO+VIDEO+AUDIO
* https://www.amazon.com/Video-Encoding-Numbers-Eliminate-Guesswork/dp/0998453005/ref=sr_1_1?s=books&ie=UTF8&qid=1486396940&sr=1-1&keywords=jan+ozer

Specifiche bitstream:

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

Codec non ITU:

* https://aomedia.googlesource.com/
* https://github.com/webmproject/libvpx/tree/master/vp9
* https://people.xiph.org/~xiphmont/demo/daala/demo1.shtml
* https://people.xiph.org/~jm/daala/revisiting/
* https://www.youtube.com/watch?v=lzPaldsmJbk
* https://fosdem.org/2017/schedule/event/om_av1/
* https://jmvalin.ca/papers/AV1_tools.pdf

Concetti di codifica:

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

Sequenze video per i test:

* http://bbb3d.renderfarming.net/download.html
* https://www.its.bldrdoc.gov/vqeg/video-datasets-and-organizations.aspx

Varie:

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
