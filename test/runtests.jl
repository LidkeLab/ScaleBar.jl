using Test
using Images
include("../src/ScaleBar_old.jl")
include("../src/interface_old.jl")
include("test_helpers.jl")

@testset "scalebar_test" begin
    # Write your tests here.

    # Test scenario
    img = RGB.(zeros(512,512))
    img2 = scalebar(img, 1.0, color=:white)
    img_gray = Gray.(img2)./maximum(Gray.(img2))
    img_binary = copy(img_gray)
    img_binary[img_gray .> 0.5] .= 1.0
    img_binary[img_gray .<= 0.5] .= 0.0
    img_binary = convert(Array{Int}, img_binary)
    # example_image1[3:12, 6:17] .= 1  # Create a bar of 1s. Size=10x12
    # example_image2 = zeros(Int, 100, 200)  # Ensure the matrix is of integer type
    # example_image2[6:17, 3:15] .= 1 # Create a bar of 1s. Size=12x13
    # example_image3 = zeros(Int, 100, 200)  # Ensure the matrix is of integer type
    # example_image3[20:45, 3:15] .= 1 # Create a bar of 1s. Size=26x13
    bar_coordinates1 = get_bar_coordinates(img_binary)
    # bar_coordinates2 = get_bar_coordinates(example_image2)
    # bar_coordinates3 = get_bar_coordinates(example_image3)

   @testset "Size_test" begin

        bar_size1 = get_bar_size(bar_coordinates1)
        @test bar_size1 == 12

        bar_size2 = get_bar_size(bar_coordinates2)
        @test bar_size2 == 13

        bar_size3 = get_bar_size(bar_coordinates3)
        @test bar_size3 == 26

    end

    @testset "Orientation_test" begin

        bar_orientation1 = get_bar_orientation(bar_coordinates1)
        @test bar_orientation1 == :horizontal

        bar_orientation2 = get_bar_orientation(bar_coordinates2)
        @test bar_orientation2 == :horizontal

        bar_orientation3 = get_bar_orientation(bar_coordinates3)
        @test bar_orientation3 == :vertical

    end

    @testset "Position_test" begin
        
        bar_position1 = get_bar_position(bar_coordinates1, example_image1)
        @test bar_position1 == :bl

        bar_position2 = get_bar_position(bar_coordinates2, example_image2)
        @test bar_position2 == :bl

        bar_position3 = get_bar_position(bar_coordinates3, example_image3)
        @test bar_position3 == :bl

    end


end


img = RGB.(zeros(512,512))
img2 = scalebar(img, 1.0, color=:white)
img_gray = Gray.(img2)./maximum(Gray.(img2))
img_binary = copy(img_gray)
img_binary[img_gray .> 0.5] .= 1.0
img_binary[img_gray .<= 0.5] .= 0.0
img_binary = convert(Array{Int}, img_binary)
# example_image1[3:12, 6:17] .= 1  # Create a bar of 1s. Size=10x12
# example_image2 = zeros(Int, 100, 200)  # Ensure the matrix is of integer type
# example_image2[6:17, 3:15] .= 1 # Create a bar of 1s. Size=12x13
# example_image3 = zeros(Int, 100, 200)  # Ensure the matrix is of integer type
# example_image3[20:45, 3:15] .= 1 # Create a bar of 1s. Size=26x13
bar_coordinates1 = get_bar_coordinates(img_binary)