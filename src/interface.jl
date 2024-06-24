# main interface function:
using Images
using CairoMakie

function scalebar!(img::AbstractArray, len::Real, pxsize::Float64, bar_pxsize::Float64, unit::String, position::String, orientation::String)

    # unit (µm, nm, mm, cm)
    # position (TopRight:TR, TopLeft:TL, BottomRight:BR, BottomLeft:BL)
    # orientation (Horizontal:H, Vertical:V)

    img_size = (32, 32)
#   img_size = (256, 256)

    len = 40

    pxsize = 0.1

    bar_pxsize = len / pxsize


    # Get the size of the image
    img_sizex, img_sizey = size(img)




    x1, y1, x2, y2 = 0, 0, 0, 0
    
    if position in ["TopRight", "TR"]
        if orientation == "Horizontal"
            x1, y1 = img_sizey - margin - length, margin
            x2, y2 = img_sizey - margin, margin
        else
            x1, y1 = img_sizey - margin, margin
            x2, y2 = img_sizey - margin, margin + length
        end
    elseif position in ["TopLeft", "TL"]
        if orientation == "Horizontal"
            x1, y1 = margin, margin
            x2, y2 = margin + length, margin
        else
            x1, y1 = margin, margin
            x2, y2 = margin, margin + length
        end
    elseif position in ["BottomRight", "BR"]
        if orientation == "Horizontal"
            x1, y1 = img_sizey - margin - length, img_sizex - margin
            x2, y2 = img_sizey - margin, img_sizex - margin
        else
            x1, y1 = img_sizey - margin, img_sizex - margin - length
            x2, y2 = img_sizey - margin, img_sizex - margin
        end
    elseif position in ["BottomLeft", "BL"]
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



end