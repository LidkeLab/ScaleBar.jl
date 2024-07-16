# I revised the main scalebar module, and added the documentation.
# I changed some of the function names for clarity, and incorporated the scalebar length calculator. 

using Revise
using Colors
using Images
using CairoMakie



"""
     scalebar_coords(img::AbstractArray;  
        position::String, 
        pxsize::Float64, 
        len::Real, 
        sbwidth::Real,   
        scale::Int,
        units::String,
        )

Generate the starting and ending positions of the scale bar on the input image.

# Arguments
    img::AbstractArray         : A 2-dimensional array of pixels
    position::String           : "br" = bottom right, "ul" = upper left, etc. The default is "br"
    pxsize::Real               : pixel size, default is 0.5
    len::Real                  : the scalebar length, in pixels. The default is determined by the "scalebar_length_calc.jl" function len_calc() 
    width::Real                : similar to length 
    scale::Int                 : scaling factor, default is 15
    units::String              : units, default is "nm" 
   

# Returns
    x_i::Int64                 : starting x position of the scale bar
    x_f::Int64                 : ending x position of the scale bar
    y_i::Int64                 : starting y position of the scale bar   
    y_f::Int64                 : ending y position of the scale bar

"""

"""
    scalebar_draw!(img::AbstractArray, 
        x_i::Int64, 
        x_f::Int64, 
        y_i::Int64, 
        y_f::Int64
        )

Draw the scale bar on the input image. 

# Arguments
    img::AbstractArray         : A 2-dimensional array of pixels
    x_i::Int64                 : starting x position of the scale bar
    x_f::Int64                 : ending x position of the scale bar
    y_i::Int64                 : starting y position of the scale bar
    y_f::Int64                 : ending y position of the scale bar
        
# Returns
    img::AbstractArray         : A 2-dimensional array of pixels with the scale bar drawn on it

"""

"""
    scalebar(img::AbstractArray; 
        position::String, 
        pxsize::Float64, 
        len::Real, 
        scale::Int,
        units::String   
        color::RGB
        )

Create a copy the input image, and use scalebar_coords() and scalebar_draw!() to modify the copied image with a scalebar. 

# Arguments
    img::AbstractArray         : A 2-dimensional array of pixels
    position::String           : "br" = bottom right, "ul" = upper left, etc. The default is "br"
    pxsize::Real               : pixel size. The default is 0.5
    len::Real                  : the scalebar length, in pixels. The default is determined by the "scalebar_length_calc.jl" function len_calc() 
    scale::Int                 : scaling factor. The default is 15
    units::String              : units. The default is "nm"
    color::RGB                 : color of the scale bar. The default is black

# Returns
    img_new with the scale bar drawn on it

"""



includet("scalebar_length_calc.jl") # Include the file that contains the function len_calc()

function scalebar_coords(img::Union{AbstractArray, Matrix{UInt16}, Matrix{RGB{Float64}}};    # input image
    position::String = "br",  # position of the scale bar
    pxsize::Float64 = 0.5,    # pixel size
    len::Real = len_calc(img)[1],    # length of the scale bar
    sbwidth::Real = len_calc(img)[2],    # width of the scale bar
    scale::Int = 15,
    units::String = "nm"    # units of the scale bar
    )
    
    img_sizex = size(img,2)    # input image size in x direction
    img_sizey = size(img,1)    # input image size in y direction
    len_bar = round(Int,len/pxsize)    # length of the scale bar in terms of pixels
    width_bar = round(Int, sbwidth/pxsize)    # width of the scale bar in terms oacf pixels
    offset_x = round(Int,img_sizex/scale)    # define margin in x direction
    offset_y = round(Int,img_sizey/scale)    # define margin in y direction
    if position[1] == 'b'
        x_i = img_sizey - width_bar - offset_y 
        x_f = img_sizey - offset_y
        println("b")
    elseif position[1] == 'u'
        x_i = offset_y
        x_f = offset_y + width_bar
        println("u")
    end
    if position[2] == 'r'
        y_i = img_sizex - len_bar - offset_x
        y_f = img_sizex - offset_x
        println("r")
    elseif position[2] == 'l'
        y_i = offset_x
        y_f = offset_x + len_bar 
        println("l")
    end
    return x_i, x_f, y_i, y_f
end   

function scalebar_draw(img::Union{AbstractArray, Matrix{UInt16}, Matrix{RGB{Float64}}}, 
    x_i::Int64, 
    x_f::Int64, 
    y_i::Int64, 
    y_f::Int64; 
    color::RGB = RGB(0,0,0))
   
    img[x_i:x_f, y_i:y_f] .= color # draw the line (rectangular) scale bar

end


function scalebar(img::Union{AbstractArray, Matrix{UInt16}, Matrix{RGB{Float64}}}; 
    position::String = "br", 
    pxsize::Float64 = 0.5, 
    len::Real = len_calc(img)[1], 
    sbwidth::Real = len_calc(img)[2],
    scale::Int=15,
    units::String = "nm",
    color::RGB = RGB(0,0,0) 
    )
    img_new = deepcopy(img)    # make a copy of the original image
    x_i, x_f, y_i, y_f = scalebar_coords(img_new,position,pxsize,len,sbwidth,scale,units)
    img_new = scalebar_draw(img_new,x_i, x_f, y_i, y_f)    # draw the scale bar on the copied image
    return img_new 
end

