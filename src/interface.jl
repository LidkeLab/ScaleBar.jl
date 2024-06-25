# main interface function:
using Images
using CairoMakie

img = load("/Users/Mahsa/Desktop/The_famous_Lena.png")

length = 10
pxsize = 0.1

x, y = size(img)
img_sizex = x
img_sizey = y

bar_pxsize = length / pxsize
bar_thickness = max(1, min(img_sizex, img_sizey) ÷ 20)
bar_middle = bar_thickness ÷ 2

position = "TR"
orientation = "Horizontal"

function scalebar!(img::AbstractArray, length::Real, pxsize::Float64, bar_pxsize::Float64, bar_thickness, position::String, orientation::String)
    img_sizey, img_sizex = size(img)
    ar_pxsize = length / pxsize
    bar_thickness = max(1, min(img_sizex, img_sizey) ÷ 20)

    println("Image size: ", (img_sizex, img_sizey))
    println("Bar thickness: ", bar_thickness)
    println("Bar pixel size: ", bar_pxsize)

    if position == "TR"
        if orientation == "Horizontal"
            start_col = Int(img_sizey - bar_pxsize - bar_thickness)
            end_col = Int(img_sizey - bar_pxsize)

            println("Start column: ", start_col)
            println("End column: ", end_col)

            for idx in start_col:end_col
                img[1:Int(bar_thickness), idx] .= RGB(1, 1, 1)
            end
        end
    end
end

scalebar!(img, length, pxsize, bar_pxsize, bar_thickness, position, orientation)

save("/Users/Mahsa/Desktop/The_famous_Lena_with_scalebar.png", img)

display(img)

mydir = ("Src")

fn = "The_famous_Lena_with_scalebar.png"
filepath = joinpath(mydir, fn)

save(filepath, img)