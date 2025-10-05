using ScaleBar
using Test

@testset "API and Documentation" begin

    @testset "api_overview function" begin

        @testset "Function exists and is callable" begin
            @test isa(ScaleBar.api_overview, Function)
            @test hasmethod(ScaleBar.api_overview, Tuple{})
        end

        @testset "Returns string" begin
            result = ScaleBar.api_overview()
            @test isa(result, String)
            @test length(result) > 0
        end

        @testset "Contains expected content" begin
            api_doc = ScaleBar.api_overview()

            # Check for key sections
            @test occursin("ScaleBar.jl API Overview", api_doc) ||
                  occursin("API overview", api_doc)

            # Check for function names
            @test occursin("scalebar!", api_doc)
            @test occursin("scalebar", api_doc)
        end

        @testset "Multiple calls return same content" begin
            result1 = ScaleBar.api_overview()
            result2 = ScaleBar.api_overview()

            @test result1 == result2
        end
    end

    @testset "Exported symbols" begin

        @testset "Core functions are exported" begin
            @test :scalebar in names(ScaleBar)
            @test :scalebar! in names(ScaleBar)
        end

        @testset "Internal functions are not exported" begin
            # These should not be in the exported names
            exported_names = names(ScaleBar)

            # Core internal functions should not be exported
            @test :calculate_bar_dimensions ∉ exported_names
            @test :get_bar_coordinates ∉ exported_names
            @test :draw_bar! ∉ exported_names
        end

        @testset "api_overview is not exported" begin
            @test :api_overview ∉ names(ScaleBar)
        end
    end

    @testset "Function signatures" begin

        @testset "scalebar! has correct methods" begin
            # Should have method for physical units (3 args + kwargs)
            @test hasmethod(scalebar!,
                (AbstractArray, Real, Real))

            # Should have method for pixel units (2 args + kwargs)
            @test hasmethod(scalebar!,
                (AbstractArray, Integer))
        end

        @testset "scalebar has correct methods" begin
            # Should have method for physical units (2 args + kwargs)
            @test hasmethod(scalebar,
                (AbstractArray, Real))

            # Should have method for pixel units (1 arg + kwargs)
            @test hasmethod(scalebar,
                (AbstractArray,))
        end
    end

    @testset "Type stability" begin

        @testset "scalebar! returns Nothing" begin
            img = RGB.(fill(0.5, 100, 100))
            result = @inferred scalebar!(img, 50)
            @test result === nothing

            img2 = RGB.(fill(0.5, 100, 100))
            result2 = @inferred scalebar!(img2, 1.0, 50.0)
            @test result2 === nothing
        end

        @testset "scalebar returns NamedTuple" begin
            img = RGB.(fill(0.5, 100, 100))

            # Pixel version
            result1 = scalebar(img; length=50)
            @test result1 isa NamedTuple

            # Physical version
            result2 = scalebar(img, 1.0; physical_length=50.0)
            @test result2 isa NamedTuple
        end
    end

    @testset "Dispatch correctness" begin

        @testset "Colorant vs Real dispatch" begin
            # RGB image should use Colorant method
            img_rgb = RGB.(fill(0.5, 100, 100))
            @test_nowarn scalebar!(img_rgb, 50)

            # Float array should use Real method
            img_float = fill(0.5, 100, 100)
            @test_nowarn scalebar!(img_float, 50)

            # Gray should use Colorant method
            img_gray = Gray.(fill(0.5, 100, 100))
            @test_nowarn scalebar!(img_gray, 50)
        end

        @testset "Physical vs Pixel method selection" begin
            img = RGB.(fill(0.5, 100, 100))

            # Physical: 3 positional args
            @test_nowarn scalebar!(img, 1.0, 50.0)

            # Pixel: 2 positional args
            @test_nowarn scalebar!(img, 50)

            # Physical (non-mutating): 2 positional args
            @test_nowarn scalebar(img, 1.0)

            # Pixel (non-mutating): 1 positional arg + kwarg
            @test_nowarn scalebar(img; length=50)
        end
    end

    @testset "Package metadata" begin

        @testset "Module exports" begin
            # Check the module has expected exports
            exports = names(ScaleBar)

            @test length(exports) >= 2  # At least scalebar and scalebar!
            @test :scalebar in exports
            @test :scalebar! in exports
        end
    end
end
