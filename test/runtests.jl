
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

@testset "test" begin
    # Write your tests here.

    # Test scenario
    example_image1 = zeros(Int, 200, 100)  # Ensure the matrix is of integer type
    example_image1[3:12, 6:17] .= 1  # Create a bar of 1s. Size=10x12
    example_image2 = zeros(Int, 100, 200)  # Ensure the matrix is of integer type
    example_image2[6:17, 3:15] .= 1 # Create a bar of 1s. Size=12x13
    example_image3 = zeros(Int, 100, 200)  # Ensure the matrix is of integer type
    example_image3[20:45, 3:15] .= 1 # Create a bar of 1s. Size=26x13
    bar_coordinates1 = get_bar_coordinates(example_image1)
    bar_coordinates2 = get_bar_coordinates(example_image2)
    bar_coordinates3 = get_bar_coordinates(example_image3)

# Corrected println statements for debugging
println(bar_coordinates1)  # Print the coordinates of the bar in example_image1
println(bar_coordinates2)  # Print the coordinates of the bar in example_image2
println(bar_coordinates3)  # Print the coordinates of the bar in example_image3
    bar_size1 = maximum([maximum(bar_coordinates1[:, 1]) - minimum(bar_coordinates1[:, 1]) + 1, maximum(bar_coordinates1[:, 2]) - minimum(bar_coordinates1[:, 2]) + 1])

    @test bar_size1 == 12

    bar_size2 = maximum([maximum(bar_coordinates2[:, 1]) - minimum(bar_coordinates2[:, 1]) + 1, maximum(bar_coordinates2[:, 2]) - minimum(bar_coordinates2[:, 2]) + 1])

    @test bar_size2 == 13

    bar_size3 = maximum([maximum(bar_coordinates3[:, 1]) - minimum(bar_coordinates3[:, 1]) + 1, maximum(bar_coordinates3[:, 2]) - minimum(bar_coordinates3[:, 2]) + 1])

    @test bar_size3 == 26

    # Position

end