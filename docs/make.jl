using Documenter
using BeaData

makedocs(
    modules = [BeaData],
    format = Documenter.Formats.HTML,
    sitename = "BeaData.jl",
    pages = Any[
        "Home" => "index.md",
        "Index" => "lib/public.md"
    ],
    doctest = false
)

deploydocs(
    repo = "github.com/stephenbnicar/BeaData.jl.git",
    target = "build",
    julia  = "0.6",
    deps = nothing,
    make = nothing,
)
