"""
in developemt - I integrated scalebar_length_calc.jl
    scalebar!(img::AbstractArray; 
        position::String, 
        pxsize::F, 
        len::Real, 
        scale::Int,
        units::String,
        width::Real  
     ) 

Create a scalebar for an input image and apply that scalebar to the image. 

# Arguments
    img::AbstractArray         : A 2-dimensional array of pixels
    position::String           : "br" = bottom right, "ul" = upper left, etc
    pxsize::Real               : pixel size
    len::Real                  : the scalebar length, in pixels. The default is determined by the "scalebar_length_calc.jl" function len_calc() 
    scale::Int                 : scaling factor
    units::String              : units 
    width::Real                : similar to length. 

# Returns

"""


using Revise
using Colors
using Images
using CairoMakie

includet("simDATA2ima.jl")
includet("scalebar_length_calc.jl")

# Modified ver to add width parameter
function scalebar!(img::AbstractArray; 
    position::String = "br", 
    pxsize::Float64 = 0.5, 
    len::Real = len_calc(img)[1], 
    scale::Int=15,
    units::String = "nm",
    width::Real = len_calc(img)[2]
     )
    
    img_sizex = size(img,2)
    img_sizey = size(img,1)
    len_bar = round(Int,len/pxsize)
    width_bar = round(Int,width/pxsize) # Use width parameter to set width_bar
    offset_x = round(Int,img_sizex/scale)
    offset_y = round(Int,img_sizey/scale)
    if position[1] == 'b'
        x_i = img_sizey-width_bar-offset_y
        x_f = img_sizey-offset_y
        println("b")
    elseif position[1] == 'u'
        x_i = offset_y
        x_f = offset_y+width_bar
        println("u")
    end
    if position[2] == 'r'
        y_i = img_sizex-len_bar-offset_x
        y_f = img_sizex-offset_x
        println("r")
    elseif position[2] == 'l'
        y_i = offset_x
        y_f = offset_x+len_bar 
        println("l")
    end
    return x_i, x_f, y_i, y_f
end   

function scalebar(img::AbstractArray; 
    position::String = "br", 
    pxsize::Float64 = 0.5, 
    len::Real = len_calc(img)[1], 
    scale::Int=15,
    units::String = "nm",
    width::Real = len_calc(img)[2]
     )
    
 img_new = deepcopy(img)
 scalebar!(img_new,position=position,pxsize=pxsize,len=len,scale=scale,width=width) # Added width parameter
 return img_new 
end

#draw the scale bar with width
function scalebar_draw(img::Union{AbstractArray, Matrix{UInt16}},x_i::Int64, x_f::Int64, y_i::Int64, y_f::Int64)
    img[x_i:x_f, y_i:y_f] .= RGB(0,0,0) # Fill in the rectangle
end

#test scale bar 
img = RGB.(ones(1028,1920))
x_i, x_f, y_i, y_f = scalebar!(img, position="br")
scalebar_draw(img, x_i, x_f, y_i, y_f)
img

