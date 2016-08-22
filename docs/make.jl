using Documenter, BeaData

makedocs(
    modules = [BeaData],
    format = Documenter.Formats.HTML,
    sitename = "BeaData.jl",
    pages = Any[
        "Home" => "index.md",
        "Guide" => "man/guide.md",
        "Commands" => "lib/public.md"
    ],
    doctest = false
)

deploydocs(
    repo = "github.com/stephenbnicar/BeaData.jl.git",
    target = "build",
    julia  = "release",
    deps = nothing,
    make = nothing,
)
