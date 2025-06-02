"""
    ScaleBarConfig

Configuration struct for scale bar appearance and positioning.

# Fields
- `position::Symbol`: Position of the scale bar (:br, :bl, :tr, :tl)
- `height::Union{Nothing,Int}`: Height of the scale bar in pixels (nothing for auto)
- `width::Union{Nothing,Int}`: Width of the scale bar in pixels (nothing for auto)
- `padding::Int`: Padding from the edge of the image in pixels
- `color::Symbol`: Color of the scale bar (:white or :black)

# Example
```julia
config = ScaleBarConfig(position=:br, height=10, color=:white)
# Use the same config for multiple images
scalebar!(img1, 0.1, 50; config=config)
scalebar!(img2, 0.1, 50; config=config)
```
"""
struct ScaleBarConfig
    position::Symbol
    height::Union{Nothing,Int}
    width::Union{Nothing,Int}
    padding::Int
    color::Symbol
    
    function ScaleBarConfig(; position=:br, height=nothing, width=nothing, padding=20, color=:white)
        if !(position in [:br, :bl, :tr, :tl])
            throw(ArgumentError("Position must be one of :br, :bl, :tr, :tl"))
        end
        if !(color in [:white, :black])
            throw(ArgumentError("Color must be :white or :black"))
        end
        if !isnothing(height) && height <= 0
            throw(ArgumentError("Height must be positive"))
        end
        if !isnothing(width) && width <= 0
            throw(ArgumentError("Width must be positive"))
        end
        if padding < 0
            throw(ArgumentError("Padding must be non-negative"))
        end
        new(position, height, width, padding, color)
    end
end

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
    draw_bar!(img::AbstractArray{<:Colorant}, coords, color::Symbol)

Draw a scale bar on a color image at the specified coordinates.

# Arguments
- `img::AbstractArray{<:Colorant}`: Input color image
- `coords::Tuple`: (row_start, row_end, col_start, col_end)
- `color::Symbol`: Color of the scale bar (:white or :black)

# Returns
Nothing, modifies img in place
"""
function draw_bar!(img::AbstractArray{<:Colorant}, coords, color::Symbol)
    row_start, row_end, col_start, col_end = coords
    
    # Convert symbol to RGB value
    rgb_value = color == :white ? RGB(1.0, 1.0, 1.0) : RGB(0.0, 0.0, 0.0)
    
    # Draw the scale bar
    @inbounds for i in row_start:row_end, j in col_start:col_end
        img[i, j] = rgb_value
    end
    
    return nothing
end

"""
    draw_bar!(img::AbstractArray{T}, coords, color::Symbol) where T<:Real

Draw a scale bar on a numeric array at the specified coordinates.
For numeric arrays, uses appropriate values based on the array's data type and range.

# Arguments
- `img::AbstractArray{T}`: Input numeric array
- `coords::Tuple`: (row_start, row_end, col_start, col_end)
- `color::Symbol`: Color of the scale bar (:white or :black)

# Returns
Nothing, modifies img in place
"""
function draw_bar!(img::AbstractArray{T}, coords, color::Symbol) where T<:Real
    row_start, row_end, col_start, col_end = coords
    
    # Determine the appropriate value for the color
    if color == :white
        # For floating point arrays with values > 1.0, use the maximum value
        value = if T <: AbstractFloat && maximum(img) > 1.0
            T(maximum(img))
        else
            one(T)
        end
    else  # :black
        value = zero(T)
    end
    
    # Draw the scale bar
    @inbounds for i in row_start:row_end, j in col_start:col_end
        img[i, j] = value
    end
    
    return nothing
end