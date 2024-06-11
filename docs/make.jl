using ScaleBar
using Documenter

DocMeta.setdocmeta!(ScaleBar, :DocTestSetup, :(using ScaleBar); recursive=true)

makedocs(;
    modules=[ScaleBar],
    authors="klidke@unm.edu",
    sitename="ScaleBar.jl",
    format=Documenter.HTML(;
        canonical="https://LidkeLab.github.io/ScaleBar.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/LidkeLab/ScaleBar.jl",
    devbranch="main",
)
