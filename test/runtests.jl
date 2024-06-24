using ScaleBar
using Test
using HDF5

function get_bar_coordinates
    # Write your function here.
end

@testset "ScaleBar.jl" begin
    # Write your tests here.

    example_image::Array = zeros(200, 100)
    bar_size = 10
    output_test_image = scalebar(image::Array = example_image, bar_size::Int, orientation::String = "horizontal", position::String = "tl")
    bar_coordinatres = get_bar_coordinates(image::Array = example_image, bar_size::Int, orientation::String = "horizontal", position::String = "tl")

    if output_test_image[i, j] = 1

    @test 

end