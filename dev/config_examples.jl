using Images
using TestImages
using ScaleBar
using FileIO

# Create output directory if it doesn't exist
output_dir = joinpath(@__DIR__, "output")
mkpath(output_dir)

# Load test images
img_gray = Float64.(testimage("cameraman"))
img_color = testimage("lighthouse")

# Create a configuration for consistent appearance
config = ScaleBarConfig(
    position=:br,
    height=10,         # Fixed height of 10 pixels
    width=nothing,     # Auto-calculate width
    padding=20,
    color=:white
)

println("Using ScaleBarConfig for consistent appearance across images")
println("Config: position=$(config.position), height=$(config.height), padding=$(config.padding), color=$(config.color)")

# Example 1: Use config with grayscale image
result1 = scalebar(img_gray, 0.1; config=config, physical_length=50, units="μm")
save(joinpath(output_dir, "config_gray.png"), result1.image)
println("Created config_gray.png with $(result1.physical_length)μm scale bar")

# Example 2: Use config with color image
result2 = scalebar(img_color, 0.2; config=config, physical_length=100, units="μm")
save(joinpath(output_dir, "config_color.png"), result2.image)
println("Created config_color.png with $(result2.physical_length)μm scale bar")

# Example 3: Override config values
result3 = scalebar(img_gray, 0.1; config=config, color=:black, physical_length=50, units="μm")
save(joinpath(output_dir, "config_override.png"), result3.image)
println("Created config_override.png with black scale bar (overriding config)")

# Example 4: Create different configs for different purposes
config_tl = ScaleBarConfig(position=:tl, color=:black, padding=30)
config_br = ScaleBarConfig(position=:br, color=:white, padding=10)

# Apply different configs to copies of the same image
img_copy1 = copy(img_gray)
img_copy2 = copy(img_gray)

scalebar!(img_copy1, 0.1, 50; config=config_tl, units="μm")
scalebar!(img_copy2, 0.1, 50; config=config_br, units="μm")

save(joinpath(output_dir, "config_tl.png"), img_copy1)
save(joinpath(output_dir, "config_br.png"), img_copy2)
println("Created images with different configs: config_tl.png and config_br.png")

# Example 5: Batch processing with consistent appearance
println("\nBatch processing example:")
images = [
    Float64.(Gray.(testimage("cameraman"))),
    Float64.(Gray.(testimage("house"))),  # Convert GrayA to Gray
    Float64.(Gray.(testimage("peppers_gray")))
]

# Process all images with the same config
for (i, img) in enumerate(images)
    result = scalebar(img, 0.15; config=config, units="μm")
    filename = joinpath(output_dir, "batch_$(i).png")
    save(filename, result.image)
    println("  Processed image $i with $(result.physical_length)μm scale bar")
end

println("\nAll examples saved to: $output_dir")