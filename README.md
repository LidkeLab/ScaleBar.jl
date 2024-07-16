# ScaleBar

This Julia script provides functions to add scale bars to images, facilitating visualization of scale in microscopy and similar applications.

## Features

- **`scalebar!`**: Function to add a scale bar directly to an image array.
- **`scalebar`**: Function to create a new image with a scale bar added.
- **`scalebar_draw`**: Function to draw the scale bar on an image array.

## Simple Usage Example

```
  using Images
```

Create a blank image
```
  img = RGB.(ones(512, 512))
```

Add a scale bar
```
  x_i, x_f, y_i, y_f = scalebar!(img, position="br", len=50, width=5)
```

Draw the scale bar
```
  scalebar_draw(img, x_i, x_f, y_i, y_f)
```

Display the image with the scale bar
```
  img
```


[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://LidkeLab.github.io/ScaleBar.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://LidkeLab.github.io/ScaleBar.jl/dev/)
[![Build Status](https://github.com/LidkeLab/ScaleBar.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/LidkeLab/ScaleBar.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/LidkeLab/ScaleBar.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/LidkeLab/ScaleBar.jl)