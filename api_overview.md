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

Adds a scale bar directly to the input image, modifying it. Length must be explicitly specified.

```julia
# With physical units
scalebar!(img, pixel_size, physical_length; 
    position=:br, 
    width=nothing, 
    padding=10, 
    color=:white, 
    units="")

# With pixel dimensions
scalebar!(img, length; 
    position=:br, 
    width=nothing, 
    padding=10, 
    color=:white)
```

### `scalebar` - Non-destructive Scale Bar Addition

Creates a new image with the scale bar added and returns information about the scale bar. Length can be auto-calculated or explicitly specified. Returns a named tuple containing the image and details about the scale bar.

```julia
# With physical units
# Auto-calculated length
result1 = scalebar(img, pixel_size; 
    position=:br, 
    width=nothing, 
    padding=10, 
    color=:white, 
    units="")
img_with_bar1 = result1.image
auto_physical_length = result1.physical_length
auto_pixel_length = result1.pixel_length
units = result1.units

# Explicit length
result2 = scalebar(img, pixel_size; 
    physical_length=10,
    position=:br, 
    width=nothing, 
    padding=10, 
    color=:white, 
    units="")
img_with_bar2 = result2.image
# Can also use destructuring syntax
(; image, physical_length, pixel_length) = result2

# With pixel dimensions
# Auto-calculated length
result3 = scalebar(img; 
    position=:br, 
    width=nothing, 
    padding=10, 
    color=:white)
img_with_bar3 = result3.image
auto_pixel_length = result3.pixel_length

# Explicit length
result4 = scalebar(img; 
    length=50,
    position=:br, 
    width=nothing, 
    padding=10, 
    color=:white)
img_with_bar4 = result4.image
# Can also use destructuring syntax
(; image, pixel_length) = result4
```

## Parameters

### Common Parameters

- `img`: Input image (Any `AbstractArray` type, including RGB or grayscale images)
- `position`: Position of the scale bar (`:tl`, `:tr`, `:bl`, `:br`), default: `:br` (bottom-right)
- `width`: Width of the scale bar in pixels, default: auto-calculated (20% of length, odd number)
- `padding`: Padding from the edge of the image in pixels, default: 10
- `color`: Color of the scale bar (`:white` or `:black`), default: `:white`

### Physical Units Method Parameters

For `scalebar!` (in-place):
- `pixel_size`: Size of each pixel in physical units (e.g., 0.1 for 0.1μm per pixel) - required
- `physical_length`: Length of the scale bar in physical units - required
- `units`: Units for the physical length (e.g., "nm", "μm"), default: ""

For `scalebar` (non-destructive):
- `pixel_size`: Size of each pixel in physical units (e.g., 0.1 for 0.1μm per pixel) - required
- `physical_length`: Length of the scale bar in physical units - optional, auto-calculated if not provided
- `units`: Units for the physical length (e.g., "nm", "μm"), default: ""

### Pixel Dimensions Method Parameters

For `scalebar!` (in-place):
- `length`: Length of the scale bar in pixels - required

For `scalebar` (non-destructive):
- `length`: Length of the scale bar in pixels - optional, auto-calculated if not provided

## Automatic Width Calculation

When width is not explicitly provided, ScaleBar.jl uses smart defaults:

- **Bar Width**: 20% of length, ensured to be an odd number for symmetry

## Working with Different Image Types

### RGB and Grayscale Images

Works directly with standard image formats:

```julia
using Images, ScaleBar

# RGB image with scale bar
img_rgb = RGB.(fill(0.5, 512, 512))
scalebar!(img_rgb, 0.1, 10; units="μm")

# Grayscale image with scale bar
img_gray = Gray.(rand(512, 512))
scalebar!(img_gray, 0.1, 10; units="μm")
```

### Numeric Arrays

Works with raw numeric arrays, providing appropriate handling:

```julia
# Float64 array (0.0 to 1.0)
img_float = rand(512, 512)  # Values between 0 and 1
scalebar!(img_float, 50; color=:white)

# Float64 array with values > 1.0
img_large = rand(512, 512) * 100.0  # Values between 0 and 100
scalebar!(img_large, 50; color=:white)
# Scale bar will use the maximum value in the array
```

## Examples

### Adding a Scale Bar with Physical Units

```julia
using Images, ScaleBar

# Create a test image
img = RGB.(fill(0.5, 512, 512))

# In-place with required length
scalebar!(img, 0.1, 10; units="μm")

# Non-destructive with auto-calculated length
result1 = scalebar(img, 0.1; units="μm")
img_with_bar1 = result1.image
auto_physical_length = result1.physical_length  # Get the actual physical length used
auto_pixel_length = result1.pixel_length        # Get the length in pixels

# Non-destructive with explicit length
result2 = scalebar(img, 0.1; physical_length=10, units="μm")
img_with_bar2 = result2.image
# Access properties or use destructuring syntax
(; image, physical_length, pixel_length, units) = result2
```

### Adding a Scale Bar with Pixel Dimensions

```julia
using Images, ScaleBar

# Create a test image
img = RGB.(fill(0.5, 512, 512))

# In-place with required length
scalebar!(img, 50)

# Non-destructive with auto-calculated length
result1 = scalebar(img)
img_with_bar1 = result1.image
auto_pixel_length = result1.pixel_length  # Get the actual pixel length used

# Non-destructive with explicit length
result2 = scalebar(img; length=50)
img_with_bar2 = result2.image
pixel_length = result2.pixel_length  # Should be 50
```

### Customizing Position and Appearance

```julia
using Images, ScaleBar

# Create a test image
img = RGB.(fill(0.5, 512, 512))

# In-place with required length (top-left corner, black)
scalebar!(img, 0.1, 5; 
    position=:tl,
    width=8,
    padding=15,
    color=:black,
    units="μm")

# Non-destructive with custom appearance
result = scalebar(img, 0.1;
    physical_length=5,
    position=:tr,
    width=8,
    padding=15,
    color=:black,
    units="μm")
img_with_bar = result.image
# You can also print information about the scale bar
println("Scale bar: $(result.physical_length) $(result.units) ($(result.pixel_length) pixels)")
```

## Processing Multiple Images

Examples of processing multiple images in a batch:

```julia
# Process multiple images with in-place modification
for file in image_files
    img = load(file)
    scalebar!(img, 0.1, 10; units="μm")
    save("with_scalebar_$(file)", img)
end

# Process multiple images with non-destructive creation
processed_images = []
scale_bar_info = []
for file in image_files
    img = load(file)
    result = scalebar(img, 0.1; physical_length=10, units="μm")
    push!(processed_images, result.image)
    # Also store the scale bar information if needed
    push!(scale_bar_info, (physical_length=result.physical_length, 
                          pixel_length=result.pixel_length, 
                          units=result.units))
end
```

## Notes and Best Practices

1. For `scalebar!` functions, you must always specify the scale bar length explicitly
2. For `scalebar` functions, you can either let the length be auto-calculated or specify it explicitly 
3. The non-mutating `scalebar` function returns a named tuple with:
   - `image`: The new image with the scale bar added
   - `physical_length`: The physical length of the scale bar (for physical units version)
   - `pixel_length`: The length of the scale bar in pixels
   - `units`: The units of the physical length (for physical units version)
4. You can use destructuring to extract the fields you need: `(; image, physical_length) = scalebar(...)`
5. Auto-calculated lengths are designed to be ~10% of the image width and rounded to a "nice" value
6. For numeric arrays with values > 1.0, white scale bars use the maximum value in the array
7. When saving images with scale bars, normalize numeric arrays to [0,1] range
8. Choose contrasting colors for better visibility (white on dark backgrounds, black on light)
9. The in-place version (`scalebar!`) modifies the original image, while `scalebar` creates a copy
10. Position the scale bar where it doesn't obscure important image features