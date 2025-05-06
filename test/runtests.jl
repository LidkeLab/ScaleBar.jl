using ScaleBar
using Test
using Images
using TestImages
using FileIO

include("test_helpers.jl")

@testset "ScaleBar.jl" begin
    # Create output directory for test images
    output_dir = joinpath(@__DIR__, "output")
    if !isdir(output_dir)
        mkdir(output_dir)
    end
    
    @testset "Core functionality" begin
        # Test basic image creation
        @test isa(create_test_image(100, 100), Matrix{RGB{Float64}})
        @test isa(create_gradient_image(100, 100), Matrix{RGB{Float64}})
        
        # Test basic scale bar functionality (using the out-of-place version)
        img = create_test_image(200, 300)
        img_with_bar = scalebar(img, length=50, width=10, position=:br, color=:black)
        
        # Test that pixels were changed where the scale bar should be
        rows = 180:190  # Approximate rows where scale bar should be
        cols = 240:290  # Approximate columns where scale bar should be
        
        # Check if any pixels in that region are different from the original
        pixels_changed = false
        for i in rows, j in cols
            if img_with_bar[i, j] != img[i, j]
                pixels_changed = true
                break
            end
        end
        @test pixels_changed
        
        # Test verification function
        success, message = verify_scalebar_placement(img_with_bar, :br, 50, 10, 10)
        @test success
        
        # Save the test image for visual inspection
        save_test_image(img_with_bar, "basic_scalebar")
    end
    
    @testset "Position variants" begin
        img = create_test_image(200, 300)
        
        # Test all positions
        positions = [:br, :bl, :tr, :tl]
        
        for pos in positions
            # Create scale bar with the specified position
            img_with_bar = scalebar(img, position=pos, length=50, width=10)
            
            # Verify correct placement
            success, message = verify_scalebar_placement(img_with_bar, pos, 50, 10, 10)
            @test success
            
            # Save for visual inspection
            save_test_image(img_with_bar, "position_$(pos)")
        end
    end
    
    @testset "Physical scale bars" begin
        img = create_test_image(200, 300)
        
        # Test 10μm scale bar (pixel size 0.1μm)
        pixel_size = 0.1
        physical_length = 10.0
        img_with_bar = scalebar(img, pixel_size, physical_length=physical_length, units="μm")
        
        # Scale bar should be 100 pixels (10μm / 0.1μm per pixel)
        expected_length = Int(physical_length / pixel_size)
        
        # Verify correct placement and size
        success, message = verify_scalebar_placement(img_with_bar, :br, expected_length, 
                                                   Int(expected_length * 0.2), 10)
        @test success
        
        # Save for visual inspection
        save_test_image(img_with_bar, "physical_scalebar")
    end
    
    @testset "Auto-sizing" begin
        img = create_test_image(200, 300)
        
        # Test auto-sizing (should be ~10% of image width = 30px)
        img_with_bar = scalebar(img)
        
        # Expected length is 10% of width, rounded to nearest 5
        expected_length = 5 * round(Int, 0.1 * 300 / 5)
        expected_width = max(3, round(Int, 0.2 * expected_length))
        expected_width = expected_width % 2 == 0 ? expected_width + 1 : expected_width
        
        # Verify correct placement and size
        success, message = verify_scalebar_placement(img_with_bar, :br, expected_length, expected_width, 10)
        @test success
        
        # Save for visual inspection
        save_test_image(img_with_bar, "auto_sized_scalebar")
    end
    
    @testset "Color options" begin
        img = create_test_image(200, 300, background=0.8)
        
        # Test white scale bar
        img_white = scalebar(img, color=:white)
        save_test_image(img_white, "white_scalebar")
        
        # Test black scale bar
        img_black = scalebar(img, color=:black)
        save_test_image(img_black, "black_scalebar")
        
        # Verify they're different
        @test img_white != img_black
    end
    
    @testset "Edge cases" begin
        # Test very small image
        small_img = create_test_image(20, 30)
        small_img_with_bar = scalebar(small_img, length=10, width=2)
        save_test_image(small_img_with_bar, "small_image")
        
        # Verify placement
        success, message = verify_scalebar_placement(small_img_with_bar, :br, 10, 2, 10)
        @test success
        
        # Test unusual aspect ratio
        wide_img = create_test_image(50, 400)
        wide_img_with_bar = scalebar(wide_img)
        save_test_image(wide_img_with_bar, "wide_image")
        
        # Skip real-world example test for now to avoid network issues
        # if haskey(TestImages.remotefiles, "mandrill")
        #     mandrill = testimage("mandrill")
        #     mandrill_with_bar = scalebar(mandrill, position=:tr, color=:white)
        #     save_test_image(mandrill_with_bar, "mandrill")
        # end
    end
    
    @testset "In-place vs out-of-place" begin
        img_original = create_test_image(200, 300)
        
        # Make copies for testing
        img_inplace = copy(img_original)
        img_outofplace = copy(img_original)
        
        # Apply in-place and out-of-place
        scalebar!(img_inplace, length=50, color=:black)
        img_result = scalebar(img_outofplace, length=50, color=:black)
        
        # Get coordinates for where the scale bar should be 
        # (bottom right corner for a 50x11 pixel scale bar with 10px padding)
        rows = 180:190  # Approximate rows where scale bar should be
        cols = 240:290  # Approximate columns where scale bar should be
        
        # Check if any pixels in that region are different from the original 
        # (indicating the scale bar was added)
        pixels_changed = false
        for i in rows, j in cols
            if img_inplace[i, j] != img_original[i, j]
                pixels_changed = true
                break
            end
        end
        @test pixels_changed
        
        # The out-of-place version should leave the original unchanged
        @test img_outofplace == img_original
        
        # The results of both methods should have scales bars in the same place
        # (we can't do exact equality due to floating point issues)
        bars_match = true
        for i in 1:size(img_inplace, 1), j in 1:size(img_inplace, 2)
            if img_inplace[i, j] != img_result[i, j]
                bars_match = false
                break
            end
        end
        @test bars_match
    end
    
    @testset "Legacy tests" begin
        # Test scenario similar to the original tests
        img = Gray.(zeros(512, 512))
        len = 100  # length of the scalebar in units
        width = 20  # width of the scalebar in units
        pxsize = 1.0  # size of a pixel in units
        
        # Create scale bar
        img_with_bar = scalebar(img, pxsize, physical_length=len, width=width, position=:bl)
        
        # Convert to binary for analysis
        binary_img_with_bar = copy(img_with_bar)
        binary_img_with_bar = Gray.(binary_img_with_bar .> 0.5)
        binary_img_with_bar = Int.(binary_img_with_bar)
        
        # Get bar coordinates
        bar_coordinates = get_bar_coordinates(binary_img_with_bar)
        
        # Test bar size
        bar_size = get_bar_size(bar_coordinates)
        @test bar_size == len/pxsize
        
        # Test bar orientation
        bar_orientation = get_bar_orientation(bar_coordinates)
        @test bar_orientation == :horizontal
        
        # Test bar position
        bar_position = get_bar_position(bar_coordinates, binary_img_with_bar)
        @test bar_position == :bl
    end
end