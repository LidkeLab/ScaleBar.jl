using ScaleBar
using Images

"""
This script demonstrates the updated ScaleBar.jl API that requires explicitly 
specifying the scale bar length. This ensures users always know what the scale 
bar represents.
"""

# Create an output directory
output_dir = "examples"
isdir(output_dir) || mkdir(output_dir)

# Demonstrate physical scale bars with required length
function demo_physical_scale_required_length()
    println("Testing physical scale bars with required length...")
    
    # Create a test image
    img = RGB.(fill(0.5, 512, 512))
    
    # Add a scale bar with physical units, explicitly specifying the length (required parameter)
    pixel_size = 0.1  # μm per pixel
    physical_length = 10.0  # μm
    
    # Add the scale bar in-place
    img_copy1 = copy(img)
    scalebar!(img_copy1, pixel_size, physical_length; units="μm")
    
    # Save the image
    save("$output_dir/physical_required.png", img_copy1)
    
    # Non-destructive version
    img_copy2 = copy(img)
    img_with_bar = scalebar(img_copy2, pixel_size; physical_length=physical_length, units="μm", position=:tr)
    
    # No longer returns scale bar info
    println("Physical scale bar added at position :tr")
    
    # Save the image
    save("$output_dir/physical_nondestructive.png", img_with_bar)
    
    println("✓ Physical scale bar examples with required length created\n")
end

# Demonstrate pixel-based scale bars with required length
function demo_pixel_scale_required_length()
    println("Testing pixel-based scale bars with required length...")
    
    # Create a test image
    img = RGB.(fill(0.5, 512, 512))
    
    # Explicitly specify the pixel length (required parameter)
    length_px = 75  # pixels
    
    # Add the scale bar in-place
    img_copy1 = copy(img)
    scalebar!(img_copy1, length_px)
    
    # Save the image
    save("$output_dir/pixel_required.png", img_copy1)
    
    # Non-destructive version
    img_copy2 = copy(img)
    img_with_bar = scalebar(img_copy2; length=length_px, position=:tr)
    
    # No longer returns scale bar info
    println("Pixel scale bar added at position :tr")
    
    # Save the image
    save("$output_dir/pixel_nondestructive.png", img_with_bar)
    
    println("✓ Pixel scale bar examples with required length created\n")
end

# Demonstrate custom positioning and appearance
function demo_custom_appearance()
    println("Testing custom positioning and appearance...")
    
    # Create a test image
    img = RGB.(fill(0.5, 512, 512))
    
    # Different positions and colors
    positions = [:tl, :tr, :bl, :br]
    colors = [:white, :black]
    
    for (i, position) in enumerate(positions)
        color = colors[mod1(i, length(colors))]
        img_copy = copy(img)
        
        # Add a scale bar with custom settings
        scalebar!(img_copy, 50; 
            position=position, 
            width=10,
            padding=15,
            color=color,
            quiet=true  # Suppress console output
        )
        
        # Save the image
        save("$output_dir/custom_$(position)_$(color).png", img_copy)
    end
    
    println("✓ Custom appearance examples created\n")
end

# Run the examples
function run_examples()
    println("Demonstrating the updated ScaleBar.jl API with required length parameters...")
    
    demo_physical_scale_required_length()
    demo_pixel_scale_required_length()
    demo_custom_appearance()
    
    println("\nAll examples created successfully!")
    println("Check the examples/ directory for the output images.")
end

# Run the examples
run_examples()