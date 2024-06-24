using ScaleBar
using Test
using HDF5

@testset "ScaleBar.jl" begin
    # Write your tests here.

    example_image = zeros(200, 100)
    bar_size = 10
    output_test_image = scalebar(example_image::Array, bar_size::Int, orientation::String = "horizontal", position::"tl")
    @testset "Test scalebar" begin
        @test output_test_image == example image
    end

   
end
