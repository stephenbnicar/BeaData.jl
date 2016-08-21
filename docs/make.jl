using Documenter, BeaData

makedocs(
    modules = [BeaData],
    format = Documenter.Formats.HTML,
    sitename = "BeaData.jl",
    doctest = false
)

deploydocs(
    repo = "github.com/stephenbnicar/BeaData.jl.git",
    julia  = "release",
    osname = "linux",
    deps = nothing,
    make = nothing
)
