# ScaleBar.jl

The ScaleBar package is a tool for adding scale bars to images, particularly useful for scientific and microscopy applications. It provides a simple, consistent API for adding scale bars with customizable positions, sizes, and colors.

## Overview

Scale bars are essential for providing spatial context in scientific images, especially in microscopy where the actual size of objects isn't immediately apparent. ScaleBar.jl makes it easy to add professional-looking scale bars to your images.

Key features:
- Add scale bars with physical units (μm, nm, etc.) based on pixel size
- Add scale bars with specific pixel dimensions
- Position scale bars in any corner of the image
- Customize size, color, and padding
- Both in-place and non-destructive operations

## Basic Usage

### Physical Scale Bars

To add a scale bar based on physical units:

```julia
using Images, ScaleBar

# Create a test image with gray background for better visibility
img = RGB.(fill(0.5, 512, 512))

# Add a scale bar representing 10μm (assuming 0.1μm per pixel)
scalebar!(img, 0.1, physical_length=10, units="μm")
```

### Pixel-Based Scale Bars

To add a scale bar with pixel dimensions:

```julia
using Images, ScaleBar

# Create a test image with gray background for better visibility
img = RGB.(fill(0.5, 512, 512))

# Add a 50-pixel scale bar
scalebar!(img, length=50)
```

## Different Image Types

ScaleBar.jl works with various image types:

### RGB Images

```julia
# RGB image with gray background
img_rgb = RGB.(fill(0.5, 512, 512))
scalebar!(img_rgb, 0.1, physical_length=10, units="μm")
```

### Grayscale Images

```julia
# Grayscale image
img_gray = Gray.(fill(0.5, 512, 512))
scalebar!(img_gray, 0.1, physical_length=10, units="μm")
```

### Float64 Arrays with Values > 1.0

For Float64 arrays with values greater than 1.0, the scale bar is added with enhanced contrast:

```julia
# Float64 array with values > 1.0
img_float = rand(512, 512) * 100.0  # Values between 0 and 100
scalebar!(img_float, 0.1, physical_length=10, units="μm")
# Scale bar will be drawn with a value 50% higher than the maximum value for visibility
# This ensures the scale bar will stand out even after normalization
```

## API Reference

```@docs
scalebar!
scalebar
```

