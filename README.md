# ScaleBar

This Julia script provides functions to add scale bars to images, facilitating visualization of scale in microscopy and similar applications.

## Features

- **`scalebar!`**: Function to add a scale bar directly to an image array.
- **`scalebar`**: Function to create a new image with a scale bar added.

## Simple Usage Example

```julia
  using Images
  using ScaleBar
```

Create a blank image and define the pixel size
```julia
  img = RGB.(ones(512, 512))
  pxsize = 0.1
```

Add a scale bar
```julia
  img_sb = scalebar!(img, pxsize = 0.1; # the image and pixel size are required
    # kwargs
    position="br"  # set the position, "br" = bottom right
    len=50 # the horizontal dimension in pixels
    width=5 # the vertical dimension in pixels
    scale = 15 # scale of the offset of the scalebar from the edge of the image. Applies to both dimensions.
    color = :black) # currently supports :black and :white
```
Note: the len and width argument default values are calculated based on the dimensions of img. Briefly, it will find 20% of the length and round down to a multiple of five. The dimensions should be printed in the REPL when these functions are called. This gives the user flexibility to call `scalebar()` again with tweaked dimensions.

Display the image with the scale bar
```julia
  img
```


[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://LidkeLab.github.io/ScaleBar.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://LidkeLab.github.io/ScaleBar.jl/dev/)
[![Build Status](https://github.com/LidkeLab/ScaleBar.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/LidkeLab/ScaleBar.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/LidkeLab/ScaleBar.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/LidkeLab/ScaleBar.jl)