using Test
using Images
using Colors
using ScaleBar

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