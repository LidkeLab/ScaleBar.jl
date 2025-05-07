using Images

"""
    scalebar!(img, pixel_size, physical_length; kwargs...)

Add a scale bar to an image in-place, using physical units.

# Arguments
    img::AbstractArray : Input image
    pixel_size::Real : Size of each pixel in physical units (e.g., nm, μm)
    physical_length::Real : Length of the scale bar in physical units

# Keyword Arguments
    position::Symbol : Position of the scale bar (`:tl`, `:tr`, `:bl`, `:br`), default: `:br`
    width::Integer : Width of the scale bar in pixels, default: auto-calculated
    padding::Integer : Padding from the edge of the image in pixels, default: 10
    color::Symbol : Color of the scale bar (`:white` or `:black`), default: `:white`
    units::String : Units for the physical length (e.g., "nm", "μm"), default: ""
    quiet::Bool : If true, suppresses console output, default: false

# Returns
    Nothing, modifies img in-place

# Examples
```julia
using Images, ScaleBar

# Create a test image with gray background for better visibility
img = RGB.(fill(0.5, 512, 512))

# Add a scale bar representing 10μm (assuming 0.1μm per pixel)
scalebar!(img, 0.1, 10, position=:br, units="μm")
```
"""
function scalebar!(
    img::AbstractArray,
    pixel_size::Real,
    physical_length::Real;
    position::Symbol = :br,
    width::Union{Integer, Nothing} = nothing,
    padding::Integer = 10,
    color::Symbol = :white,
    units::String = "",
    quiet::Bool = false
)
    # Validate inputs
    if pixel_size <= 0
        throw(ArgumentError("pixel_size must be positive"))
    end
    
    if physical_length <= 0
        throw(ArgumentError("physical_length must be positive"))
    end
    
    if !(position in [:br, :bl, :tr, :tl])
        throw(ArgumentError("Position must be one of :br, :bl, :tr, :tl"))
    end
    
    # Calculate length in pixels
    length_px = round(Int, physical_length / pixel_size)
    
    # Calculate bar width
    if isnothing(width)
        # Width is 20% of the length by default, rounded to nearest odd number for symmetry
        width_px = max(3, round(Int, 0.2 * length_px))
        # Ensure odd number for symmetric appearance
        width_px = width_px % 2 == 0 ? width_px + 1 : width_px
    else
        width_px = Int(width)
    end
    
    # Get coordinates for the scale bar
    coords = get_bar_coordinates(img, position, length_px, width_px, padding)
    
    # Draw the scale bar
    draw_bar!(img, coords, color)
    
    # Print information about the scale bar (unless quiet mode is enabled)
    if !quiet
        unit_suffix = isempty(units) ? "" : " $(units)"
        println("Scale bar: $(round(physical_length, digits=2))$(unit_suffix) ($(length_px)×$(width_px) pixels)")
    end
    
    return nothing
end

"""
    scalebar!(img, length; kwargs...)

Add a scale bar to an image in-place, specifying dimensions in pixels.

# Arguments
    img::AbstractArray : Input image
    length::Integer : Length of the scale bar in pixels

# Keyword Arguments
    position::Symbol : Position of the scale bar (`:tl`, `:tr`, `:bl`, `:br`), default: `:br`
    width::Integer : Width of the scale bar in pixels, default: auto-calculated
    padding::Integer : Padding from the edge of the image in pixels, default: 10
    color::Symbol : Color of the scale bar (`:white` or `:black`), default: `:white`
    quiet::Bool : If true, suppresses console output, default: false

# Returns
    Nothing, modifies img in-place

# Examples
```julia
using Images, ScaleBar

# Create a test image with gray background for better visibility
img = RGB.(fill(0.5, 512, 512))

# Add a 50-pixel scale bar
scalebar!(img, 50, position=:br)
```
"""
function scalebar!(
    img::AbstractArray,
    length::Integer;
    position::Symbol = :br,
    width::Union{Integer, Nothing} = nothing,
    padding::Integer = 10,
    color::Symbol = :white,
    quiet::Bool = false
)
    # Validate inputs
    if length <= 0
        throw(ArgumentError("length must be positive"))
    end
    
    if !(position in [:br, :bl, :tr, :tl])
        throw(ArgumentError("Position must be one of :br, :bl, :tr, :tl"))
    end
    
    # Calculate bar width (length is explicit)
    if isnothing(width)
        # Width is 20% of the length by default, rounded to nearest odd number for symmetry
        width_px = max(3, round(Int, 0.2 * length))
        # Ensure odd number for symmetric appearance
        width_px = width_px % 2 == 0 ? width_px + 1 : width_px
    else
        width_px = Int(width)
    end
    
    # Get coordinates for the scale bar
    coords = get_bar_coordinates(img, position, length, width_px, padding)
    
    # Draw the scale bar
    draw_bar!(img, coords, color)
    
    # Print information about the scale bar (unless quiet mode is enabled)
    if !quiet
        println("Scale bar: $(length)×$(width_px) pixels")
    end
    
    return nothing
end

"""
    scalebar(img, pixel_size; physical_length=nothing, kwargs...)

Create a new image with a scale bar, using physical units.

# Arguments
    img::AbstractArray : Input image
    pixel_size::Real : Size of each pixel in physical units (e.g., nm, μm)

# Keyword Arguments
    physical_length::Union{Real, Nothing} : Length of the scale bar in physical units, default: auto-calculated
    position::Symbol : Position of the scale bar (`:tl`, `:tr`, `:bl`, `:br`), default: `:br`
    width::Union{Integer, Nothing} : Width of the scale bar in pixels, default: auto-calculated
    padding::Integer : Padding from the edge of the image in pixels, default: 10
    color::Symbol : Color of the scale bar (`:white` or `:black`), default: `:white`
    units::String : Units for the physical length (e.g., "nm", "μm"), default: ""
    quiet::Bool : If true, suppresses console output, default: false

# Returns
    A new image with the scale bar added

# Examples
```julia
using Images, ScaleBar

# Create a test image with gray background for better visibility
img = RGB.(fill(0.5, 512, 512))

# Add a scale bar with auto-calculated length (assuming 0.1μm per pixel)
img_with_bar1 = scalebar(img, 0.1, position=:br, units="μm")

# Add a scale bar with explicit length of 10μm
img_with_bar2 = scalebar(img, 0.1, physical_length=10, position=:br, units="μm")
```
"""
function scalebar(
    img::AbstractArray,
    pixel_size::Real;
    physical_length::Union{Real, Nothing} = nothing,
    position::Symbol = :br,
    width::Union{Integer, Nothing} = nothing,
    padding::Integer = 10,
    color::Symbol = :white,
    units::String = "",
    quiet::Bool = false
)
    # Create a copy of the input image
    img_copy = deepcopy(img)
    
    if isnothing(physical_length)
        # Calculate default length: 10% of the image width in physical units
        img_width = size(img, 2)
        phys_length = 0.1 * img_width * pixel_size
        
        # Round to a nice value for the scale bar
        magnitude = 10^floor(log10(phys_length))
        phys_length = round(phys_length / magnitude) * magnitude
        
        # Add the scale bar to the copy using auto-calculated physical length
        scalebar!(
            img_copy,
            pixel_size,
            phys_length;
            position=position,
            width=width,
            padding=padding,
            color=color,
            units=units,
            quiet=quiet
        )
    else
        # Add the scale bar to the copy with the provided physical length
        scalebar!(
            img_copy,
            pixel_size,
            physical_length;
            position=position,
            width=width,
            padding=padding,
            color=color,
            units=units,
            quiet=quiet
        )
    end
    
    return img_copy
end

"""
    scalebar(img; length=nothing, kwargs...)

Create a new image with a scale bar, specifying dimensions in pixels.

# Arguments
    img::AbstractArray : Input image

# Keyword Arguments
    length::Union{Integer, Nothing} : Length of the scale bar in pixels, default: auto-calculated
    position::Symbol : Position of the scale bar (`:tl`, `:tr`, `:bl`, `:br`), default: `:br`
    width::Union{Integer, Nothing} : Width of the scale bar in pixels, default: auto-calculated
    padding::Integer : Padding from the edge of the image in pixels, default: 10
    color::Symbol : Color of the scale bar (`:white` or `:black`), default: `:white`
    quiet::Bool : If true, suppresses console output, default: false

# Returns
    A new image with the scale bar added

# Examples
```julia
using Images, ScaleBar

# Create a test image with gray background for better visibility
img = RGB.(fill(0.5, 512, 512))

# Add a scale bar with auto-calculated length
img_with_bar1 = scalebar(img, position=:br)

# Add a 50-pixel scale bar with explicit length
img_with_bar2 = scalebar(img, length=50, position=:br)
```
"""
function scalebar(
    img::AbstractArray;
    length::Union{Integer, Nothing} = nothing,
    position::Symbol = :br,
    width::Union{Integer, Nothing} = nothing,
    padding::Integer = 10,
    color::Symbol = :white,
    quiet::Bool = false
)
    # Create a copy of the input image
    img_copy = deepcopy(img)
    
    if isnothing(length)
        # Calculate default length: 10% of the image width, rounded to nearest 5
        img_width = size(img, 2)
        length_px = round(Int, 0.1 * img_width)
        # Round to nearest 5
        length_px = 5 * round(Int, length_px / 5)
        
        # Add the scale bar to the copy using auto-calculated length
        scalebar!(
            img_copy,
            length_px;
            position=position,
            width=width,
            padding=padding,
            color=color,
            quiet=quiet
        )
    else
        # Add the scale bar to the copy with the provided length
        scalebar!(
            img_copy,
            length;
            position=position,
            width=width,
            padding=padding,
            color=color,
            quiet=quiet
        )
    end
    
    return img_copy
end