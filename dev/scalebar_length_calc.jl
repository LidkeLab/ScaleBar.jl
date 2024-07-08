""" 
    len_calc(img::AbstractArray)

Determine default scalebar length, in pixels, based on the dimensions of the input image. 

# Arguments
    img::AbstractArray : input array containing image data

# Returns
    len : scalebar length dimension in pixels
    width : scalebar width dimension in pixels


""" 

using Distributions
using Revise

function len_calc(img::Union{AbstractArray, Array{RGB{Float64}}})
   
    # get the dimensions of the input image
    len_dim = size(img)[2]
    
    # find 20% the length of the image
    len_sb = 0.2 .* len_dim
    
    # find the nearest multiple of 5. May be nice to add more detail here, for example, a case for small images with scalebar lengths of 1 or 2. for larger input dimensions it will be nice to have different rules for larger images that will have scalebar length in the hundreds. 
    if len_sb > 150
        sb_len = (len_sb +(100-len_sb%100))
    else 
        sb_len = (len_sb-len_sb%5)
    end
    

    # set the width based on the length 
    sb_wid = sb_len*.25
    sb_wid = sb_wid - sb_wid %5
    sb_dims = (sb_len, sb_wid)
    
    println("default scalebar dimensions calculated:", sb_dims) # this prints twice
        
    len = convert(Int, sb_len)
    width = convert(Int, sb_wid)
    return len, width

end


