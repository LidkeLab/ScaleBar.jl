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

# Create a test image with gray background for better visibility
img = RGB.(fill(0.5, 512, 512))

# In-place with required length
scalebar!(img, 0.1, 10; units="μm")

# Non-destructive with auto-calculated length
img_with_bar1 = scalebar(img, 0.1; units="μm")

# Non-destructive with explicit length
img_with_bar2 = scalebar(img, 0.1; physical_length=10, units="μm")
```

### Adding a Scale Bar with Pixel Dimensions

```julia
using Images, ScaleBar

# Create a test image with gray background for better visibility
img = RGB.(fill(0.5, 512, 512))

# In-place with required length
scalebar!(img, 50)

# Non-destructive with auto-calculated length
img_with_bar1 = scalebar(img)

# Non-destructive with explicit length
img_with_bar2 = scalebar(img; length=50)
```

## API Reference

ScaleBar.jl provides a clean, unified API with two main functions:

- `scalebar!`: Modifies the image in-place (length required)
- `scalebar`: Creates and returns a new image with the scale bar (length optional)

Each function has two methods:

### Working with Physical Units

```julia
# In-place version (length is required)
scalebar!(img, pixel_size, physical_length; 
    position=:br, 
    width=nothing, 
    padding=10, 
    color=:white, 
    units="")

# Non-mutating version (length is optional)
# Auto-calculated length
scalebar(img, pixel_size; 
    position=:br, 
    width=nothing, 
    padding=10, 
    color=:white, 
    units="")

# Explicit length
scalebar(img, pixel_size; 
    physical_length=10,
    position=:br, 
    width=nothing, 
    padding=10, 
    color=:white, 
    units="")
```

**Parameters**:
- `img`: Input image (AbstractArray)
- `pixel_size`: Size of each pixel in physical units (e.g., 0.1 for 0.1μm per pixel)
- `physical_length`: Length of the scale bar in physical units (required for in-place version)

**Keyword Arguments**:
- `position`: Position of the scale bar (`:tl`, `:tr`, `:bl`, `:br`), default: `:br`
- `physical_length`: Length of the scale bar in physical units (optional for non-destructive version)
- `width`: Width of the scale bar in pixels, default: auto-calculated
- `padding`: Padding from the edge of the image in pixels, default: 10
- `color`: Color of the scale bar (`:white` or `:black`), default: `:white`
- `units`: Units for the physical length (e.g., "nm", "μm"), default: ""

### Working with Pixel Dimensions

```julia
# In-place version (length is required)
scalebar!(img, length; 
    position=:br, 
    width=nothing, 
    padding=10, 
    color=:white)

# Non-mutating version (length is optional)
# Auto-calculated length
scalebar(img; 
    position=:br, 
    width=nothing, 
    padding=10, 
    color=:white)

# Explicit length
scalebar(img; 
    length=50,
    position=:br, 
    width=nothing, 
    padding=10, 
    color=:white)
```

**Parameters**:
- `img`: Input image (AbstractArray)
- `length`: Length of the scale bar in pixels (required for in-place version)

**Keyword Arguments**:
- `position`: Position of the scale bar (`:tl`, `:tr`, `:bl`, `:br`), default: `:br`
- `length`: Length of the scale bar in pixels (optional for non-destructive version)
- `width`: Width of the scale bar in pixels, default: auto-calculated
- `padding`: Padding from the edge of the image in pixels, default: 10
- `color`: Color of the scale bar (`:white` or `:black`), default: `:white`

## Notes and Best Practices

1. For `scalebar!` functions, you must always specify the scale bar length explicitly
2. For `scalebar` functions, you can either let the length be auto-calculated or specify it explicitly
3. Auto-calculated lengths are designed to be ~10% of the image width and rounded to a "nice" value
4. Choose contrasting colors for better visibility (white on dark backgrounds, black on light)

