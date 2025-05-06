using Images
using ScaleBar
using FileIO

"""
This script generates example images demonstrating ScaleBar functionality.
Run this script to create example images in the `examples/` directory.
"""

# Create examples directory if it doesn't exist
!isdir("examples") && mkdir("examples")

# 1. Basic examples with different positions
function create_position_examples()
    # Create a background image with a gradient
    img = zeros(RGB{Float64}, 300, 500)
    for i in 1:300
        for j in 1:500
            img[i, j] = RGB(0.8 - i/300, 0.8 - j/500, 0.9)
        end
    end
    
    # Save the original image
    save("examples/original.png", img)
    
    # Create scale bars at each position
    positions = [:br, :bl, :tr, :tl]
    
    for pos in positions
        img_copy = copy(img)
        scalebar_pixels!(img_copy, position=pos, length=100, width=20, color=:white)
        save("examples/position_$(pos).png", img_copy)
    end
    
    # Create a combined image with all positions
    img_all = copy(img)
    for pos in positions
        scalebar_pixels!(img_all, position=pos, length=80, width=15, color=:white)
    end
    save("examples/all_positions.png", img_all)
    
    println("✓ Created position examples")
end

# 2. Physical scale bar examples
function create_physical_examples()
    # Create a microscopy-like image
    img = zeros(RGB{Float64}, 512, 512)
    # Add some "cells" to the image
    for _ in 1:30
        x = rand(50:462)
        y = rand(50:462)
        radius = rand(10:30)
        
        for i in max(1, y-radius):min(512, y+radius)
            for j in max(1, x-radius):min(512, x+radius)
                if sqrt((i-y)^2 + (j-x)^2) < radius
                    intensity = 0.7 - 0.5 * sqrt((i-y)^2 + (j-x)^2)/radius
                    img[i, j] = RGB(intensity, intensity, intensity + 0.2)
                end
            end
        end
    end
    
    # Save the original image
    save("examples/microscopy_original.png", img)
    
    # Add scale bars with different physical scales
    pixel_sizes = [0.1, 0.05, 0.01]  # µm per pixel
    physical_lengths = [10, 5, 1]    # µm
    
    for (idx, (px_size, phys_len)) in enumerate(zip(pixel_sizes, physical_lengths))
        img_copy = copy(img)
        scalebar!(img_copy, px_size, physical_length=phys_len, units="μm", position=:br, color=:white)
        save("examples/microscopy_$(phys_len)um.png", img_copy)
    end
    
    println("✓ Created physical scale examples")
end

# 3. Color examples
function create_color_examples()
    # Create a neutral gray image
    img = fill(RGB(0.5, 0.5, 0.5), 300, 500)
    
    # Add scale bars with different colors
    colors = [:white, :black]
    
    for color in colors
        img_copy = copy(img)
        scalebar_pixels!(img_copy, position=:br, length=100, width=20, color=color)
        save("examples/color_$(color).png", img_copy)
    end
    
    println("✓ Created color examples")
end

# 4. Special cases
function create_special_examples()
    # Very large image
    img_large = fill(RGB(0.9, 0.9, 0.9), 1000, 2000)
    scalebar_pixels!(img_large, position=:br, color=:black)
    save("examples/large_image.png", img_large)
    
    # Very small image
    img_small = fill(RGB(0.9, 0.9, 0.9), 50, 80)
    scalebar_pixels!(img_small, position=:br, color=:black)
    save("examples/small_image.png", img_small)
    
    # Wide image
    img_wide = fill(RGB(0.9, 0.9, 0.9), 200, 1000)
    scalebar_pixels!(img_wide, position=:br, color=:black)
    save("examples/wide_image.png", img_wide)
    
    # Tall image
    img_tall = fill(RGB(0.9, 0.9, 0.9), 1000, 200)
    scalebar_pixels!(img_tall, position=:br, color=:black)
    save("examples/tall_image.png", img_tall)
    
    println("✓ Created special case examples")
end

# Run all example generation functions
function create_all_examples()
    println("Generating example images in examples/ directory...")
    create_position_examples()
    create_physical_examples()
    create_color_examples()
    create_special_examples()
    println("All examples created successfully!")
end

# Run the example generation when this script is executed
create_all_examples()