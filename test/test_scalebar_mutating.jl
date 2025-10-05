using ScaleBar
using Test
using Images
using Colors

@testset "scalebar! (mutating functions)" begin

    @testset "scalebar! with physical units" begin

        @testset "Basic physical scale bar" begin
            img = RGB.(fill(0.5, 512, 512))
            original_img = copy(img)

            # Add 100 unit scale bar with 1.0 unit per pixel
            scalebar!(img, 1.0, 100.0; position=:br, color=:white, padding=10)

            # Check image was modified
            @test img != original_img

            # Check bar is present at expected location
            # Length: 100 units / 1.0 per pixel = 100 pixels
            # Position: bottom-right with padding 10
            bar_region = img[512-10-21+1:512-10, 512-10-100+1:512-10]
            @test all(bar_region .== RGB(1.0, 1.0, 1.0))
        end

        @testset "Different pixel sizes" begin
            for pixel_size in [0.1, 0.5, 1.0, 2.0, 10.0]
                img = RGB.(fill(0.5, 512, 512))
                physical_length = 50.0
                expected_pixels = round(Int, physical_length / pixel_size)

                scalebar!(img, pixel_size, physical_length; position=:br, padding=10)

                # Verify bar exists (at least some white pixels in bottom-right)
                bottom_right = img[end-50:end, end-150:end]
                @test any(bottom_right .== RGB(1.0, 1.0, 1.0))
            end
        end

        @testset "All positions with physical units" begin
            positions = [:br, :bl, :tr, :tl]
            for pos in positions
                img = RGB.(fill(0.5, 512, 512))
                scalebar!(img, 1.0, 50.0; position=pos, color=:white, padding=10)

                # Verify modification occurred
                @test any(img .== RGB(1.0, 1.0, 1.0))
            end
        end

        @testset "Black and white bars" begin
            # White bar on dark background
            img1 = RGB.(fill(0.0, 512, 512))
            scalebar!(img1, 1.0, 50.0; color=:white)
            @test any(img1 .== RGB(1.0, 1.0, 1.0))

            # Black bar on light background
            img2 = RGB.(fill(1.0, 512, 512))
            scalebar!(img2, 1.0, 50.0; color=:black)
            @test any(img2 .== RGB(0.0, 0.0, 0.0))
        end

        @testset "Custom width" begin
            img = RGB.(fill(0.5, 512, 512))
            scalebar!(img, 1.0, 100.0; width=30, position=:br, padding=10)

            # Check bar with custom width exists
            bar_region = img[512-10-30+1:512-10, 512-10-100+1:512-10]
            @test all(bar_region .== RGB(1.0, 1.0, 1.0))
        end

        @testset "Gray image with physical units" begin
            img = Gray.(fill(0.5, 512, 512))
            scalebar!(img, 1.0, 50.0; position=:bl, color=:white)

            # Verify white bar exists
            @test any(gray.(img) .≈ 1.0)
        end

        @testset "Float64 array with physical units" begin
            img = fill(0.5, 512, 512)
            scalebar!(img, 1.0, 50.0; position=:tr, color=:black)

            # Verify black bar exists
            @test any(img .== 0.0)
        end

        @testset "Returns nothing (mutating)" begin
            img = RGB.(fill(0.5, 512, 512))
            result = scalebar!(img, 1.0, 50.0)
            @test result === nothing
        end

        @testset "Error: Invalid pixel_size" begin
            img = RGB.(fill(0.5, 512, 512))
            @test_throws ArgumentError scalebar!(img, 0.0, 50.0)
            @test_throws ArgumentError scalebar!(img, -1.0, 50.0)
        end

        @testset "Error: Invalid physical_length" begin
            img = RGB.(fill(0.5, 512, 512))
            @test_throws ArgumentError scalebar!(img, 1.0, 0.0)
            @test_throws ArgumentError scalebar!(img, 1.0, -50.0)
        end

        @testset "Error: Invalid position" begin
            img = RGB.(fill(0.5, 512, 512))
            @test_throws ArgumentError scalebar!(img, 1.0, 50.0; position=:invalid)
            @test_throws ArgumentError scalebar!(img, 1.0, 50.0; position=:center)
        end
    end

    @testset "scalebar! with pixel units" begin

        @testset "Basic pixel scale bar" begin
            img = RGB.(fill(0.5, 512, 512))
            original_img = copy(img)

            # Add 50-pixel scale bar
            scalebar!(img, 50; position=:br, color=:white, padding=10)

            # Check image was modified
            @test img != original_img

            # Check bar is present at expected location
            bar_region = img[512-10-11+1:512-10, 512-10-50+1:512-10]
            @test all(bar_region .== RGB(1.0, 1.0, 1.0))
        end

        @testset "Different bar lengths" begin
            for length in [10, 25, 50, 100, 200]
                img = RGB.(fill(0.5, 512, 512))
                scalebar!(img, length; position=:br, padding=10)

                # Verify bar exists
                @test any(img .== RGB(1.0, 1.0, 1.0))
            end
        end

        @testset "All positions with pixel units" begin
            positions = [:br, :bl, :tr, :tl]
            for pos in positions
                img = RGB.(fill(0.5, 512, 512))
                scalebar!(img, 50; position=pos, color=:white, padding=10)

                # Verify modification occurred
                @test any(img .== RGB(1.0, 1.0, 1.0))
            end
        end

        @testset "Black and white bars" begin
            # White bar
            img1 = RGB.(fill(0.0, 512, 512))
            scalebar!(img1, 50; color=:white)
            @test any(img1 .== RGB(1.0, 1.0, 1.0))

            # Black bar
            img2 = RGB.(fill(1.0, 512, 512))
            scalebar!(img2, 50; color=:black)
            @test any(img2 .== RGB(0.0, 0.0, 0.0))
        end

        @testset "Custom width" begin
            img = RGB.(fill(0.5, 512, 512))
            scalebar!(img, 100; width=25, position=:br, padding=10)

            # Check bar with custom width exists
            bar_region = img[512-10-25+1:512-10, 512-10-100+1:512-10]
            @test all(bar_region .== RGB(1.0, 1.0, 1.0))
        end

        @testset "Different image types" begin
            # RGB
            img_rgb = RGB.(fill(0.5, 256, 256))
            scalebar!(img_rgb, 50; position=:br)
            @test any(img_rgb .== RGB(1.0, 1.0, 1.0))

            # Gray
            img_gray = Gray.(fill(0.5, 256, 256))
            scalebar!(img_gray, 50; position=:br)
            @test any(gray.(img_gray) .≈ 1.0)

            # Float64
            img_float = fill(0.5, 256, 256)
            scalebar!(img_float, 50; position=:br)
            @test any(img_float .== 1.0)

            # Float32
            img_float32 = fill(Float32(0.5), 256, 256)
            scalebar!(img_float32, 50; position=:br)
            @test any(img_float32 .== Float32(1.0))
        end

        @testset "Returns nothing (mutating)" begin
            img = RGB.(fill(0.5, 512, 512))
            result = scalebar!(img, 50)
            @test result === nothing
        end

        @testset "Error: Invalid length" begin
            img = RGB.(fill(0.5, 512, 512))
            @test_throws ArgumentError scalebar!(img, 0)
            @test_throws ArgumentError scalebar!(img, -10)
        end

        @testset "Error: Invalid position" begin
            img = RGB.(fill(0.5, 512, 512))
            @test_throws ArgumentError scalebar!(img, 50; position=:invalid)
            @test_throws ArgumentError scalebar!(img, 50; position=:middle)
        end
    end

    @testset "Image mutation verification" begin

        @testset "Mutating function modifies original" begin
            img = RGB.(fill(0.5, 512, 512))
            img_ref = img  # Same reference

            scalebar!(img, 50)

            # Both references should show modification
            @test img === img_ref
            @test any(img .== RGB(1.0, 1.0, 1.0))
            @test any(img_ref .== RGB(1.0, 1.0, 1.0))
        end

        @testset "Only bar region is modified" begin
            img = RGB.(fill(0.5, 512, 512))
            scalebar!(img, 50; position=:br, padding=10)

            # Top-left corner should be unchanged
            @test img[1:100, 1:100] == RGB.(fill(0.5, 100, 100))

            # Bottom-right should have the bar
            @test any(img[end-50:end, end-100:end] .== RGB(1.0, 1.0, 1.0))
        end
    end
end
