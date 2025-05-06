using Images

include("core.jl")

"""
    scalebar!(img, pixel_size; kwargs...)

Add a scale bar to an image in-place, using physical units.

# Arguments
    img::AbstractArray : Input image
    pixel_size::Real : Size of each pixel in physical units (e.g., nm, μm)

# Keyword Arguments
    position::Symbol : Position of the scale bar (`:tl`, `:tr`, `:bl`, `:br`), default: `:br`
    physical_length::Real : Length of the scale bar in physical units, default: auto-calculated
    width::Integer : Width of the scale bar in pixels, default: auto-calculated
    padding::Integer : Padding from the edge of the image in pixels, default: 10
    color::Symbol : Color of the scale bar (`:white` or `:black`), default: `:white`
    units::String : Units for the physical length (e.g., "nm", "μm"), default: ""

# Returns
    Nothing, modifies img in-place

# Examples
```julia
using Images, ScaleBar

# Create a test image
img = RGB.(ones(512, 512))

# Add a scale bar representing 10μm (assuming 0.1μm per pixel)
scalebar!(img, 0.1, physical_length=10, units="μm")
```
"""
function scalebar!(
    img::AbstractArray,
    pixel_size::Real;
    position::Symbol = :br,
    physical_length::Union{Real, Nothing} = nothing,
    width::Union{Integer, Nothing} = nothing,
    padding::Integer = 10,
    color::Symbol = :white,
    units::String = ""
)
    # Validate inputs
    if pixel_size <= 0
        throw(ArgumentError("pixel_size must be positive"))
    end
    
    # Calculate length in pixels if physical_length is provided
    if !isnothing(physical_length)
        if physical_length <= 0
            throw(ArgumentError("physical_length must be positive"))
        end
        length_px = round(Int, physical_length / pixel_size)
    else
        length_px = nothing
    end
    
    # Calculate bar dimensions
    length_px, width_px = calculate_bar_dimensions(img, length_px, width)
    
    # Calculate actual physical length represented by the scale bar
    actual_physical_length = length_px * pixel_size
    
    # Get coordinates for the scale bar
    coords = get_bar_coordinates(img, position, length_px, width_px, padding)
    
    # Draw the scale bar
    draw_bar!(img, coords, color)
    
    # Print information about the scale bar
    unit_suffix = isempty(units) ? "" : " $(units)"
    println("Scale bar: $(round(actual_physical_length, digits=2))$(unit_suffix) ($(length_px)×$(width_px) pixels)")
    
    return nothing
end

"""
    scalebar!(img; kwargs...)

Add a scale bar to an image in-place, specifying dimensions in pixels.

# Arguments
    img::AbstractArray : Input image

# Keyword Arguments
    position::Symbol : Position of the scale bar (`:tl`, `:tr`, `:bl`, `:br`), default: `:br`
    length::Integer : Length of the scale bar in pixels, default: auto-calculated
    width::Integer : Width of the scale bar in pixels, default: auto-calculated
    padding::Integer : Padding from the edge of the image in pixels, default: 10
    color::Symbol : Color of the scale bar (`:white` or `:black`), default: `:white`

# Returns
    Nothing, modifies img in-place

# Examples
```julia
using Images, ScaleBar

# Create a test image
img = RGB.(ones(512, 512))

# Add a 50-pixel scale bar
scalebar!(img, length=50)
```
"""
function scalebar!(
    img::AbstractArray;
    position::Symbol = :br,
    length::Union{Integer, Nothing} = nothing,
    width::Union{Integer, Nothing} = nothing,
    padding::Integer = 10,
    color::Symbol = :white
)
    # Calculate bar dimensions
    length_px, width_px = calculate_bar_dimensions(img, length, width)
    
    # Get coordinates for the scale bar
    coords = get_bar_coordinates(img, position, length_px, width_px, padding)
    
    # Draw the scale bar
    draw_bar!(img, coords, color)
    
    # Print information about the scale bar
    println("Scale bar: $(length_px)×$(width_px) pixels")
    
    return nothing
end

"""
    scalebar(img, pixel_size; kwargs...)

Create a new image with a scale bar, using physical units.

# Arguments
    img::AbstractArray : Input image
    pixel_size::Real : Size of each pixel in physical units (e.g., nm, μm)

# Keyword Arguments
    position::Symbol : Position of the scale bar (`:tl`, `:tr`, `:bl`, `:br`), default: `:br`
    physical_length::Real : Length of the scale bar in physical units, default: auto-calculated
    width::Integer : Width of the scale bar in pixels, default: auto-calculated
    padding::Integer : Padding from the edge of the image in pixels, default: 10
    color::Symbol : Color of the scale bar (`:white` or `:black`), default: `:white`
    units::String : Units for the physical length (e.g., "nm", "μm"), default: ""

# Returns
    A new image with the scale bar added

# Examples
```julia
using Images, ScaleBar

# Create a test image
img = RGB.(ones(512, 512))

# Add a scale bar representing 10μm (assuming 0.1μm per pixel)
img_with_scalebar = scalebar(img, 0.1, physical_length=10, units="μm")
```
"""
function scalebar(
    img::AbstractArray,
    pixel_size::Real;
    position::Symbol = :br,
    physical_length::Union{Real, Nothing} = nothing,
    width::Union{Integer, Nothing} = nothing,
    padding::Integer = 10,
    color::Symbol = :white,
    units::String = ""
)
    # Create a copy of the input image
    img_copy = deepcopy(img)
    
    # Add the scale bar to the copy
    scalebar!(
        img_copy,
        pixel_size;
        position=position,
        physical_length=physical_length,
        width=width,
        padding=padding,
        color=color,
        units=units
    )
    
    return img_copy
end

"""
    scalebar(img; kwargs...)

Create a new image with a scale bar, specifying dimensions in pixels.

# Arguments
    img::AbstractArray : Input image

# Keyword Arguments
    position::Symbol : Position of the scale bar (`:tl`, `:tr`, `:bl`, `:br`), default: `:br`
    length::Integer : Length of the scale bar in pixels, default: auto-calculated
    width::Integer : Width of the scale bar in pixels, default: auto-calculated
    padding::Integer : Padding from the edge of the image in pixels, default: 10
    color::Symbol : Color of the scale bar (`:white` or `:black`), default: `:white`

# Returns
    A new image with the scale bar added

# Examples
```julia
using Images, ScaleBar

# Create a test image
img = RGB.(ones(512, 512))

# Add a 50-pixel scale bar
img_with_scalebar = scalebar(img, length=50)
```
"""
function scalebar(
    img::AbstractArray;
    position::Symbol = :br,
    length::Union{Integer, Nothing} = nothing,
    width::Union{Integer, Nothing} = nothing,
    padding::Integer = 10,
    color::Symbol = :white
)
    # Create a copy of the input image
    img_copy = deepcopy(img)
    
    # Add the scale bar to the copy
    scalebar!(
        img_copy;
        position=position,
        length=length,
        width=width,
        padding=padding,
        color=color
    )
    
    return img_copy
end