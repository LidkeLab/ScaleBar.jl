using ScaleBar
using Test

function get_bar_coordinates(image::Matrix{Int})
    pos_x = Int[]
    pos_y = Int[]
    for i in 1:size(image, 1)
        for j in 1:size(image, 2)
            if image[i, j] == 1
                push!(pos_x, i)
                push!(pos_y, j)
            end
        end
    end
    pos = [pos_x pos_y]  # Create a 2-column matrix directly
    return pos
end

@testset "ScaleBar.jl" begin
    # Write your tests here.

    # Test scenario
    example_image = zeros(Int, 200, 100)  # Ensure the matrix is of integer type
    example_image[3:12, 6:15] .= 1  # Create a bar of 1s
    bar_coordinates = get_bar_coordinates(example_image)

    println(bar_coordinates)  # This should print the coordinates of the bar

    size = maximum([maximum(bar_coordinates[:, 1]) - minimum(bar_coordinates[:, 1]), maximum(bar_coordinates[:, 2]) - minimum(bar_coordinates[:, 2])])
    @test size == bar_size

    # Position

end