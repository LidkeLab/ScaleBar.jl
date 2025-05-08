# Examples

## Basic Examples

Here are some examples of how to use ScaleBar.jl in common scenarios.

### Physical Scale Bars

When working with microscopy images where you know the physical size of each pixel:

```julia
using Images, ScaleBar

# Create a test image (or load your own)
img = RGB.(ones(512, 512))

# Add a scale bar representing 10μm (assuming 0.1μm per pixel)
scalebar!(img, 0.1, 10; units="μm")
```

### Pixel-based Scale Bars

When you just need a scale bar of a specific pixel length:

```julia
using Images, ScaleBar

# Create a test image
img = RGB.(ones(512, 512))

# Add a 50-pixel scale bar
result = scalebar(img; length=50, color=:black)
img_with_bar = result.image
pixel_length = result.pixel_length  # Length of the scale bar in pixels
```

## Positioning Examples

Scale bars can be positioned at any of the four corners of the image:

```julia
# Bottom right (default)
scalebar!(img, 50; position=:br)

# Bottom left
scalebar!(img, 50; position=:bl)

# Top right
scalebar!(img, 50; position=:tr)

# Top left
scalebar!(img, 50; position=:tl)
```

## Customization Examples

You can customize various aspects of the scale bar:

```julia
# Custom dimensions
scalebar!(img, 100;    # 100 pixels long
    width=10,      # 10 pixels tall
    padding=20     # 20 pixels from the edge
)

# Custom color
scalebar!(img, 50; color=:black)  # Black scale bar (default is white)
```

## Real-world Examples

### Microscopy Image Example

Here's a common workflow for microscopy images:

```julia
using Images, ScaleBar, FileIO

# Load a microscopy image
img = load("microscopy_image.tif")

# Add a scale bar (assuming pixel size is 0.05μm)
pixel_size = 0.05  # μm per pixel
scalebar!(img, pixel_size, 10;  # 10μm scale bar
    position=:br,        # Bottom right
    color=:white,        # White color
    units="μm"           # Units displayed in output
)

# Save the result
save("microscopy_with_scalebar.tif", img)
```

### Processing Multiple Images

You can easily process multiple images in a batch:

```julia
using Images, ScaleBar, FileIO

# Process all TIF files in a directory
image_dir = "path/to/images"
output_dir = "path/to/output"
isdir(output_dir) || mkdir(output_dir)

# Pixel size in μm
pixel_size = 0.1

for file in readdir(image_dir)
    if endswith(file, ".tif") || endswith(file, ".tiff")
        # Load image
        img = load(joinpath(image_dir, file))
        
        # Add scale bar
        scalebar!(img, pixel_size, 10;
            position=:br, 
            color=:white, 
            units="μm"
        )
        
        # Save result
        save(joinpath(output_dir, file), img)
    end
end
```

## Return Value Examples

The non-mutating `scalebar` function returns a named tuple with the image and information about the scale bar:

```julia
# Physical units version
result = scalebar(img, 0.1; physical_length=10, units="μm")
new_img = result.image                  # The new image with a scale bar
physical_length = result.physical_length # The physical length of the scale bar
pixel_length = result.pixel_length      # The length in pixels
units = result.units                    # The units used

# Using destructuring for cleaner code
(; image, physical_length, pixel_length, units) = scalebar(img, 0.1; physical_length=5, units="μm")
println("Scale bar is $physical_length $units ($pixel_length pixels)")

# Pixel version
result = scalebar(img; length=50)
new_img = result.image
pixel_length = result.pixel_length
```

## Advanced Usage

### Creating a Consistent Scale Bar for Image Series

When working with a series of images that should have consistent scale bars:

```julia
using Images, ScaleBar, FileIO

function add_consistent_scalebar(image_paths, output_dir, pixel_size, physical_length; position=:br, width=nothing, padding=10, color=:white, units="")
    # Create output directory if it doesn't exist
    isdir(output_dir) || mkdir(output_dir)
    
    # Process each image
    for path in image_paths
        # Load image
        img = load(path)
        
        # Add scale bar with consistent settings
        scalebar!(img, pixel_size, physical_length, position=position, width=width, padding=padding, color=color, units=units)
        
        # Save with the same filename
        filename = basename(path)
        save(joinpath(output_dir, filename), img)
    end
end

# Usage
image_paths = ["img1.tif", "img2.tif", "img3.tif"]
add_consistent_scalebar(
    image_paths, 
    "output", 
    0.1,                 # pixel size
    5,                   # 5μm scale bar
    position=:br,        # bottom right
    color=:white,        # white color
    units="μm"           # show units
)
```