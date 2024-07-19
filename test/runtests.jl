using Test
using Images

include("../src/ScaleBar.jl")
include("../src/interface.jl")
include("test_helpers.jl")

@testset "scalebar_test" begin
    # Write your tests here.

    # Test scenario
    img = Gray.(zeros(512,512))
    len = 100 # length of the scalebar in units
    width = 20 # width of the scalebar in units
    pxsize = 1.0 # size of a pixel in units
    img_with_bar = scalebar(img, pxsize; color=:white, position=:bl, len, width)
    given_bar_size = len/pxsize # size of the bar in pixels given the length and pixel size
    binary_img_with_bar = img_with_bar
    binary_img_with_bar[img_with_bar .> 0.5] .= 1
    binary_img_with_bar[img_with_bar .<= 0.5] .= 0
    binary_img_with_bar = convert(Array{Int}, binary_img_with_bar)
    bar_coordinates = get_bar_coordinates(binary_img_with_bar)

   @testset "Size_test" begin

        bar_size1 = get_bar_size(bar_coordinates)
        @test bar_size1 == given_bar_size

    end

    @testset "Orientation_test" begin

        bar_orientation = get_bar_orientation(bar_coordinates)
        @test bar_orientation == :horizontal

    end

    @testset "Position_test" begin
        
        bar_position = get_bar_position(bar_coordinates, binary_img_with_bar)
        @test bar_position == :bl

    end

end