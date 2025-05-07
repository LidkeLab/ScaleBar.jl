using Images
using ScaleBar
using FileIO

"""
    save_test_image(img, filename)

Save an image to the test directory for visual inspection.
"""
function save_test_image(img, filename)
    # Create output directory if it doesn't exist
    output_dir = joinpath(@__DIR__, "output")
    isdir(output_dir) || mkdir(output_dir)
    save(joinpath(output_dir, "$(filename).png"), img)
end

# Functions moved to avoid duplicates

"""
    verify_scalebar_placement(img, position, length_px, width_px, padding)

Verify that a scale bar is correctly placed on the image according to the specified parameters.

Returns a tuple of (success::Bool, message::String)
"""
function verify_scalebar_placement(img, position, length_px, width_px, padding)
    height, width = size(img)
    
    # Determine the expected region where the scale bar should be
    if position == :br
        expected_region = (
            (height - padding - width_px + 1):(height - padding),
            (width - padding - length_px + 1):(width - padding)
        )
    elseif position == :bl
        expected_region = (
            (height - padding - width_px + 1):(height - padding),
            padding:(padding + length_px - 1)
        )
    elseif position == :tr
        expected_region = (
            padding:(padding + width_px - 1),
            (width - padding - length_px + 1):(width - padding)
        )
    elseif position == :tl
        expected_region = (
            padding:(padding + width_px - 1),
            padding:(padding + length_px - 1)
        )
    else
        return (false, "Invalid position: $position")
    end
    
    # Check if all pixels in the expected region are the same color
    rows, cols = expected_region
    first_pixel = img[first(rows), first(cols)]
    
    for i in rows
        for j in cols
            if img[i, j] != first_pixel
                return (false, "Scale bar is not uniform in color at position ($i, $j)")
            end
        end
    end
    
    return (true, "Scale bar is correctly placed and uniform in color")
end

"""
    create_test_image(height, width; background=0.5)

Create a test image of given dimensions with optional background color.
Default is gray (0.5) for better visibility of both white and black scale bars.
"""
function create_test_image(height, width; background=0.5)
    return RGB.(fill(background, height, width))
end

"""
    create_gradient_image(height, width)

Create a test image with a gradient pattern for better visibility of scale bars.
"""
function create_gradient_image(height, width)
    img = zeros(RGB{Float64}, height, width)
    for i in 1:height
        for j in 1:width
            # Create a medium-gray gradient for better visibility of both white and black scale bars
            img[i, j] = RGB(0.5 - i/height/4, 0.5 - j/width/4, 0.6)
        end
    end
    return img
end

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
    get_bar_position(bar_coordinates::Matrix{Int}, image::Array)

Get the position of the bar in the image.

# Arguments
- `bar_coordinates::Matrix{Int}`: A 2-column matrix with the x and y coordinates of the bar.
- `image::Array`: The image containing the bar.

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