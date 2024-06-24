function scalebar!(img::AbstractArray, scale::Real, unit::String, position::Tuple{Real,Real}, color::Tuple{Real,Real,Real}=RGB(1,1,1))
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
    text!(img, "$scale $unit", (x + scalebar_width + 5, y + scalebar_height), color=color, fontsize=10  
end