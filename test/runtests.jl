using Test
using Images

include("../src/ScaleBar.jl")
include("../src/interface.jl")
include("test_helpers.jl")

@testset "scalebar_test" begin
    # Write your tests here.

    # Test scenario
    img = Gray.(zeros(512,512))
    img_with_bar = scalebar(img, 1.0, color=:white, position="bl")
    len::Real = len_calc(img)[1]   # length and width default to results of len_calc() from the helper code found in src/interface.jl
    binary_img_with_bar = img_with_bar
    binary_img_with_bar[img_with_bar .> 0.5] .= 1
    binary_img_with_bar[img_with_bar .<= 0.5] .= 0
    binary_img_with_bar = convert(Array{Int}, binary_img_with_bar)
    bar_coordinates = get_bar_coordinates(binary_img_with_bar)

   @testset "Size_test" begin

        bar_size1 = get_bar_size(bar_coordinates)
        @test bar_size1 == len

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
