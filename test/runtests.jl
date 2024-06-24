using ScaleBar
using Test

@enter function get_bar_coordinates(image::Array)
    # Write your function here.
    pos_x
    pos_y
    for i in 1:size(output_test_image, 1)
        for j in 1:size(output_test_image, 2)
            if output_test_image[i, j] == 1
                push!(pos_x, i)
                push!(pos_y, j)
            end
        end
    end
    pos = zeros(length(pos_x), length(pos_y))
    pos = [pos_x, pos_y]
    return pos
end

@testset "ScaleBar.jl" begin
    # Write your tests here.

    example_image::Array = zeros(200, 100)
    bar_size = 10
    # output_test_image = scalebar(image::Array = example_image, bar_size::Int, orientation::String = "horizontal", position::String = "tl")
    output_test_image = example_image
    output_test_image[3:10, 6:36] .= 1
    bar_coordinatres = get_bar_coordinates(image::Array = output_test_image)

end