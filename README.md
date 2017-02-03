[![license](https://img.shields.io/badge/license-BSD--3--Clause-blue.svg)](https://img.shields.io/badge/license-BSD--3--Clause-blue.svg)

# WIP

This repo will be used to provide a gentle introduction to video technology, although it's aimed to software developers / engineering we want to make it easy for anyone to learn.

The idea is to introduce some video subjects with easy to understand text (at least for developers), visual element and practical examples where is possible. Also, feel free to send PRs.

# Basic video/image terminology

An **image** can be thought as a **2D matrix** and if we think about **colors**, we can extrapolate this idea seeing this image as a **3D matrix**. The lines and rows are the 2D part and the **additional dimensions** are used to provide **color info**.

If we chose to represent these colors using the [primary colors (red, green and blue)](https://en.wikipedia.org/wiki/Primary_color), we can then define the tree planes: the first one **red**, the second **green** and the last the **blue** color.

![an image is a 3d matrix RGB](/i/image_3d_matrix_rgb.png "An image is a 3D matrix")

Each point in this matrix, we'll call it **a pixel** (picture element), will hold the **intensity** (usually a numeric value) of that given color. A **total red color** means 0 of green, 0 of blue and max of red, the **pink color** can be formed with (using 0 to 255 as the possible range) with **Red=255, Green=192 and Blue=203**.

For instance, look at this picture, you can see that it has a lots of red and few blue colors therefore the **red plane** will be the one that **contributes more** (the brightest parts) to the final color while the **blue plane** contribution can be mostly **only seen in Mario's eyes** and part of Mario's clothes.

![RGB channels intensity](/i/rgb_channels_intensity.png "RGB channels intensity")

And each color intensity requires a certain amount of bits, this quantity is know as **bit depth**. Let's say we spend **8 bits** (accepting values from 0 to 255) per channel, therefore we have a **color depth** of **24 (8 * 3) bits** and you can also infer that we could use 2 to the power of 24 different colors. We could also create a **gray image** and really only spend **8 bits** total.

> #### Heads up
> You can [play around with image and colors](/image_as_3d_array.ipynb) with python.



# How to use jupyter

Make sure you have **docker installed** and just run `./s/start_jupyter.sh` and follow the instructions on the terminal.
