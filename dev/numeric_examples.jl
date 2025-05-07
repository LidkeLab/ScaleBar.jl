using ScaleBar
using Images

"""
This script demonstrates how ScaleBar.jl works with different numeric array types,
including Float64 arrays with values > 1.0.
"""

# Create an output directory
output_dir = "examples"
isdir(output_dir) || mkdir(output_dir)

# Create numeric arrays with different value ranges
function demo_numeric_arrays()
    println("Testing scale bars on numeric arrays...")
    
    # 1. Standard Float64 array with values between 0 and 1
    img_standard = rand(300, 400)
    img_standard_copy = copy(img_standard)
    scalebar!(img_standard_copy, 80; position=:br, width=15, color=:white)
    save("$output_dir/numeric_standard.png", Gray.(img_standard_copy))
    println("✓ Standard Float64 array (0-1) example created")
    
    # 2. Float64 array with values up to 100
    img_large = rand(300, 400) .* 100.0
    img_large_copy = copy(img_large)
    scalebar!(img_large_copy, 80; position=:br, width=15, color=:white)
    
    # Check values in the scale bar region
    ROI = img_large_copy[270:290, 300:380]  # Region where scale bar should be
    max_val = maximum(img_large)
    uses_max = isapprox(maximum(ROI), max_val, rtol=0.01)
    
    # For visualization: normalize properly to [0,1] range when saving to PNG
    normalized = img_large_copy ./ maximum(img_large_copy)
    save("$output_dir/numeric_large_values.png", Gray.(normalized))
    
    println("✓ Large value Float64 array example created (uses max value: $uses_max)")
    
    # 3. Integer array
    img_int = rand(UInt8, 300, 400)
    img_int_copy = copy(img_int)
    scalebar!(img_int_copy, 80; position=:bl, width=15, color=:white)
    save("$output_dir/numeric_integer.png", Gray.(img_int_copy ./ 255))
    println("✓ Integer array example created")
    
    println("All numeric array examples created successfully!")
end

# Create a test with different colors on different value ranges
function demo_colors_on_values()
    println("Testing scale bar colors on different value ranges...")
    
    # 1. Standard value range (0-1) with white scale bar
    img1 = fill(0.3, 300, 400)  # Dark gray background
    scalebar!(img1, 80; position=:br, width=15, color=:white)
    save("$output_dir/values_0_1_white.png", Gray.(img1))
    
    # 2. Standard value range (0-1) with black scale bar
    img2 = fill(0.7, 300, 400)  # Light gray background
    scalebar!(img2, 80; position=:br, width=15, color=:black)
    save("$output_dir/values_0_1_black.png", Gray.(img2))
    
    # 3. Large value range (0-100) with white scale bar
    img3 = fill(30.0, 300, 400)  # Value = 30
    # Add white scale bar (uses max value = 100.0)
    scalebar!(img3, 80; position=:br, width=15, color=:white)
    # Normalize to [0,1] range for saving
    save("$output_dir/values_large_white.png", Gray.(img3 ./ maximum(img3)))
    
    # 4. Large value range (0-100) with black scale bar
    img4 = fill(70.0, 300, 400)  # Value = 70
    scalebar!(img4, 80; position=:br, width=15, color=:black)
    # Normalize to [0,1] range for saving
    save("$output_dir/values_large_black.png", Gray.(img4 ./ maximum(img4)))
    
    println("All color value examples created successfully!")
end

# Run the example scripts
demo_numeric_arrays()
demo_colors_on_values()