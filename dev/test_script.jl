using Revise
using ScaleBar

function myf(im;  a::Union{Float64,Nothing}=nothing)

if isnothing(a)
    println("no value set for a")
end

end

myf(rand(3,3))

myf(rand(3,3); a = 4.5)

# example skeleton 

function scalebar()

    a()
    b()
    c()
end

function a()
end

function b()
end

function c()
end
