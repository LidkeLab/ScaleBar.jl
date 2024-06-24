# main interface function:



function scalebar!(img::AbstractArray, length::Real, unit::String, position::String, orientaion::String)

    size(img) = (32, 32)
    length = 40
# unit (µm, nm, mm, cm)
# position (TopRight:TR, TopLeft:TL, BottomRight:BR, BottomLeft:BL)
# orientation (Horizontal:H, Vertical:V)

    # Get the size of the image
    img_sizex, img_sizey = size(img)
    
    
    # Get the position of the scalebar
    x, y = position
    
    # Draw the scalebar
    # for i in 1:scalebar_height
    #     for j in 1:scalebar_width
    #         img[Int(round(y + i)), Int(round(x + j))] = color
    #     end
    # end
    
    # Draw the text
    #text!(img, "$scale $unit", (x + scalebar_width + 5, y + scalebar_height), color=color, fontsize=10) 

end
