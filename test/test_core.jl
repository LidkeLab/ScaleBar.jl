using ScaleBar
using Test
using Images
using Colors

@testset "Core Functions" begin

    @testset "calculate_bar_dimensions" begin
        # Test with explicit dimensions
        img = zeros(RGB{Float64}, 512, 512)

        @testset "Explicit length and width" begin
            length_px, width_px = ScaleBar.calculate_bar_dimensions(img, 100, 20)
            @test length_px == 100
            @test width_px == 20
        end

        @testset "Auto-calculated length" begin
            length_px, width_px = ScaleBar.calculate_bar_dimensions(img, nothing, 20)
            # 10% of 512 = 51.2, rounded to nearest 5 = 50
            @test length_px == 50
            @test width_px == 20
        end

        @testset "Auto-calculated width" begin
            length_px, width_px = ScaleBar.calculate_bar_dimensions(img, 100, nothing)
            @test length_px == 100
            # 20% of 100 = 20, ensure odd
            @test width_px == 21  # 20 + 1 to make odd
        end

        @testset "Both auto-calculated" begin
            length_px, width_px = ScaleBar.calculate_bar_dimensions(img, nothing, nothing)
            @test length_px == 50  # 10% of 512, rounded to nearest 5
            @test width_px == 11   # 20% of 50 = 10, made odd = 11
        end

        @testset "Width is always odd when auto-calculated" begin
            for len in [10, 15, 20, 25, 50, 100]
                _, width_px = ScaleBar.calculate_bar_dimensions(img, len, nothing)
                @test isodd(width_px)
            end
        end

        @testset "Width minimum is 3" begin
            _, width_px = ScaleBar.calculate_bar_dimensions(img, 10, nothing)
            # 20% of 10 = 2, but minimum is 3
            @test width_px >= 3
        end

        @testset "Different image sizes" begin
            # Small image
            small_img = zeros(RGB{Float64}, 100, 100)
            length_px, _ = ScaleBar.calculate_bar_dimensions(small_img, nothing, nothing)
            @test length_px == 10  # 10% of 100 = 10, rounded to 10

            # Large image
            large_img = zeros(RGB{Float64}, 1024, 1024)
            length_px, _ = ScaleBar.calculate_bar_dimensions(large_img, nothing, nothing)
            @test length_px == 100  # 10% of 1024 ≈ 102, rounded to 100
        end
    end

    @testset "get_bar_coordinates" begin
        img = zeros(RGB{Float64}, 512, 512)

        @testset "Position :br (bottom-right)" begin
            coords = ScaleBar.get_bar_coordinates(img, :br, 100, 20, 10)
            row_start, row_end, col_start, col_end = coords

            # Bottom right position
            @test row_start == 512 - 10 - 20 + 1  # 483
            @test row_end == 512 - 10              # 502
            @test col_start == 512 - 10 - 100 + 1 # 403
            @test col_end == 512 - 10              # 502
        end

        @testset "Position :bl (bottom-left)" begin
            coords = ScaleBar.get_bar_coordinates(img, :bl, 100, 20, 10)
            row_start, row_end, col_start, col_end = coords

            @test row_start == 512 - 10 - 20 + 1  # 483
            @test row_end == 512 - 10              # 502
            @test col_start == 10                  # 10
            @test col_end == 10 + 100 - 1          # 109
        end

        @testset "Position :tr (top-right)" begin
            coords = ScaleBar.get_bar_coordinates(img, :tr, 100, 20, 10)
            row_start, row_end, col_start, col_end = coords

            @test row_start == 10                  # 10
            @test row_end == 10 + 20 - 1           # 29
            @test col_start == 512 - 10 - 100 + 1 # 403
            @test col_end == 512 - 10              # 502
        end

        @testset "Position :tl (top-left)" begin
            coords = ScaleBar.get_bar_coordinates(img, :tl, 100, 20, 10)
            row_start, row_end, col_start, col_end = coords

            @test row_start == 10          # 10
            @test row_end == 10 + 20 - 1   # 29
            @test col_start == 10          # 10
            @test col_end == 10 + 100 - 1  # 109
        end

        @testset "Different padding values" begin
            for padding in [0, 5, 20, 50]
                coords = ScaleBar.get_bar_coordinates(img, :br, 100, 20, padding)
                row_start, row_end, col_start, col_end = coords

                @test row_start == 512 - padding - 20 + 1
                @test row_end == 512 - padding
                @test col_start == 512 - padding - 100 + 1
                @test col_end == 512 - padding
            end
        end

        @testset "Coordinates are within bounds" begin
            coords = ScaleBar.get_bar_coordinates(img, :br, 100, 20, 10)
            row_start, row_end, col_start, col_end = coords

            @test row_start >= 1
            @test row_end <= 512
            @test col_start >= 1
            @test col_end <= 512
            @test row_start <= row_end
            @test col_start <= col_end
        end

        @testset "Invalid position throws error" begin
            @test_throws ArgumentError ScaleBar.get_bar_coordinates(img, :invalid, 100, 20, 10)
            @test_throws ArgumentError ScaleBar.get_bar_coordinates(img, :top, 100, 20, 10)
        end

        @testset "Invalid dimensions throw errors" begin
            @test_throws ArgumentError ScaleBar.get_bar_coordinates(img, :br, 0, 20, 10)
            @test_throws ArgumentError ScaleBar.get_bar_coordinates(img, :br, -10, 20, 10)
            @test_throws ArgumentError ScaleBar.get_bar_coordinates(img, :br, 100, 0, 10)
            @test_throws ArgumentError ScaleBar.get_bar_coordinates(img, :br, 100, -5, 10)
        end

        @testset "Negative padding throws error" begin
            @test_throws ArgumentError ScaleBar.get_bar_coordinates(img, :br, 100, 20, -1)
        end

        @testset "Oversized bar triggers warning" begin
            # Bar larger than image should warn
            @test_logs (:warn,) ScaleBar.get_bar_coordinates(img, :br, 600, 20, 10)
            @test_logs (:warn,) ScaleBar.get_bar_coordinates(img, :br, 100, 600, 10)
        end
    end

    @testset "draw_bar! for Colorant arrays" begin

        @testset "RGB image with white bar" begin
            img = RGB.(fill(0.5, 512, 512))
            coords = (10, 29, 10, 109)  # 20×100 bar

            ScaleBar.draw_bar!(img, coords, :white)

            # Check that bar area is white
            for i in 10:29, j in 10:109
                @test img[i, j] == RGB(1.0, 1.0, 1.0)
            end

            # Check that outside bar area is unchanged
            @test img[1, 1] == RGB(0.5, 0.5, 0.5)
            @test img[512, 512] == RGB(0.5, 0.5, 0.5)
        end

        @testset "RGB image with black bar" begin
            img = RGB.(fill(0.5, 512, 512))
            coords = (10, 29, 10, 109)

            ScaleBar.draw_bar!(img, coords, :black)

            # Check that bar area is black
            for i in 10:29, j in 10:109
                @test img[i, j] == RGB(0.0, 0.0, 0.0)
            end
        end

        @testset "Gray image with white bar" begin
            img = Gray.(fill(0.5, 512, 512))
            coords = (10, 29, 10, 109)

            ScaleBar.draw_bar!(img, coords, :white)

            # Check that bar area is white
            for i in 10:29, j in 10:109
                @test gray(img[i, j]) ≈ 1.0
            end
        end

        @testset "Invalid color throws error" begin
            img = RGB.(fill(0.5, 512, 512))
            coords = (10, 29, 10, 109)

            @test_throws ArgumentError ScaleBar.draw_bar!(img, coords, :red)
            @test_throws ArgumentError ScaleBar.draw_bar!(img, coords, :green)
        end
    end

    @testset "draw_bar! for Real arrays" begin

        @testset "Float64 array [0,1] with white bar" begin
            img = fill(0.5, 512, 512)
            coords = (10, 29, 10, 109)

            ScaleBar.draw_bar!(img, coords, :white)

            # Check that bar area is 1.0 (white)
            for i in 10:29, j in 10:109
                @test img[i, j] == 1.0
            end
        end

        @testset "Float64 array [0,1] with black bar" begin
            img = fill(0.5, 512, 512)
            coords = (10, 29, 10, 109)

            ScaleBar.draw_bar!(img, coords, :black)

            # Check that bar area is 0.0 (black)
            for i in 10:29, j in 10:109
                @test img[i, j] == 0.0
            end
        end

        @testset "Float32 array with white bar" begin
            img = fill(Float32(0.5), 512, 512)
            coords = (10, 29, 10, 109)

            ScaleBar.draw_bar!(img, coords, :white)

            # Check that bar area is 1.0
            for i in 10:29, j in 10:109
                @test img[i, j] == Float32(1.0)
            end
        end

        @testset "Array with values > 1.0, white uses max" begin
            img = fill(100.0, 512, 512)
            coords = (10, 29, 10, 109)

            ScaleBar.draw_bar!(img, coords, :white)

            # Check that bar area uses max value
            for i in 10:29, j in 10:109
                @test img[i, j] == 100.0
            end
        end

        @testset "Array with values > 1.0, black is 0" begin
            img = fill(100.0, 512, 512)
            coords = (10, 29, 10, 109)

            ScaleBar.draw_bar!(img, coords, :black)

            # Check that bar area is 0.0
            for i in 10:29, j in 10:109
                @test img[i, j] == 0.0
            end
        end

        @testset "UInt8 array (image data)" begin
            img = fill(UInt8(128), 512, 512)
            coords = (10, 29, 10, 109)

            # White should use max value (255)
            ScaleBar.draw_bar!(img, coords, :white)
            for i in 10:29, j in 10:109
                @test img[i, j] == UInt8(128)  # Uses max value in array, not max possible
            end

            # Black should be 0
            img2 = fill(UInt8(128), 512, 512)
            ScaleBar.draw_bar!(img2, coords, :black)
            for i in 10:29, j in 10:109
                @test img2[i, j] == UInt8(0)
            end
        end

        @testset "Invalid color throws error" begin
            img = fill(0.5, 512, 512)
            coords = (10, 29, 10, 109)

            @test_throws ArgumentError ScaleBar.draw_bar!(img, coords, :red)
            @test_throws ArgumentError ScaleBar.draw_bar!(img, coords, :blue)
        end
    end
end
