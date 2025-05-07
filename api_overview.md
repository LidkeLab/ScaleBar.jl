# ScaleBar.jl API Overview

ScaleBar.jl is a Julia package for adding scale bars to images, particularly useful for scientific and microscopy applications.

## Key Concepts

- **Scale Bar**: A visual indicator showing the physical or pixel dimensions in an image
- **Physical Units**: Real-world measurements (μm, nm, etc.) that pixels represent
- **Positioning**: Where the scale bar appears in the image (top-left, bottom-right, etc.)
- **In-place vs. Non-destructive**: Choose between modifying the original image or creating a new copy

## Essential Functions

ScaleBar.jl provides a clean, unified API with two main functions:

### `scalebar!` - In-place Scale Bar Addition

Adds a scale bar directly to the input image, modifying it.

```julia
# With physical units
scalebar!(img, pixel_size; 
    position=:br,
    physical_length=nothing, 
    width=nothing, 
    padding=10, 
    color=:white, 
    units="")

# With pixel dimensions
scalebar!(img; 
    position=:br, 
    length=nothing, 
    width=nothing, 
    padding=10, 
    color=:white)
```

### `scalebar` - Non-destructive Scale Bar Addition

Creates and returns a new image with the scale bar added.

```julia
# With physical units
scalebar(img, pixel_size; 
    position=:br, 
    physical_length=nothing, 
    width=nothing, 
    padding=10, 
    color=:white, 
    units="")

# With pixel dimensions
scalebar(img; 
    position=:br, 
    length=nothing, 
    width=nothing, 
    padding=10, 
    color=:white)
```

## Parameters

### Common Parameters

- `img`: Input image (Any `AbstractArray` type, including RGB or grayscale images)
- `position`: Position of the scale bar (`:tl`, `:tr`, `:bl`, `:br`), default: `:br` (bottom-right)
- `width`: Width of the scale bar in pixels, default: auto-calculated (20% of length, odd number)
- `padding`: Padding from the edge of the image in pixels, default: 10
- `color`: Color of the scale bar (`:white` or `:black`), default: `:white`

### Physical Units Method Parameters

- `pixel_size`: Size of each pixel in physical units (e.g., 0.1 for 0.1μm per pixel)
- `physical_length`: Length of the scale bar in physical units, default: auto-calculated
- `units`: Units for the physical length (e.g., "nm", "μm"), default: ""

### Pixel Dimensions Method Parameters

- `length`: Length of the scale bar in pixels, default: auto-calculated (10% of image width)

## Automatic Calculation Logic

When parameters are not explicitly provided, ScaleBar.jl uses smart defaults:

- **Bar Length**: 10% of image width, rounded to nearest 5 pixels
- **Bar Width**: 20% of length, ensured to be an odd number for symmetry
- **Physical Length**: Calculated from specified pixel size when using pixel dimensions

## Working with Different Image Types

### RGB and Grayscale Images

Works directly with standard image formats:

```julia
using Images, ScaleBar

# RGB image with scale bar
img_rgb = RGB.(fill(0.5, 512, 512))
scalebar!(img_rgb, 0.1, physical_length=10, units="μm")

# Grayscale image with scale bar
img_gray = Gray.(rand(512, 512))
scalebar!(img_gray, 0.1, physical_length=10, units="μm")
```

### Numeric Arrays

Works with raw numeric arrays, providing appropriate handling:

```julia
# Float64 array (0.0 to 1.0)
img_float = rand(512, 512)  # Values between 0 and 1
scalebar!(img_float; length=50, color=:white)

# Float64 array with values > 1.0
img_large = rand(512, 512) * 100.0  # Values between 0 and 100
scalebar!(img_large; length=50, color=:white)
# Scale bar will use the maximum value in the array
```

## Examples

### Adding a Scale Bar with Physical Units

```julia
using Images, ScaleBar

# Create a test image
img = RGB.(fill(0.5, 512, 512))

# Add a scale bar representing 10μm (assuming 0.1μm per pixel)
scalebar!(img, 0.1, physical_length=10, units="μm")
```

### Adding a Scale Bar with Pixel Dimensions

```julia
using Images, ScaleBar

# Create a test image
img = RGB.(fill(0.5, 512, 512))

# Add a 50-pixel scale bar to a new copy of the image
img_with_bar = scalebar(img, length=50)
```

### Customizing Position and Appearance

```julia
using Images, ScaleBar

# Create a test image
img = RGB.(fill(0.5, 512, 512))

# Add a black scale bar in the top-left corner
scalebar!(img, 0.1, 
    position=:tl,
    physical_length=5, 
    width=8,
    padding=15,
    color=:black,
    units="μm")
```

## Notes and Best Practices

1. For numeric arrays with values > 1.0, white scale bars use the maximum value in the array
2. When saving images with scale bars, normalize numeric arrays to [0,1] range
3. Choose contrasting colors for better visibility (white on dark backgrounds, black on light)
4. The in-place version (`scalebar!`) modifies the original image, while `scalebar` creates a copy
5. Position the scale bar where it doesn't obscure important image features