# ScaleBar.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://LidkeLab.github.io/ScaleBar.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://LidkeLab.github.io/ScaleBar.jl/dev/)
[![Build Status](https://github.com/LidkeLab/ScaleBar.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/LidkeLab/ScaleBar.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/LidkeLab/ScaleBar.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/LidkeLab/ScaleBar.jl)

A Julia package for adding scale bars to images, particularly useful for scientific and microscopy applications.

## Features

- **Physical Scale Bars**: Add scale bars with proper physical dimensions (μm, nm, etc.)
- **Pixel-based Scale Bars**: Add scale bars with exact pixel dimensions
- **Flexible Positioning**: Place scale bars at any corner using CairoMakie-style position symbols
- **Smart Defaults**: Automatically calculates sensible scale bar dimensions based on image size
- **In-place and Non-destructive**: Choose between modifying images or creating new copies

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

# Display the image
img
```

### Adding a Scale Bar with Pixel Dimensions

```julia
using Images, ScaleBar

# Create a test image
img = RGB.(ones(512, 512))

# Add a 50-pixel scale bar
img_with_bar = scalebar_pixels(img, length=50)

# Display the new image
img_with_bar
```

## API Reference

### Working with Physical Units

The primary API consists of two functions: `scalebar` (returns a new image) and `scalebar!` (modifies in-place).

```julia
scalebar!(img, pixel_size; position=:br, physical_length=auto, width=auto, padding=10, color=:white, units="")
scalebar(img, pixel_size; position=:br, physical_length=auto, width=auto, padding=10, color=:white, units="")
```

**Parameters**:
- `img`: Input image (AbstractArray)
- `pixel_size`: Size of each pixel in physical units (e.g., 0.1 for 0.1μm per pixel)

**Keyword Arguments**:
- `position`: Position of the scale bar (`:tl`, `:tr`, `:bl`, `:br`), default: `:br`
- `physical_length`: Length of the scale bar in physical units, default: auto-calculated
- `width`: Width of the scale bar in pixels, default: auto-calculated
- `padding`: Padding from the edge of the image in pixels, default: 10
- `color`: Color of the scale bar (`:white` or `:black`), default: `:white`
- `units`: Units for the physical length (e.g., "nm", "μm"), default: ""

### Working with Pixel Dimensions

For cases where you don't know or don't care about the physical scale, use these dedicated functions:

```julia
scalebar_pixels!(img; position=:br, length=auto, width=auto, padding=10, color=:white)
scalebar_pixels(img; position=:br, length=auto, width=auto, padding=10, color=:white)
```

**Parameters**:
- `img`: Input image (AbstractArray)

**Keyword Arguments**:
- `position`: Position of the scale bar (`:tl`, `:tr`, `:bl`, `:br`), default: `:br`
- `length`: Length of the scale bar in pixels, default: auto-calculated
- `width`: Width of the scale bar in pixels, default: auto-calculated
- `padding`: Padding from the edge of the image in pixels, default: 10
- `color`: Color of the scale bar (`:white` or `:black`), default: `:white`

## Positioning

Scale bars can be positioned at any of the four corners of the image using these symbols:

- `:tl` - Top Left
- `:tr` - Top Right
- `:bl` - Bottom Left
- `:br` - Bottom Right (default)

## Advanced Examples

### Different Positions

```julia
using Images, ScaleBar

# Create a test image
img = RGB.(ones(512, 512))

# Add scale bars at different positions
img_br = scalebar_pixels(img, position=:br, color=:black)  # Bottom right
img_bl = scalebar_pixels(img, position=:bl, color=:black)  # Bottom left
img_tr = scalebar_pixels(img, position=:tr, color=:black)  # Top right
img_tl = scalebar_pixels(img, position=:tl, color=:black)  # Top left
```

### Customizing Dimensions

```julia
using Images, ScaleBar

# Create a test image
img = RGB.(ones(512, 512))

# Add a custom-sized scale bar
scalebar_pixels!(img, 
    length=100,    # 100 pixels long
    width=15,      # 15 pixels tall
    padding=20,    # 20 pixels from the edge
    color=:black
)
```

### Real Microscopy Example

```julia
using Images, ScaleBar, FileIO

# Load a microscopy image
img = load("microscopy_image.tif")

# Add a scale bar (assuming pixel size is 0.05μm)
pixel_size = 0.05  # μm per pixel
scalebar!(img, pixel_size, 
    physical_length=10,  # 10μm scale bar
    position=:br,        # Bottom right
    color=:white,        # White color
    units="μm"           # Units displayed in output
)

# Save the result
save("microscopy_with_scalebar.tif", img)
```

## Auto-sizing

If no length is specified, the scale bar length will be automatically calculated as 10% of the image width, rounded to the nearest 5 pixels. The width will be calculated as 20% of the length, ensuring a visually pleasing aspect ratio.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This package is licensed under the MIT License - see the LICENSE file for details.