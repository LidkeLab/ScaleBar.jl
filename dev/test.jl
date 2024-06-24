
function get_bar_coordinates(image::Matrix)
    # Write your function here.
    pos_x::Array = []
    pos_y::Vector = []
    ii = 0
    for i in 1:size(output_test_image, 1)
        for j in 1:size(output_test_image, 2)
            if output_test_image[i, j] == 1
                if ii == 0
                    ii = 1
                    pos_x = i
                    pos_y = j
                else
                    ii += 1
                    push!(pos_x, i)
                    push!(pos_y, j)
                end
            end
        end
    end
    pos = zeros(length(pos_x), length(pos_y))
    pos = [pos_x, pos_y]
    return pos
end


    # Write your tests here.

    example_image = zeros(200, 100)
    bar_size = 10
    # output_test_image = scalebar(image::Array = example_image, bar_size::Int, orientation::String = "horizontal", position::String = "tl")
    example_image[3:10, 6:36] .= 1
    bar_coordinatres = get_bar_coordinates(example_image)
