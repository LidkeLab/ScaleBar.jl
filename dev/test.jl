using Revise
includet("../test/test_helpers.jl")

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

# Test scenario
example_image1 = zeros(Int, 200, 100)  # Ensure the matrix is of integer type
example_image1[3:12, 6:17] .= 1  # Create a bar of 1s. Size=10x12
example_image2 = zeros(Int, 100, 200)  # Ensure the matrix is of integer type
example_image2[6:17, 3:15] .= 1 # Create a bar of 1s. Size=12x13
example_image3 = zeros(Int, 100, 200)  # Ensure the matrix is of integer type
example_image3[120:145, 3:15] .= 1 # Create a bar of 1s. Size=26x13
bar_coordinates = get_bar_coordinates(example_image1)

println(bar_coordinates)  # This should print the coordinates of the bar

bar_size1 = maximum([maximum(bar_coordinates[:, 1]) - minimum(bar_coordinates[:, 1]) + 1, maximum(bar_coordinates[:, 2]) - minimum(bar_coordinates[:, 2]) + 1])

@test bar_size1 == 12

bar_size2 = maximum([maximum(bar_coordinates[:, 1]) - minimum(bar_coordinates[:, 1]) + 1, maximum(bar_coordinates[:, 2]) - minimum(bar_coordinates[:, 2]) + 1])

@test bar_size2 == 13

bar_size3 = maximum([maximum(bar_coordinates[:, 1]) - minimum(bar_coordinates[:, 1]) + 1, maximum(bar_coordinates[:, 2]) - minimum(bar_coordinates[:, 2]) + 1])

@test bar_size3 == 26

# position
if minimum(bar_coordinates[:, 1]) < (200 - maximum(bar_coordinates[:, 1]))
    x_pos = "l"
else
    x_pos = "r"
end

if minimum(bar_coordinates[:, 2]) < (100 - maximum(bar_coordinates[:, 2]))
    y_pos = "b"
else
    y_pos = "t"
end

str_position = join([y_pos, x_pos])
sym_position = Symbol(position)

# orientation

if size[1] > size[2]
    orientation = "Horizontal"
else
    orientation = "Vertical"
end

bar_position1 = get_bar_position(bar_coordinates)
        @test bar_position1 == :bl

        bar_position2 = get_bar_position(bar_coordinates2)
        @test bar_position2 == :bl

        bar_position3 = get_bar_position(bar_coordinates3)
        @test bar_position3 == :bl