# I revised the main scalebar module, and added the documentation.
# I changed some of the function names for clarity, and incorporated the scalebar length calculator. 

using Revise
using Colors
using Images
using CairoMakie


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

