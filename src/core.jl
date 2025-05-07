"""
    calculate_bar_dimensions(img, length, width)

Calculate dimensions for the scale bar based on image size.

# Arguments
    img::AbstractArray : Input image
    length::Union{Integer, Nothing} : Length of the scale bar in pixels (or nothing for auto)
    width::Union{Integer, Nothing} : Width of the scale bar in pixels (or nothing for auto)

# Returns
    Tuple of (length_px, width_px) : The dimensions of the scale bar in pixels
"""
function calculate_bar_dimensions(img, length, width)
    if isnothing(length)
        # Calculate default length: 10% of the image width, rounded to nearest 5
        img_width = size(img, 2)
        length_px = round(Int, 0.1 * img_width)
        # Round to nearest 5
        length_px = 5 * round(Int, length_px / 5)
    else
        length_px = Int(length)
    end
    
    if isnothing(width)
        # Width is 20% of the length by default, rounded to nearest odd number for symmetry
        width_px = max(3, round(Int, 0.2 * length_px))
        # Ensure odd number for symmetric appearance
        width_px = width_px % 2 == 0 ? width_px + 1 : width_px
    else
        width_px = Int(width)
    end
    
    return length_px, width_px
end

"""
    get_bar_coordinates(img, position, length_px, width_px, padding)

Calculate the coordinates for placing a scale bar on an image.

# Arguments
    img::AbstractArray : Input image
    position::Symbol : Position indicator (one of :br, :bl, :tr, :tl)
    length_px::Integer : Length of the scale bar in pixels
    width_px::Integer : Width of the scale bar in pixels
    padding::Integer : Padding from the edge of the image in pixels

# Returns
    Tuple of (row_start, row_end, col_start, col_end) : Coordinates for the scale bar
"""
function get_bar_coordinates(img, position, length_px, width_px, padding)
    img_height, img_width = size(img, 1), size(img, 2)
    
    # Validate inputs
    if !(position in [:br, :bl, :tr, :tl])
        throw(ArgumentError("Position must be one of :br, :bl, :tr, :tl"))
    end
    
    if length_px <= 0 || width_px <= 0
        throw(ArgumentError("Length and width must be positive"))
    end
    
    if padding < 0
        throw(ArgumentError("Padding must be non-negative"))
    end
    
    # Check if scale bar will fit within image dimensions
    if length_px + 2*padding > img_width || width_px + 2*padding > img_height
        @warn "Scale bar dimensions ($(length_px)×$(width_px)) plus padding ($(padding)) exceed image dimensions ($(img_width)×$(img_height))"
    end
    
    # Calculate coordinates based on position
    if position == :br
        # Bottom right
        row_start = img_height - padding - width_px + 1
        row_end = img_height - padding
        col_start = img_width - padding - length_px + 1
        col_end = img_width - padding
    elseif position == :bl
        # Bottom left
        row_start = img_height - padding - width_px + 1
        row_end = img_height - padding
        col_start = padding
        col_end = padding + length_px - 1
    elseif position == :tr
        # Top right
        row_start = padding
        row_end = padding + width_px - 1
        col_start = img_width - padding - length_px + 1
        col_end = img_width - padding
    elseif position == :tl
        # Top left
        row_start = padding
        row_end = padding + width_px - 1
        col_start = padding
        col_end = padding + length_px - 1
    end
    
    # Ensure coordinates are within image bounds
    row_start = max(1, row_start)
    row_end = min(img_height, row_end)
    col_start = max(1, col_start)
    col_end = min(img_width, col_end)
    
    # Verify that valid rectangle can be created
    if row_end < row_start || col_end < col_start
        throw(ErrorException("Cannot place scale bar: coordinates invalid"))
    end
    
    return row_start, row_end, col_start, col_end
end

"""
    draw_bar!(img, coords, color)

Draw a scale bar on an image at the specified coordinates.

# Arguments
    img::AbstractArray : Input image
    coords::Tuple : (row_start, row_end, col_start, col_end)
    color::Symbol : Color of the scale bar (:white or :black)

# Returns
    Nothing, modifies img in place
"""
function draw_bar!(img::AbstractArray{<:Colorant}, coords, color)
    row_start, row_end, col_start, col_end = coords
    
    # Convert symbol to RGB value
    if color == :white
        rgb_value = RGB(1.0, 1.0, 1.0)
    elseif color == :black
        rgb_value = RGB(0.0, 0.0, 0.0)
    else
        throw(ArgumentError("Unsupported color: $color. Supported colors are :white and :black"))
    end
    
    # Draw the scale bar
    img[row_start:row_end, col_start:col_end] .= rgb_value
    
    return nothing
end

"""
    draw_bar!(img, coords, color)

Draw a scale bar on a numeric array at the specified coordinates.
For numeric arrays (Float64, etc.), uses 1.0 for white and 0.0 for black.
If the array has values > 1.0, uses the maximum value for white.

# Arguments
    img::AbstractArray{<:Real} : Input image (numeric array)
    coords::Tuple : (row_start, row_end, col_start, col_end)
    color::Symbol : Color of the scale bar (:white or :black)

# Returns
    Nothing, modifies img in place
"""
function draw_bar!(img::AbstractArray{<:Real}, coords, color)
    row_start, row_end, col_start, col_end = coords
    
    # Find the maximum value in the array for scaling
    max_val = maximum(img)
    
    # Convert symbol to numeric value, using max_val for white if values > 1.0
    if color == :white
        if max_val > 1.0
            value = max_val
        else
            value = 1.0
        end
    elseif color == :black
        value = 0.0
    else
        throw(ArgumentError("Unsupported color: $color. Supported colors are :white and :black"))
    end
    
    # Draw the scale bar
    img[row_start:row_end, col_start:col_end] .= value
    
    return nothing
end