# ScaleBar

This Julia script provides functions to add scale bars to images, facilitating visualization of scale in microscopy and similar applications.

## Features

- **`scalebar!`**: Function to add a scale bar directly to an image array.
- **`scalebar`**: Function to create a new image with a scale bar added.

## Simple Usage Example

```
  using Images
  using ScaleBar
```

Create a blank image
```
  img = RGB.(ones(512, 512))
```

Add a scale bar
```
  img_sb = scalebar!(img, pxsize = 1; position="br", len=50, width=5, scale = 15, color = :black)
```
Note: the len and width argument default values are calculated based on the dimensions of img. Briefly, it will find 20% of the length and round down to a multiple of five. The dimensions should be printed in the REPL when these functions are called. This gives the user flexibility to call `scalebar()` again with tweaked dimensions.

Draw the scale bar

Display the image with the scale bar
```
  img
```


[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://LidkeLab.github.io/ScaleBar.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://LidkeLab.github.io/ScaleBar.jl/dev/)
[![Build Status](https://github.com/LidkeLab/ScaleBar.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/LidkeLab/ScaleBar.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/LidkeLab/ScaleBar.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/LidkeLab/ScaleBar.jl)