# main interface function:
using Images
using CairoMakie

function scalebar!(img::AbstractArray, length::Real, pxsize::Float64, bar_pxsize::Float64, unit::String, position::String, orientation::String)

    # unit (µm, nm, mm, cm)
    # position (TopRight:TR, TopLeft:TL, BottomRight:BR, BottomLeft:BL)
    # orientation (Horizontal:H, Vertical:V)

#   img_size = (32, 32)
#   img_size = (256, 256)

#   length = 40

    pxsize = 0.1

    # Get the size of the image
    x, y = size(img)
   
    img_sizex = x
    img_sizey = y
    
    bar_pxsize = len / pxsize
    bar_thickness = max(1, min(img_sizex, img_sizey) ÷ 20)
    margin = 2 * bar_thickness
    bar_middle = bar_thickness ÷ 2
    
    
    if position == "TR"
        if orientation == "Horizontal"
            for idx in img_sizey - margin - length: img_sizey - margin
                img[idx] .= 1
            end
        else
            x1, y1 = img_sizey - margin, margin
            x2, y2 = img_sizey - margin, margin + length
        end
    elseif position = "TL"
        if orientation == "Horizontal"
            x1, y1 = margin, margin
            x2, y2 = margin + length, margin
        else
            x1, y1 = margin, margin
            x2, y2 = margin, margin + length
        end
    elseif position in "BR"
        if orientation == "Horizontal"
            x1, y1 = img_sizey - margin - length, img_sizex - margin
            x2, y2 = img_sizey - margin, img_sizex - margin
        else
            x1, y1 = img_sizey - margin, img_sizex - margin - length
            x2, y2 = img_sizey - margin, img_sizex - margin
        end
    elseif position in "BL"
        if orientation == "Horizontal"
            x1, y1 = margin, img_sizex - margin
            x2, y2 = margin + length, img_sizex - margin
        else
            x1, y1 = margin, img_sizex - margin - length
            x2, y2 = margin, img_sizex - margin
        end
    else
        error("Invalid position value")

        
    end







 # Draw the scale bar on the image
 img = annotate!(img, Shape(x1, y1, x2, y2), :black, linewidth=bar_thickness)
    
 # Add the scale bar label
 label_x = (x1 + x2) / 2
 label_y = (y1 + y2) / 2 - bar_thickness * 2
 img = annotate!(img, text("$length $unit", label_x, label_y, 12, :black))

 return img
end


end