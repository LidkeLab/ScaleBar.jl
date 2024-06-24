using ScaleBar
using Test
using HDF5

@testset "ScaleBar.jl" begin
    # Write your tests here.

    example image = zeros(200, 100)
    bar_size = [10, 20]
    output_test_image = scalebar(bar_size, "horizontal", "tl", "mm")
    @testset "Test scalebar" begin
        @test output_test_image == example image
    end

   
end
