"""
    gen_points(;sz=100, num_points=100, photons_point=100.0)

    Generate a 2D image with random points and apply Poisson noise, camera readout process, and readout noise.
"""
function gen_points(;sz_y= 256, sz_x=512, num_points=100, photons_point=100.0)

    # Generate random points
    point_locations = Set([(rand(1:sz_y), rand(1:sz_x)) for _ in 1:num_points])
    points = [((i,j), (i+1,j), (i-1,j), (i,j+1), (i,j-1)) for ((i,j)) in point_locations]

    # Initialize the array with points
    arr = [0.0 for i in 1:sz_y, j in 1:sz_x]
    for point in points
        for (i,j) in point
            if 1 <= i <= sz_y && 1 <= j <= sz_x
                arr[i,j] = photons_point
            end
        end
    end

    # Apply Poisson Noise
    for idx in eachindex(arr)
            expected_value = arr[idx]
            p = Poisson(expected_value)
            arr[idx] = rand(p)
    end

    # Model the read out process of a camera 

    offset = 100.0
    gain = 2.5
    readnoise = 1.4 # electrons  

    arr = (gain * arr) .+ offset

    # Corrupt with ReadOut Noise 
    for idx in eachindex(arr)
        expected_value = arr[idx]
        p = Distributions.Normal(expected_value, readnoise * gain)
        arr[idx] = rand(p)
    end

    # Model Analog to Digital Converter by Converting to integer values 
    data = UInt16.(round.(arr)) # 16 bit is standard camera data format
    return data
end