using ScaleBar
using Test
using Images
using Colors
using Random

# Set random seed for reproducibility
Random.seed!(1234)

# Include test helpers
include("test_helpers.jl")

@testset "ScaleBar.jl" begin
    # Include individual test files
    include("test_core.jl")
    include("test_scalebar_mutating.jl")
    include("test_scalebar_nonmutating.jl")
    include("test_edge_cases.jl")
    include("test_api.jl")

    # Check for method ambiguities
    @testset "Ambiguities" begin
        @test isempty(Test.detect_ambiguities(ScaleBar))
    end
end
