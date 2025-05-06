# ScaleBar

```@meta
CurrentModule = ScaleBar
```

A Julia package to add scale bars to images, facilitating visualization of scale in microscopy and similar applications.

## Overview

ScaleBar.jl provides a simple but powerful way to add scale bars to your images. The package supports both:

1. **Physical scale bars**: When you know the physical size of each pixel (common in microscopy)
2. **Pixel-based scale bars**: When you just want a scale bar of a specific pixel length

Each method is available in both in-place (modifying the original image) and non-destructive versions (returning a new image with the scale bar).

## Installation

```julia
using Pkg
Pkg.add("ScaleBar")
```

## Basic Usage

### Physical Scale Bars

When you know the physical size of each pixel (e.g., in microscopy applications), use the `scalebar` functions to add a scale bar with the appropriate physical dimensions:

```julia
using Images, ScaleBar

# Create a test image
img = RGB.(ones(512, 512))

# Add a scale bar representing 10μm (assuming 0.1μm per pixel)
# This modifies the image in-place
scalebar!(img, 0.1, physical_length=10, units="μm")

# Create a new image with a scale bar
img_with_scalebar = scalebar(img, 0.1, physical_length=10, units="μm")
```

### Pixel-based Scale Bars

When you just want a scale bar of a specific pixel length, use the `scalebar_pixels` functions:

```julia
using Images, ScaleBar

# Create a test image
img = RGB.(ones(512, 512))

# Add a 50-pixel scale bar
# This modifies the image in-place
scalebar_pixels!(img, length=50)

# Create a new image with a scale bar
img_with_scalebar = scalebar_pixels(img, length=50)
```

## Positioning

You can position the scale bar at any of the four corners of the image using CairoMakie-style positioning symbols:

```julia
# Top left
scalebar_pixels!(img, position=:tl)

# Top right
scalebar_pixels!(img, position=:tr)

# Bottom left
scalebar_pixels!(img, position=:bl)

# Bottom right (default)
scalebar_pixels!(img, position=:br)
```

## Customization

You can customize various aspects of the scale bar:

```julia
# Customize dimensions
scalebar!(img, 0.1, 
    physical_length=10,   # Length in physical units
    width=5,              # Width in pixels
    padding=20)           # Padding from the edge

# Customize appearance
scalebar_pixels!(img,
    length=50,            # Length in pixels
    color=:black)         # Color (default is :white)
```

## Automatic Size Calculation

If no length is specified, the scale bar length will be automatically calculated as 10% of the image width, rounded to the nearest 5 pixels. The width will be calculated as 20% of the length, ensuring a visually pleasing aspect ratio.

## API Reference

```@docs
ScaleBar.scalebar
ScaleBar.scalebar!
ScaleBar.scalebar_pixels
ScaleBar.scalebar_pixels!
```