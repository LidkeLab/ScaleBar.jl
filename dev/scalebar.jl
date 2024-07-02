using Revise
using Colors
using Images
using CairoMakie
#using GeometryBasics
#=
function scalebar!(img::AbstractArray, scale::Real, unit::String, position::Tuple{Real,Real}, color::RGB{N0f8}=RGB{N0f8}(1,1,1))
    # Get the size of the image
    height, width = size(img)
    
    # Get the size of the scalebar
    scalebar_width = 100
    scalebar_height = 10
    
    # Get the position of the scalebar
    x, y = position
    
    # Draw the scalebar
    for i in 1:scalebar_height
        for j in 1:scalebar_width
            img[Int(round(y + i)), Int(round(x + j))] = color
        end
    end
    
    # Draw the text
    #text!(img, "$scale $unit", (x + scalebar_width + 5, y + scalebar_height), color=color, fontsize=10) 

end =#


function scalebar!(img::AbstractArray;    # input image
    position::String = "br",    # position of the scale bar
    pxsize::Float64 = 0.5,    # pixel size
    len::Real = 20,    # length of the scale bar
    scale::Int = 15,
    units::String = "nm"    # units of the scale bar
    )
    
    img_sizex = size(img,2)    # input image size in x direction
    img_sizey = size(img,1)    # input image size in y direction
    len_bar = round(Int,len/pxsize)    # length of the scale bar in terms of pixels
    width_bar = round(Int,len_bar/(scale/2))    # width of the scale bar in terms of pixels
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

# make a copy of the original image
function scalebar(img::AbstractArray; 
    position::String = "br", 
    pxsize::Float64 = 0.5, 
    len::Real = 20, 
    scale::Int=15,
    units::String = "nm")
 img_new = deepcopy(img)
 scalebar!(img_new,position,pxsize,len,scale)
 return img_new 
end

#draw the scale bar 
function scalebar_draw(img::AbstractArray,x_i::Int64, x_f::Int64, y_i::Int64, y_f::Int64)
    midle_bar=round(Int,((x_f-x_i)/2)+x_i)
    img[x_i:x_f,y_i-1].= RGB(0,0,0)
    img[x_i:x_f,y_f+1].= RGB(0,0,0)
    img[midle_bar,y_i:y_f].= RGB(0,0,0)
end

#test scale bar 
img = RGB.(ones(512,512))
x_i, x_f, y_i, y_f = scalebar!(img,position="br",len=50,)
scalebar_draw(img,x_i, x_f, y_i, y_f)
img

# Modify the scale bar draw

function scalebar_draw(img::AbstractArray, 
    x_i::Int64, 
    x_f::Int64, 
    y_i::Int64, 
    y_f::Int64; 
    color::RGB = RGB(0,0,0))
    midle_bar = round(Int, ((x_f - x_i) / 2) + x_i)
    img[x_i:x_f, y_i-1] .= color
    img[x_i:x_f, y_f+1] .= color
    img[midle_bar, y_i:y_f] .= color
end

# Modified ver to add width parameter
function scalebar!(img::AbstractArray; 
    position::String = "br", 
    pxsize::Float64 = 0.5, 
    len::Real = 20, 
    scale::Int=15,
    units::String = "nm",
    width::Real = 5 ) # Added width parameter
    
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
    len::Real = 20, 
    scale::Int=15,
    units::String = "nm",
    width::Real = 5 ) # Added width parameter
    
 img_new = deepcopy(img)
 scalebar!(img_new,position=position,pxsize=pxsize,len=len,scale=scale,width=width) # Added width parameter
 return img_new 
end

#draw the scale bar with width
function scalebar_draw(img::AbstractArray,x_i::Int64, x_f::Int64, y_i::Int64, y_f::Int64)
    img[x_i:x_f, y_i:y_f] .= RGB(0,0,0) # Fill in the rectangle
end

#test scale bar 
img = RGB.(ones(512,512))
x_i, x_f, y_i, y_f = scalebar!(img, position="br", len=50, width=10)
scalebar_draw(img, x_i, x_f, y_i, y_f)
img

