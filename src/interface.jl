# main interface function:

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
