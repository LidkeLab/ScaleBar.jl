function scalebar!(img::AbstractArray,
    pxsize::Float64; 
    position::String = "br",
    len::Real = 20, 
    scale::Int=15,
    width::Real = 5,
    color::Symbol= :white)

    img_sizex = size(img,2)
    img_sizey = size(img,1)
    len_bar = round(Int,len/pxsize)
    println("len_bar: ",len_bar)
    width_bar = round(Int,width/pxsize) # Use width parameter to set width_bar
    offset_x = round(Int,img_sizex/scale)
    offset_y = round(Int,img_sizey/scale)
    if position[1] == 'b'
        x_i = img_sizey-width_bar-offset_y
        x_f = img_sizey-offset_y
        #println("b")
    elseif position[1] == 't'
        x_i = offset_y
        x_f = offset_y+width_bar
        #println("t")
    end
    if position[2] == 'r'
        y_i = img_sizex-len_bar-offset_x
        y_f = img_sizex-offset_x
        #println("r")
    elseif position[2] == 'l'
        y_i = offset_x
        y_f = offset_x+len_bar 
        #println("l")
    end
    if color == :white
        return img[x_i:x_f, y_i:y_f] .= RGB(1,1,1) # Fill in the rectangle
    elseif color == :black
        return img[x_i:x_f, y_i:y_f] .= RGB(0,0,0) # Fill in the rectangle
    end

end   

function scalebar(img::AbstractArray,
    pxsize::Float64; 
    position::String = "br",  
    len::Real = 20, 
    scale::Int=15,
    width::Real = 5,
    color::Symbol= :white) # Added width parameter

 img_new = deepcopy(img)
 scalebar!(img_new,pxsize,position=position,len=len,scale=scale,width=width,color=color) # Added width parameter
 return img_new 
end


#test scale bar 
# img = RGB.(ones(512,512))
# scalebar!(img,0.5,color=:black)
# img