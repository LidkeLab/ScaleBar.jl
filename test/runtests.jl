using Test
using Images
using Colors
using ScaleBar
using TestImages

include("test_helpers.jl")

@testset "scalebar_test" begin
    # Test scenario
    img = Gray.(zeros(512,512))
    physical_length = 100 # length of the scalebar in physical units
    width = 20 # width of the scalebar in pixels
    pixel_size = 1.0 # size of a pixel in physical units
    
    # Add scalebar to the image (bottom left position)
    result = scalebar(img, pixel_size; 
        physical_length=physical_length,
        color=:white, 
        position=:bl, 
        width=width, 
        padding=10
    )
    
    # Extract the image from the result
    img_with_bar = result.image
    
    # Verify that the returned physical_length and pixel_length are correct
    @test result.physical_length == physical_length
    @test result.pixel_length == physical_length / pixel_size
    
    # Expected bar size in pixels given the physical length and pixel size
    expected_bar_size = physical_length / pixel_size
    
    # Convert to binary image for testing
    binary_img_with_bar = copy(img_with_bar)
    binary_img_with_bar[img_with_bar .> 0.5] .= 1
    binary_img_with_bar[img_with_bar .<= 0.5] .= 0
    binary_img_with_bar = convert(Array{Int}, binary_img_with_bar)
    
    # Get coordinates of scale bar in binary image
    bar_coordinates = get_bar_coordinates(binary_img_with_bar)

    @testset "Size_test" begin
        bar_size = get_bar_size(bar_coordinates)
        @test bar_size == expected_bar_size
    end

    @testset "Orientation_test" begin
        bar_orientation = get_bar_orientation(bar_coordinates)
        @test bar_orientation == :horizontal
    end

    @testset "Position_test" begin
        bar_position = get_bar_position(bar_coordinates, binary_img_with_bar)
        @test bar_position == :bl
    end
    
    @testset "api_overview_test" begin
        # Test that api_overview function exists and returns a non-empty string
        @test isa(ScaleBar.api_overview(), String)
        @test length(ScaleBar.api_overview()) > 0
        
        # Check that the API overview contains key sections
        api_doc = ScaleBar.api_overview()
        @test occursin("ScaleBar.jl API Overview", api_doc)
        @test occursin("Essential Functions", api_doc)
        @test occursin("scalebar!", api_doc)
        @test occursin("scalebar", api_doc)
    end
end

@testset "ScaleBarConfig tests" begin
    # Test ScaleBarConfig creation
    config = ScaleBarConfig()
    @test config.position == :br
    @test config.padding == 20
    @test config.color == :white
    @test isnothing(config.height)
    @test isnothing(config.width)
    
    # Test custom config
    config = ScaleBarConfig(position=:tl, height=10, color=:black, padding=30)
    @test config.position == :tl
    @test config.height == 10
    @test config.color == :black
    @test config.padding == 30
    
    # Test error handling
    @test_throws ArgumentError ScaleBarConfig(position=:invalid)
    @test_throws ArgumentError ScaleBarConfig(color=:red)
    @test_throws ArgumentError ScaleBarConfig(height=-5)
    @test_throws ArgumentError ScaleBarConfig(padding=-10)
end

@testset "ScaleBar with config" begin
    img = Gray.(zeros(512,512))
    pixel_size = 1.0
    
    # Create a config
    config = ScaleBarConfig(position=:tl, color=:white, padding=30)
    
    # Test with physical units
    result = scalebar(img, pixel_size; config=config, physical_length=50, units="μm")
    img_with_bar = result.image
    
    # Convert to binary for testing
    binary_img = convert(Array{Int}, img_with_bar)
    bar_coords = get_bar_coordinates(binary_img)
    bar_position = get_bar_position(bar_coords, binary_img)
    @test bar_position == :tl
    
    # Test with pixel dimensions
    result2 = scalebar(img; config=config, length=50)
    img_with_bar2 = result2.image
    binary_img2 = convert(Array{Int}, img_with_bar2)
    bar_coords2 = get_bar_coordinates(binary_img2)
    bar_position2 = get_bar_position(bar_coords2, binary_img2)
    @test bar_position2 == :tl
    
    # Test in-place with config
    img_copy = copy(img)
    scalebar!(img_copy, pixel_size, 50; config=config, units="μm")
    binary_img3 = convert(Array{Int}, img_copy)
    bar_coords3 = get_bar_coordinates(binary_img3)
    bar_position3 = get_bar_position(bar_coords3, binary_img3)
    @test bar_position3 == :tl
    
    # Test config reuse on multiple images
    img1 = Gray.(zeros(512,512))
    img2 = Gray.(zeros(512,512))
    
    scalebar!(img1, pixel_size, 50; config=config, units="μm")
    scalebar!(img2, pixel_size, 50; config=config, units="μm")
    
    # Both should have scale bars in the same position
    binary1 = convert(Array{Int}, img1)
    binary2 = convert(Array{Int}, img2)
    @test get_bar_position(get_bar_coordinates(binary1), binary1) == :tl
    @test get_bar_position(get_bar_coordinates(binary2), binary2) == :tl
end

@testset "Type dispatch tests" begin
    # Test with color image
    img_color = testimage("lighthouse")
    pixel_size = 0.1
    
    result = scalebar(img_color, pixel_size; physical_length=50, units="μm", color=:white)
    @test eltype(result.image) <: Colorant
    
    # Test with different numeric types
    img_float32 = Float32.(Gray.(testimage("cameraman")))
    
    result_f32 = scalebar(img_float32, pixel_size; physical_length=50, units="μm")
    @test eltype(result_f32.image) == Float32
    
    # Test that scale bar values are appropriate for the type
    img_with_bar = result_f32.image
    # Find scale bar pixels (they should be 1.0f0 for white)
    scale_bar_pixels = img_with_bar[img_with_bar .> 0.9f0]
    @test all(scale_bar_pixels .== 1.0f0)
end