using ScaleBar
using Images

"""
This script demonstrates the usage of ScaleBar.jl.
Run this script to generate example images with scale bars.
"""

# Create an output directory
output_dir = "examples"
isdir(output_dir) || mkdir(output_dir)

# Create a test image with a gradient background
function create_test_image(height, width)
    img = zeros(RGB{Float64}, height, width)
    for i in 1:height, j in 1:width
        # Create a medium-gray gradient for better visibility of both white and black scale bars
        img[i, j] = RGB(0.5 - i/height/4, 0.5 - j/width/4, 0.6)
    end
    return img
end

# Demonstrate different scale bar positions
function demo_positions()
    img = create_test_image(400, 600)
    
    # Save the original image
    save("$output_dir/original.png", img)
    
    # Create scale bars at each position
    positions = [:br, :bl, :tr, :tl]
    
    for pos in positions
        img_copy = copy(img)
        scalebar!(img_copy, 100; position=pos, width=20, color=:white)
        save("$output_dir/position_$(pos).png", img_copy)
    end
    
    # Create a combined image with all positions
    img_all = copy(img)
    for pos in positions
        scalebar!(img_all, 80; position=pos, width=15, color=:white)
    end
    save("$output_dir/all_positions.png", img_all)
    
    println("✓ Created position examples")
end

# Demonstrate physical scale bars
function demo_physical_scale()
    img = create_test_image(512, 512)
    
    # Add scale bars with different physical scales
    pixel_sizes = [0.1, 0.05, 0.01]  # μm per pixel
    physical_lengths = [10, 5, 1]    # μm
    
    for (idx, (px_size, phys_len)) in enumerate(zip(pixel_sizes, physical_lengths))
        img_copy = copy(img)
        scalebar!(img_copy, px_size, phys_len; units="μm", position=:br, color=:white)
        save("$output_dir/physical_$(phys_len)um.png", img_copy)
    end
    
    println("✓ Created physical scale examples")
end

# Demonstrate auto-sizing
function demo_auto_sizing()
    # Create images of different sizes
    sizes = [(200, 300), (400, 600), (800, 600)]
    
    for (idx, (height, width)) in enumerate(sizes)
        img = create_test_image(height, width)
        img_copy = copy(img)
        
        # Add a scale bar with explicit length
        # Using ~1/5 of image width as a reasonable default
        scalebar!(img_copy, width ÷ 5; color=:white)
        save("$output_dir/auto_size_$(height)x$(width).png", img_copy)
    end
    
    println("✓ Created auto-sizing examples")
end

# Demonstrate different colors
function demo_colors()
    # Create scale bars with different colors on appropriate backgrounds
    # White scale bar on darker background
    dark_img = fill(RGB(0.3, 0.3, 0.3), 300, 500)
    scalebar!(dark_img, 100; position=:br, width=20, color=:white)
    save("$output_dir/color_white.png", dark_img)
    
    # Black scale bar on lighter background
    light_img = fill(RGB(0.7, 0.7, 0.7), 300, 500)
    scalebar!(light_img, 100; position=:br, width=20, color=:black)
    save("$output_dir/color_black.png", light_img)
    
    # Create a split image with both colors
    split_img = zeros(RGB{Float64}, 300, 500)
    for i in 1:300
        for j in 1:500
            split_img[i, j] = j <= 250 ? RGB(0.3, 0.3, 0.3) : RGB(0.7, 0.7, 0.7)
        end
    end
    
    # Add white scale bar on the dark side
    scalebar!(split_img, 100; position=:bl, width=20, color=:white)
    # Add black scale bar on the light side
    scalebar!(split_img, 100; position=:br, width=20, color=:black)
    save("$output_dir/color_comparison.png", split_img)
    
    println("✓ Created color examples")
end

# Run all demos
function run_examples()
    println("Generating example images in the examples/ directory...")
    
    demo_positions()
    demo_physical_scale()
    demo_auto_sizing()
    demo_colors()
    
    println("\nAll examples created successfully!")
    println("Check the examples/ directory for the output images.")
end

# Run the examples
run_examples()