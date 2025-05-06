# ScaleBar

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://LidkeLab.github.io/ScaleBar.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://LidkeLab.github.io/ScaleBar.jl/dev/)
[![Build Status](https://github.com/LidkeLab/ScaleBar.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/LidkeLab/ScaleBar.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/LidkeLab/ScaleBar.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/LidkeLab/ScaleBar.jl)

ScaleBar.jl provides functions to add scale bars to images, facilitating visualization of scale in microscopy and similar applications.

## Features

- **Physical Units**: Add scale bars with proper physical dimensions (e.g., μm, nm)
- **Pixel-based**: Add scale bars with exact pixel dimensions when physical scale is unknown
- **Positioning**: Place scale bars at any corner using CairoMakie-style positioning symbols
- **Flexible**: Both in-place and non-destructive functions available
- **Simple Interface**: Sensible defaults with automatic size calculation

## Installation

```julia
using Pkg
Pkg.add("ScaleBar")
```

## Quick Examples

### Adding a Scale Bar with Physical Units

```julia
using Images, ScaleBar

# Create a test image
img = RGB.(ones(512, 512))

# Add a scale bar representing 10μm (assuming 0.1μm per pixel)
scalebar!(img, 0.1, physical_length=10, units="μm")
```

### Adding a Scale Bar with Pixel Dimensions

```julia
using Images, ScaleBar

# Create a test image
img = RGB.(ones(512, 512))

# Add a 50-pixel scale bar
img_with_bar = scalebar_pixels(img, length=50)
```

## API Reference

### Physical Scale Bars

```julia
scalebar!(img, pixel_size; position=:br, physical_length=auto, width=auto, padding=10, color=:white, units="")
```

Add a scale bar to an image in-place, using physical units.

**Arguments:**
- `img`: Input image (AbstractArray)
- `pixel_size`: Size of each pixel in physical units

**Keyword Arguments:**
- `position`: Position of the scale bar (`:tl`, `:tr`, `:bl`, `:br`), default: `:br`
- `physical_length`: Length of the scale bar in physical units, default: auto-calculated
- `width`: Width of the scale bar in pixels, default: auto-calculated
- `padding`: Padding from the edge of the image in pixels, default: 10
- `color`: Color of the scale bar (`:white` or `:black`), default: `:white`
- `units`: Units for the physical length (e.g., "nm", "μm"), default: ""

```julia
scalebar(img, pixel_size; position=:br, physical_length=auto, width=auto, padding=10, color=:white, units="")
```

Create a new image with a scale bar, using physical units (same parameters as `scalebar!`).

### Pixel-based Scale Bars

```julia
scalebar_pixels!(img; position=:br, length=auto, width=auto, padding=10, color=:white)
```

Add a scale bar to an image in-place, specifying dimensions in pixels directly.

**Arguments:**
- `img`: Input image (AbstractArray)

**Keyword Arguments:**
- `position`: Position of the scale bar (`:tl`, `:tr`, `:bl`, `:br`), default: `:br`
- `length`: Length of the scale bar in pixels, default: auto-calculated
- `width`: Width of the scale bar in pixels, default: auto-calculated
- `padding`: Padding from the edge of the image in pixels, default: 10
- `color`: Color of the scale bar (`:white` or `:black`), default: `:white`

```julia
scalebar_pixels(img; position=:br, length=auto, width=auto, padding=10, color=:white)
```

Create a new image with a scale bar, specifying dimensions in pixels directly (same parameters as `scalebar_pixels!`).

## Position Symbols

Scale bars can be positioned at any of the four corners of the image using CairoMakie-style positioning symbols:

- `:tl` - Top Left
- `:tr` - Top Right
- `:bl` - Bottom Left
- `:br` - Bottom Right (default)

## Automatic Size Calculation

If no length is specified, the scale bar length will be automatically calculated as 10% of the image width, rounded to the nearest 5 pixels. The width will be calculated as 20% of the length, ensuring a visually pleasing aspect ratio.

## Examples

### Different Positions

```julia
using Images, ScaleBar

# Create a test image
img = RGB.(ones(512, 512))

# Bottom right (default)
img1 = scalebar_pixels(img, position=:br)

# Top right
img2 = scalebar_pixels(img, position=:tr)

# Bottom left
img3 = scalebar_pixels(img, position=:bl)

# Top left
img4 = scalebar_pixels(img, position=:tl)
```

### Physical Scale with Different Units

```julia
using Images, ScaleBar

# Create a test image
img = RGB.(ones(512, 512))

# 10 μm scale bar (assuming 0.1μm per pixel)
img1 = scalebar(img, 0.1, physical_length=10, units="μm")

# 5000 nm scale bar (equivalent to 5 μm)
img2 = scalebar(img, 100, physical_length=5000, units="nm")
```