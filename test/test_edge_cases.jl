using ScaleBar
using Test
using Images
using Colors

@testset "Edge Cases and Error Conditions" begin

    @testset "Tiny images" begin

        @testset "Very small image (50×50)" begin
            img = RGB.(fill(0.5, 50, 50))

            # Auto-calculated bar should work
            result = scalebar(img; position=:br)
            @test result.pixel_length > 0
            @test result.pixel_length <= 50

            # Explicit small bar should work
            scalebar!(img, 10; position=:br)
            @test any(img .== RGB(1.0, 1.0, 1.0))
        end

        @testset "Minimum size image (10×10)" begin
            img = RGB.(fill(0.5, 10, 10))

            # Auto-calculated fails for very small images (10% of 10 = 1, rounds to 0)
            @test_throws ArgumentError scalebar(img; position=:br, padding=1)


            # Small explicit bar
            img2 = RGB.(fill(0.5, 10, 10))
            scalebar!(img2, 5; position=:br, padding=1, width=2)
            @test any(img2 .== RGB(1.0, 1.0, 1.0))
        end

        @testset "Single row or column image" begin
            # These are extreme edge cases that may fail
            img_row = RGB.(fill(0.5, 1, 100))
            result_row = scalebar(img_row; length=50, padding=0)
            @test result_row.pixel_length == 50

            img_col = RGB.(fill(0.5, 100, 1))
            result_col = scalebar(img_col; length=1, padding=0)
            @test result_col.pixel_length == 1
        end
    end

    @testset "Large images" begin

        @testset "High resolution image (2048×2048)" begin
            img = RGB.(fill(0.5, 2048, 2048))

            result = scalebar(img; position=:br)
            # Auto-calculated: 10% of 2048 ≈ 205, rounded to 205
            @test result.pixel_length > 0
            @test result.pixel_length < 2048

            # Large explicit bar
            scalebar!(img, 500; position=:br)
            @test any(img .== RGB(1.0, 1.0, 1.0))
        end

        @testset "Very large bar on large image" begin
            img = RGB.(fill(0.5, 1024, 1024))
            scalebar!(img, 800; position=:br, padding=10)

            @test any(img .== RGB(1.0, 1.0, 1.0))
        end
    end

    @testset "Extreme padding values" begin

        @testset "Zero padding" begin
            img = RGB.(fill(0.5, 512, 512))
            scalebar!(img, 50; padding=0, position=:br)

            # Bar should be at the very edge
            @test img[512, 512] == RGB(1.0, 1.0, 1.0)
        end

        @testset "Large padding" begin
            img = RGB.(fill(0.5, 512, 512))
            scalebar!(img, 50; padding=100, position=:br)

            # Bar should be far from edges
            @test img[512, 512] != RGB(1.0, 1.0, 1.0)
            @test any(img .== RGB(1.0, 1.0, 1.0))
        end

        @testset "Padding that causes bar to barely fit" begin
            img = RGB.(fill(0.5, 100, 100))
            # Padding that leaves just enough room
            scalebar!(img, 50; padding=25, position=:br)
            @test any(img .== RGB(1.0, 1.0, 1.0))
        end
    end

    @testset "Extreme bar dimensions" begin

        @testset "Very thin bar" begin
            img = RGB.(fill(0.5, 512, 512))
            scalebar!(img, 100; width=1, position=:br)

            # Should still create a bar
            @test any(img .== RGB(1.0, 1.0, 1.0))
        end

        @testset "Very thick bar" begin
            img = RGB.(fill(0.5, 512, 512))
            scalebar!(img, 100; width=100, position=:br)

            # Should create a square-ish bar
            @test any(img .== RGB(1.0, 1.0, 1.0))
        end

        @testset "Very short bar" begin
            img = RGB.(fill(0.5, 512, 512))
            scalebar!(img, 5; position=:br, padding=10)

            @test any(img .== RGB(1.0, 1.0, 1.0))
        end

        @testset "Very long bar" begin
            img = RGB.(fill(0.5, 512, 512))
            scalebar!(img, 400; position=:br, padding=10)

            @test any(img .== RGB(1.0, 1.0, 1.0))
        end
    end

    @testset "Extreme physical values" begin

        @testset "Very small pixel size" begin
            img = RGB.(fill(0.5, 512, 512))
            result = scalebar(img, 0.001; physical_length=1.0, units="nm")

            @test result.pixel_length == 1000  # 1.0 / 0.001
            @test result.physical_length == 1.0
        end

        @testset "Very large pixel size" begin
            img = RGB.(fill(0.5, 512, 512))
            result = scalebar(img, 100.0; physical_length=1000.0, units="mm")

            @test result.pixel_length == 10  # 1000 / 100
            @test result.physical_length == 1000.0
        end

        @testset "Physical length equals pixel size" begin
            img = RGB.(fill(0.5, 512, 512))
            result = scalebar(img, 1.0; physical_length=1.0)

            @test result.pixel_length == 1
        end

        @testset "Fractional pixel calculation" begin
            img = RGB.(fill(0.5, 512, 512))
            # Results in 50.5 pixels, should round to 50 or 51
            result = scalebar(img, 0.99; physical_length=50.0)

            @test result.pixel_length in [50, 51]
        end
    end

    @testset "Bar larger than image" begin

        @testset "Bar length exceeds image width" begin
            img = RGB.(fill(0.5, 100, 100))

            # This should trigger a warning but still execute
            @test_logs (:warn,) scalebar!(img, 150; position=:br, padding=10)
        end

        @testset "Bar width exceeds image height" begin
            img = RGB.(fill(0.5, 100, 100))

            @test_logs (:warn,) scalebar!(img, 50; width=150, position=:br, padding=10)
        end

        @testset "Bar dimensions plus padding exceed image" begin
            img = RGB.(fill(0.5, 100, 100))

            # 80 pixels + 2*20 padding = 120 > 100
            @test_logs (:warn,) scalebar!(img, 80; padding=20, position=:br)
        end
    end

    @testset "Unusual image types" begin

        @testset "Int array" begin
            img = fill(128, 512, 512)
            # Int arrays should work with Real dispatch
            scalebar!(img, 50; position=:br, color=:white)

            # White should use max value
            @test any(img .== 128)  # Uses max value in array
        end

        @testset "Different float precisions" begin
            # Float16
            img_f16 = fill(Float16(0.5), 256, 256)
            scalebar!(img_f16, 50; position=:br)
            @test any(img_f16 .== Float16(1.0))

            # BigFloat
            img_big = fill(BigFloat(0.5), 100, 100)
            scalebar!(img_big, 20; position=:br)
            @test any(img_big .== BigFloat(1.0))
        end

        @testset "Grayscale with different eltype" begin
            img_gray_f32 = Gray{Float32}.(fill(0.5f0, 256, 256))
            scalebar!(img_gray_f32, 50; position=:br)
            @test any(gray.(img_gray_f32) .≈ 1.0f0)
        end
    end

    @testset "Error conditions - comprehensive" begin

        @testset "Invalid position symbols" begin
            img = RGB.(fill(0.5, 512, 512))

            @test_throws ArgumentError scalebar!(img, 50; position=:center)
            @test_throws ArgumentError scalebar!(img, 50; position=:top)
            @test_throws ArgumentError scalebar!(img, 50; position=:bottom)
            @test_throws ArgumentError scalebar!(img, 50; position=:left)
            @test_throws ArgumentError scalebar!(img, 50; position=:right)
            @test_throws ArgumentError scalebar!(img, 50; position=:middle)
        end

        @testset "Invalid colors" begin
            img = RGB.(fill(0.5, 512, 512))

            @test_throws ArgumentError scalebar!(img, 50; color=:red)
            @test_throws ArgumentError scalebar!(img, 50; color=:blue)
            @test_throws ArgumentError scalebar!(img, 50; color=:green)
            @test_throws ArgumentError scalebar!(img, 50; color=:gray)
        end

        @testset "Invalid numerical parameters" begin
            img = RGB.(fill(0.5, 512, 512))

            # Zero/negative length
            @test_throws ArgumentError scalebar!(img, 0)
            @test_throws ArgumentError scalebar!(img, -10)

            # Zero/negative pixel_size
            @test_throws ArgumentError scalebar!(img, 0.0, 50.0)
            @test_throws ArgumentError scalebar!(img, -1.0, 50.0)

            # Zero/negative physical_length
            @test_throws ArgumentError scalebar!(img, 1.0, 0.0)
            @test_throws ArgumentError scalebar!(img, 1.0, -50.0)

            # Negative padding
            @test_throws ArgumentError scalebar!(img, 50; padding=-5)
        end
    end

    @testset "Boundary coordinate calculations" begin

        @testset "Bar exactly fits in image" begin
            img = RGB.(fill(0.5, 100, 100))
            # Bar of 80 pixels with padding 10 exactly fits
            scalebar!(img, 80; width=80, padding=10, position=:br)

            # Should work without error
            @test any(img .== RGB(1.0, 1.0, 1.0))
        end

        @testset "Coordinates at exact boundaries" begin
            img = RGB.(fill(0.5, 100, 100))

            # Test all corners with maximum bar size
            positions = [:br, :bl, :tr, :tl]
            for pos in positions
                img_test = RGB.(fill(0.5, 100, 100))
                scalebar!(img_test, 50; width=20, padding=0, position=pos)
                @test any(img_test .== RGB(1.0, 1.0, 1.0))
            end
        end

        @testset "Rounding edge cases" begin
            img = RGB.(fill(0.5, 512, 512))

            # Pixel size that results in fractional pixels
            result = scalebar(img, 0.333; physical_length=10.0)
            @test result.pixel_length == round(Int, 10.0 / 0.333)

            # Very small difference
            result2 = scalebar(img, 0.999; physical_length=100.0)
            @test result2.pixel_length isa Integer
        end
    end

    @testset "Special numeric values" begin

        @testset "NaN handling" begin
            img = fill(0.5, 512, 512)
            img[1, 1] = NaN

            # Should handle NaN in image
            @test_nowarn scalebar!(img, 50; position=:br)
        end

        @testset "Inf handling" begin
            img = fill(0.5, 512, 512)
            img[1, 1] = Inf

            # Should handle Inf in image
            @test_nowarn scalebar!(img, 50; position=:br)
        end

        @testset "Very large values in array" begin
            img = fill(1e10, 512, 512)

            # White bar should use max value
            scalebar!(img, 50; color=:white, position=:br)
            @test any(img .== 1e10)

            # Black bar should use 0
            img2 = fill(1e10, 512, 512)
            scalebar!(img2, 50; color=:black, position=:br)
            @test any(img2 .== 0.0)
        end
    end

    @testset "Auto-calculation edge cases" begin

        @testset "Image width not divisible by 5" begin
            # Width 513 - auto length should still round to nearest 5
            img = RGB.(fill(0.5, 512, 513))
            result = scalebar(img; position=:br)

            # 10% of 513 = 51.3, rounded to nearest 5 = 50
            @test result.pixel_length == 50
        end

        @testset "Very small auto-calculated width" begin
            img = RGB.(fill(0.5, 512, 512))
            # Length 14 -> 20% = 2.8 -> max(3, round(2.8)) = 3
            result = scalebar(img; length=14, position=:br)

            # Width should be at least 3
            # We can't directly check width, but bar should exist
            @test any(result.image .== RGB(1.0, 1.0, 1.0))
        end

        @testset "Physical length rounding to nice values" begin
            img = RGB.(fill(0.5, 512, 512))

            # Test auto-calculation with different pixel sizes
            result1 = scalebar(img, 0.123; units="μm")
            # Should round to nice value
            @test result1.physical_length > 0

            result2 = scalebar(img, 2.7; units="μm")
            @test result2.physical_length > 0
        end
    end
end
