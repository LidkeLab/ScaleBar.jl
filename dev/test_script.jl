using Revise
using ScaleBar

function myf(im;  a::Union{Float64,Nothing}=nothing)

if isnothing(a)
    println("no value set for a")
end

end

myf(rand(3,3))

myf(rand(3,3); a = 4.5)

