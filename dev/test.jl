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
example_image = zeros(Int, 200, 100)  # Ensure the matrix is of integer type
example_image[3:12, 6:17] .= 1  # Create a bar of 1s
bar_coordinates = get_bar_coordinates(example_image)

println(bar_coordinates)  # This should print the coordinates of the bar

size = maximum([maximum(bar_coordinates[:, 1]) - minimum(bar_coordinates[:, 1]), maximum(bar_coordinates[:, 2]) - minimum(bar_coordinates[:, 2])])

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

position = join([y_pos, x_pos])

# orientation

if size[1] > size[2]
    orientation = "h"
else
    orientation = "v"
end