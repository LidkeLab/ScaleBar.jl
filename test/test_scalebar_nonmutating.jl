using ScaleBar
using Test
using Images
using Colors

@testset "scalebar (non-mutating functions)" begin

    @testset "scalebar with physical units" begin

        @testset "Basic non-mutating with explicit length" begin
            img = RGB.(fill(0.5, 512, 512))
            original_img = copy(img)

            result = scalebar(img, 1.0; physical_length=100.0, position=:br, units="μm")

            # Original image should be unchanged
            @test img == original_img

            # Result should be a named tuple
            @test result isa NamedTuple
            @test haskey(result, :image)
            @test haskey(result, :physical_length)
            @test haskey(result, :pixel_length)
            @test haskey(result, :units)

            # Check values
            @test result.physical_length == 100.0
            @test result.pixel_length == 100  # 100 / 1.0
            @test result.units == "μm"

            # Result image should have the bar
            @test any(result.image .== RGB(1.0, 1.0, 1.0))
        end

        @testset "Auto-calculated physical length" begin
            img = RGB.(fill(0.5, 512, 512))
            pixel_size = 0.1  # 0.1 μm per pixel

            result = scalebar(img, pixel_size; position=:br, units="μm")

            # Should auto-calculate length (10% of image width in physical units)
            # 10% of 512 pixels = 51.2 pixels → 51 pixels
            # Physical units: round to nice value
            img_width_physical = 512 * pixel_size  # 51.2 μm
            expected_approx = 0.1 * img_width_physical  # 5.12 μm, rounds to 5.0

            @test result.physical_length ≈ 5.0
            @test result.pixel_length == round(Int, result.physical_length / pixel_size)
            @test result.units == "μm"

            # Original unchanged
            @test img == RGB.(fill(0.5, 512, 512))
        end

        @testset "Different pixel sizes" begin
            img = RGB.(fill(0.5, 512, 512))

            for pixel_size in [0.01, 0.1, 1.0, 10.0]
                result = scalebar(img, pixel_size; physical_length=50.0, units="nm")

                @test result.physical_length == 50.0
                @test result.pixel_length == round(Int, 50.0 / pixel_size)
                @test result.units == "nm"
            end
        end

        @testset "All positions" begin
            img = RGB.(fill(0.5, 512, 512))
            positions = [:br, :bl, :tr, :tl]

            for pos in positions
                result = scalebar(img, 1.0; physical_length=50.0, position=pos)

                @test any(result.image .== RGB(1.0, 1.0, 1.0))
                @test img == RGB.(fill(0.5, 512, 512))  # Original unchanged
            end
        end

        @testset "Black and white bars" begin
            img = RGB.(fill(0.5, 512, 512))

            # White bar
            result_white = scalebar(img, 1.0; physical_length=50.0, color=:white)
            @test any(result_white.image .== RGB(1.0, 1.0, 1.0))

            # Black bar
            result_black = scalebar(img, 1.0; physical_length=50.0, color=:black)
            @test any(result_black.image .== RGB(0.0, 0.0, 0.0))
        end

        @testset "Different image types" begin
            # Gray
            img_gray = Gray.(fill(0.5, 256, 256))
            result = scalebar(img_gray, 1.0; physical_length=50.0)
            @test any(gray.(result.image) .≈ 1.0)
            @test img_gray == Gray.(fill(0.5, 256, 256))

            # Float64
            img_float = fill(0.5, 256, 256)
            result = scalebar(img_float, 1.0; physical_length=50.0)
            @test any(result.image .== 1.0)
            @test img_float == fill(0.5, 256, 256)
        end

        @testset "Destructuring syntax" begin
            img = RGB.(fill(0.5, 512, 512))

            (; image, physical_length, pixel_length, units) =
                scalebar(img, 1.0; physical_length=100.0, units="μm")

            @test physical_length == 100.0
            @test pixel_length == 100
            @test units == "μm"
            @test any(image .== RGB(1.0, 1.0, 1.0))
        end

        @testset "Custom width" begin
            img = RGB.(fill(0.5, 512, 512))
            result = scalebar(img, 1.0; physical_length=100.0, width=30)

            @test result.pixel_length == 100
            # Verify bar exists with custom width
            @test any(result.image .== RGB(1.0, 1.0, 1.0))
        end

        @testset "Empty units string" begin
            img = RGB.(fill(0.5, 512, 512))
            result = scalebar(img, 1.0; physical_length=50.0)

            @test result.units == ""
        end
    end

    @testset "scalebar with pixel units" begin

        @testset "Basic non-mutating with explicit length" begin
            img = RGB.(fill(0.5, 512, 512))
            original_img = copy(img)

            result = scalebar(img; length=100, position=:br)

            # Original image should be unchanged
            @test img == original_img

            # Result should be a named tuple
            @test result isa NamedTuple
            @test haskey(result, :image)
            @test haskey(result, :pixel_length)

            # Check values
            @test result.pixel_length == 100

            # Result image should have the bar
            @test any(result.image .== RGB(1.0, 1.0, 1.0))
        end

        @testset "Auto-calculated pixel length" begin
            img = RGB.(fill(0.5, 512, 512))

            result = scalebar(img; position=:br)

            # Should auto-calculate length (10% of image width, rounded to nearest 5)
            # 10% of 512 = 51.2, rounded to 50
            @test result.pixel_length == 50

            # Original unchanged
            @test img == RGB.(fill(0.5, 512, 512))
        end

        @testset "Different image sizes" begin
            sizes = [(256, 256), (512, 512), (1024, 1024), (100, 100)]

            for (h, w) in sizes
                img = RGB.(fill(0.5, h, w))
                result = scalebar(img; position=:br)

                # Auto length should be 10% of width, rounded to nearest 5
                expected = round(Int, 0.1 * w)
                expected = 5 * round(Int, expected / 5)

                @test result.pixel_length == expected
            end
        end

        @testset "Different bar lengths" begin
            img = RGB.(fill(0.5, 512, 512))

            for length in [10, 25, 50, 100, 200]
                result = scalebar(img; length=length)

                @test result.pixel_length == length
                @test any(result.image .== RGB(1.0, 1.0, 1.0))
            end
        end

        @testset "All positions" begin
            img = RGB.(fill(0.5, 512, 512))
            positions = [:br, :bl, :tr, :tl]

            for pos in positions
                result = scalebar(img; length=50, position=pos)

                @test any(result.image .== RGB(1.0, 1.0, 1.0))
                @test img == RGB.(fill(0.5, 512, 512))  # Original unchanged
            end
        end

        @testset "Black and white bars" begin
            img = RGB.(fill(0.5, 512, 512))

            # White bar
            result_white = scalebar(img; length=50, color=:white)
            @test any(result_white.image .== RGB(1.0, 1.0, 1.0))

            # Black bar
            result_black = scalebar(img; length=50, color=:black)
            @test any(result_black.image .== RGB(0.0, 0.0, 0.0))
        end

        @testset "Different image types" begin
            # RGB
            img_rgb = RGB.(fill(0.5, 256, 256))
            result = scalebar(img_rgb; length=50)
            @test any(result.image .== RGB(1.0, 1.0, 1.0))

            # Gray
            img_gray = Gray.(fill(0.5, 256, 256))
            result = scalebar(img_gray; length=50)
            @test any(gray.(result.image) .≈ 1.0)

            # Float64
            img_float = fill(0.5, 256, 256)
            result = scalebar(img_float; length=50)
            @test any(result.image .== 1.0)

            # Float32
            img_float32 = fill(Float32(0.5), 256, 256)
            result = scalebar(img_float32; length=50)
            @test any(result.image .== Float32(1.0))
        end

        @testset "Destructuring syntax" begin
            img = RGB.(fill(0.5, 512, 512))

            (; image, pixel_length) = scalebar(img; length=100)

            @test pixel_length == 100
            @test any(image .== RGB(1.0, 1.0, 1.0))
        end

        @testset "Custom width and padding" begin
            img = RGB.(fill(0.5, 512, 512))
            result = scalebar(img; length=100, width=25, padding=20)

            @test result.pixel_length == 100
            @test any(result.image .== RGB(1.0, 1.0, 1.0))
        end
    end

    @testset "Original image preservation" begin

        @testset "Deepcopy ensures independence" begin
            img = RGB.(fill(0.5, 512, 512))
            result = scalebar(img; length=50)

            # Modify original
            img[1, 1] = RGB(1.0, 0.0, 0.0)

            # Result should not be affected
            @test result.image[1, 1] != RGB(1.0, 0.0, 0.0)
            @test result.image[1, 1] == RGB(0.5, 0.5, 0.5)
        end

        @testset "Multiple calls don't interfere" begin
            img = RGB.(fill(0.5, 512, 512))

            result1 = scalebar(img; length=50, position=:br)
            result2 = scalebar(img; length=100, position=:tl)

            # Both results should be different from each other
            @test result1.image != result2.image
            @test result1.pixel_length != result2.pixel_length

            # Original still unchanged
            @test img == RGB.(fill(0.5, 512, 512))
        end
    end

    @testset "Return value correctness" begin

        @testset "Physical units return values" begin
            img = RGB.(fill(0.5, 512, 512))
            result = scalebar(img, 0.1; physical_length=10.0, units="μm")

            @test result.physical_length == 10.0
            @test result.pixel_length == 100  # 10.0 / 0.1
            @test result.units == "μm"
            @test result.image isa AbstractArray
            @test size(result.image) == (512, 512)
        end

        @testset "Pixel units return values" begin
            img = RGB.(fill(0.5, 512, 512))
            result = scalebar(img; length=75)

            @test result.pixel_length == 75
            @test result.image isa AbstractArray
            @test size(result.image) == (512, 512)
            @test !haskey(result, :physical_length)
            @test !haskey(result, :units)
        end

        @testset "Auto-calculated values are sensible" begin
            img = RGB.(fill(0.5, 512, 512))
            result = scalebar(img, 0.1; units="μm")

            # Auto-calculated should be reasonable
            @test result.physical_length > 0
            @test result.pixel_length > 0
            @test result.pixel_length < 512
            @test result.units == "μm"
        end
    end
end
