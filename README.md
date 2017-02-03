[![license](https://img.shields.io/badge/license-BSD--3--Clause-blue.svg)](https://img.shields.io/badge/license-BSD--3--Clause-blue.svg)

# WIP

This repo will be used to provide a gentle introduction to video technology, although it's aimed to software developers / engineering we want to make it easy for anyone to learn. Also, feel free to send PRs.

# Basic video/image terminology

An **image** can be thought as a 2D matrix and if we think about colors, we can extrapolate this idea, now the image can be seen as a **3D matrix**. The lines and rows are the 2D part and the **additional dimension** is used to provide **color info**, there are tree planes, the first one **red**, the second **green** and the last the **blue** color.

![an image is a 3d matrix RGB](/i/image_3d_matrix_rgb.png "An image is a 3D matrix")

Each point in this matrix, called **pixel** (picture element), will hold the **intensity** (usually a numeric value) of that given color. A **total red color** means 0 of green, 0 of blue and max of red, the **pink color** can be formed with (using 0 to 255 as the possible range) with **Red=255, Green=192 and Blue=203**.

For instance, look at this picture, you can see that it has a lots of red and few blue colors therefore the **red color** will be the one that **contributes more** (the brightest parts) to the final color while the **blue color** contribution can be mostly **only seen in Mario's eyes** and part of Mario's clothes.

![RGB channels intensity](/i/rgb_channels_intensity.png "RGB channels intensity")

And each color intensity requires a certain amount of bits, this quantity is know as **bit depth**. Let's say we spend **8 bits** (accepting values from 0 to 255) per channel, therefore we have a **color depth** of **24 (8 * 3) bits** and you can also infer that we could use 2 to the power of 24 different colors.

We could also create a **gray image** and really only spend **8 bits** total.


resolution, aspect ratio, pixel aspect ratio, video, interlaced, progressive, bitrate, CBR, VBR, ABR


You can think of a video being a series of `images` (the quantity of  pictures per second would be the **frame rate** or **FPS(frames per second)**.
