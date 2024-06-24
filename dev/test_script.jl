using Revise 


function myf(im;  a::Union{Float64,Nothing}=nothing)

if isnothing(a)
    println("no value set for a")
end

end