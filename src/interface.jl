"""
    scalebar!(img::AbstractArray, pxsize::Float64;      
        position::String,        
        len::Real, 
        width::Real,
        scale::Int,
        color::Symbol = :white)

Add scalebar to the input image.


# Arguments
    img::AbstractArray         : A 2-dimensional array of pixels
    pxsize::Real               : pixel size
    position::String           : "br" = bottom right, "bl" = bottom left, "tr" = top right, "tl" = top left  The default is "br"
    len::Real                  : the scalebar length, in pixels. The default is determined by the function len_calc() 
    width::Real                : similar to length
    scale::Int                 : scaling factor, default is 15
    color::Symbol              : either `:white` (default) or `:black`
   

# Returns
    img array with scalebar
"""
function scalebar!(img::AbstractArray, # updated function sigature with len_calc (-Ian)
    pxsize::Float64; 
    position::String = "br", 
    len::Real = len_calc(img)[1],    # length and width default to results of len_calc()
    width::Real = len_calc(img)[2],
    scale::Int=15,
    color::Symbol= :white ) # Added width parameter
    
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


"""
    scalebar(img::AbstractArray, pxsize::Float64;      
        position::String,        
        len::Real, 
        scale::Int,
        width::Real,
        color::Symbol = :white)

Copy img and pass the copy to scalebar!()

# Arguments
    img::AbstractArray         : A 2-dimensional array of pixels
    pxsize::Real               : pixel size
    position::String           : "br" = bottom right, "bl" = bottom left, "tr" = top right, "tl" = top left  The default is "br"
    len::Real                  : the scalebar length, in pixels. The default is determined by the function len_calc() 
    width::Real                : similar to length
    scale::Int                 : scaling factor, default is 15
    color::Symbol              : either `:white` (default) or `:black`
   
# Returns
    A copy of img with scalebar applied

"""
function scalebar(img::AbstractArray, # updated function sigature with len_calc (-Ian)
    pxsize::Float64; 
    position::String = "br", 
    len::Real = len_calc(img)[1],    # length and width default to results of len_calc()
    width::Real = len_calc(img)[2],
    scale::Int=15,
    color::Symbol= :white )  # Added width parameter
    
 img_new = deepcopy(img)
 scalebar!(img_new,pxsize,position=position,len=len,scale=scale,width=width,color=color) # Added width parameter
 return img_new 
end



""" 
    len_calc(img::AbstractArray)

Determine default scalebar length based on the dimensions of the input image. 

# Arguments
    img::AbstractArray : input array containing image data

# Returns
    len : scalebar length dimension in pixels
    width : scalebar width dimension in pixels
""" 
function len_calc(img::Union{AbstractArray, Array{Float64}})
   
    # get the dimensions of the input image
    len_dim = size(img)[2]
    
    # find 20% the length of the image
    len_sb = 0.2 .* len_dim
    
    # find the nearest multiple of 5
    if len_sb > 150
        sb_len = (len_sb +(100-len_sb%100))
    else 
        sb_len = (len_sb-len_sb%5)
    end
    

    # set the width based on the length 
    sb_wid = sb_len*.25
    sb_wid = sb_wid - sb_wid %5
    sb_dims = (sb_len, sb_wid)
    
    println("default scalebar dimensions calculated:", sb_dims)
        
    len = convert(Int, sb_len)
    width = convert(Int, sb_wid)
    return len, width

end
