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
scalebar!(img, 0.1, physical_length=10, units="μm")
```

### Pixel-based Scale Bars

When you just need a scale bar of a specific pixel length:

```julia
using Images, ScaleBar

# Create a test image
img = RGB.(ones(512, 512))

# Add a 50-pixel scale bar
img_with_bar = scalebar_pixels(img, length=50, color=:black)
```

## Positioning Examples

Scale bars can be positioned at any of the four corners of the image:

```julia
# Bottom right (default)
scalebar_pixels!(img, position=:br)

# Bottom left
scalebar_pixels!(img, position=:bl)

# Top right
scalebar_pixels!(img, position=:tr)

# Top left
scalebar_pixels!(img, position=:tl)
```

## Customization Examples

You can customize various aspects of the scale bar:

```julia
# Custom dimensions
scalebar_pixels!(img, 
    length=100,    # 100 pixels long
    width=10,      # 10 pixels tall
    padding=20     # 20 pixels from the edge
)

# Custom color
scalebar_pixels!(img, color=:black)  # Black scale bar (default is white)
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
scalebar!(img, pixel_size, 
    physical_length=10,  # 10μm scale bar
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
        scalebar!(img, pixel_size, 
            physical_length=10, 
            position=:br, 
            color=:white, 
            units="μm"
        )
        
        # Save result
        save(joinpath(output_dir, file), img)
    end
end
```

## Advanced Usage

### Creating a Consistent Scale Bar for Image Series

When working with a series of images that should have consistent scale bars:

```julia
using Images, ScaleBar, FileIO

function add_consistent_scalebar(image_paths, output_dir, pixel_size, options...)
    # Create output directory if it doesn't exist
    isdir(output_dir) || mkdir(output_dir)
    
    # Process each image
    for path in image_paths
        # Load image
        img = load(path)
        
        # Add scale bar with consistent settings
        scalebar!(img, pixel_size; options...)
        
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
    physical_length=5,   # 5μm scale bar
    position=:br,        # bottom right
    color=:white,        # white color
    units="μm"           # show units
)
```