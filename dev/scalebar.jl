using Revise
using Colors
using Images

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

end 


function scalebar!(img::AbstractArray; position::String = "br", pxsize::Float64 = 0.5, len::Real = 20, scale::Int=15 )
    img_sizex = size(img,1)
    img_sizey = size(img,2)
    len_bar = round(Int,len/pxsize)
    width_bar = round(Int,len_bar/(scale/2))
    offset_x = round(Int,img_sizex/scale)
    offset_y = round(Int,img_sizey/scale)
    
    if position[1] == 'b'
        y_i = img_sizey-width_bar-offset_y
        y_f = img_sizey-offset_y
        println("b")
    elseif position[1] == 'u'
        y_i = offset_y
        y_f = offset_y+width_bar
        println("u")
    end
    if position[2] == 'r'
        x_i = img_sizex-len_bar-offset_x
        x_f = img_sizex-offset_x
        println("r")
    elseif position[2] == 'l'
        x_i = offset_x
        x_f = offset_x+len_bar 
        println("l")
    end
    
    return x_i, x_f, y_i, y_f
end    

function scalebar(img::AbstractArray; position::String = "br", pxsize::Float64 = 0.5, len::Real = 20, scale::Int=15 )
 img_new = deepcopy(img)
 scalebar!(img_new, position,pxsize,len,scale)
 return img_new 
end