
"""
    get_bar_coordinates(image::Matrix{Int})

Get the coordinates of the bar in the image.

# Arguments
- `image::Matrix{Int}`: A binary image with a bar of 1s.

# Returns
- `pos::Matrix{Int}`: A 2-column matrix with the x and y coordinates of the bar.
"""
function get_bar_coordinates(image::Matrix{Int})
    pos_x = Int[]
    pos_y = Int[]
    for j in 1:size(image, 2)
        for i in 1:size(image, 1)
            if image[i, j] == 1
                push!(pos_x, j)
                push!(pos_y, i)
            end
        end
    end
    pos = [pos_x pos_y]  # Create a 2-column matrix directly
    return pos
end

"""
    get_bar_size(bar_coordinates::Matrix{Int})

Get the size of the bar in the image.

# Arguments
- `bar_coordinates::Matrix{Int}`: A 2-column matrix with the x and y coordinates of the bar.

# Returns
- `bar_size::Int`: The size of the bar.
"""
function get_bar_size(bar_coordinates::Matrix{Int})
    bar_size_x = maximum(bar_coordinates[:, 1]) - minimum(bar_coordinates[:, 1]) + 1
    bar_size_y = maximum(bar_coordinates[:, 2]) - minimum(bar_coordinates[:, 2]) + 1
    bar_size = maximum([bar_size_x, bar_size_y])
    return bar_size
end

"""
    get_bar_orientation(bar_coordinates::Matrix{Int})

Get the orientation of the bar in the image.

# Arguments
- `bar_coordinates::Matrix{Int}`: A 2-column matrix with the x and y coordinates of the bar.

# Returns
- `bar_orientation::Symbol`: The orientation of the bar.
"""
function get_bar_orientation(bar_coordinates::Matrix{Int})
    if (maximum(bar_coordinates[:, 1]) - minimum(bar_coordinates[:, 1]) + 1) > (maximum(bar_coordinates[:, 2]) - minimum(bar_coordinates[:, 2]) + 1)
        bar_orientation = :horizontal
    else
        bar_orientation = :vertical
    end
    return bar_orientation
end

"""
    get_bar_position(bar_coordinates::Matrix{Int}, image_size::Tuple{Int, Int})

Get the position of the bar in the image.

# Arguments
- `bar_coordinates::Matrix{Int}`: A 2-column matrix with the x and y coordinates of the bar.

# Returns
- `bar_position::Symbol`: The position of the bar.
"""
function get_bar_position(bar_coordinates::Matrix{Int}, image::Array)
    image_size = size(image)
    if minimum(bar_coordinates[:, 1]) < (image_size[1] - maximum(bar_coordinates[:, 1]))
        x_pos = "l"
    else
        x_pos = "r"
    end

    if minimum(bar_coordinates[:, 2]) < (image_size[2] - maximum(bar_coordinates[:, 2]))
        y_pos = "t"
    else
        y_pos = "b"
    end

    str_position = join([y_pos, x_pos])
    sym_position = Symbol(str_position)
    return sym_position
end