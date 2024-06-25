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

function barposition(img::AbstractArray; position::String = "br", pxsize::Float64 = 0.5, len::Real = 10 )
img_sizex = size(img,1)
img_sizey = size(img,2)
scale_factor = 15
len_bar = round(Int,len/pxsize)
width_bar = round(Int,len_bar/(scale_factor/2))
offset_x = round(Int,img_sizex/scale_factor)
offset_y = round(Int,img_sizey/scale_factor)

if position[1] == "b"
    y_i = img_sizey-width_bar-offset_y
    y_f = img_sizey-offset_y
elseif position[1] == "u"
    y_i = offset_y
    y_f = offset_y+width_bar
end
if position[2] == "r"
    x_i = img_sizex-len_bar-offset_x
    x_f = img_sizex-offset_x
elseif position[2] =="l"
    x_i = offset_x
    x_f = offset_x+len_bar 
end

return x_i, x_f, y_i, y_f
function b()


end