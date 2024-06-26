"""
DRAFT DOCUMENTATION
    scalebar!(
        img::AbstractArray, 
        scale::Real, 
        unit::String, 
        position::Tuple{Real,Real}, 
        color::RGB{N0f8}=RGB{N0f8}(1,1,1)
        )

    Add a scale bar to an image.

# Arguments
- `img::AbstractArray`: The image to which the scale bar will be added.
- `scale::Real`: The length of the scale bar in pixels.
- `unit::String`: The unit of the scale bar.
- `position::Tuple{Real,Real}`: The position of the scale bar in the image. The first element is the x-coordinate and the second element is the y-coordinate.
- `color::RGB{N0f8}`: The color of the scale bar. The default is white.

Option for rectangle or line segments, choose color
verbosity
total size of image - 
    take that size and decide what the default size 

Returns: `img` with the scale bar added.
"""