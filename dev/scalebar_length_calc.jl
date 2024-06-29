""" 
in development
    len_calc(img::AbstractArray)

Determine default scalebar length, in pixels, based on the dimensions of the input image. 

# Arguments
    img::AbstractArray - input array containing image data
# Returns
    the dimensions of a rectangle with side lengths 20% the length of the image.


""" 

using Distributions
using Revise
includet("simDATA2ima.jl")

test_im = gen_points(;)

function len_calc(img::AbstractArray)
   
    # get the dimensions of the input image
    fx  = size(img)

    # find 20% the length of each dimension
    smfx = 0.2 .* fx
    
    # round these values to one of a set of easy-to-read values. 
    sb_dims = (round(smfx[1]),round(smfx[2]))
             ## need a way to find the nearest multiple that will work for a scalebar.
             ## to avoid wierd lengths like "95" it might be nice to restrict the options a little bit. some thing like a set of reasonable options, like [1,2,5,10,20,25,50,75,100, 150, 200]
    return sb_dims

end



b = len_calc(test_im)

