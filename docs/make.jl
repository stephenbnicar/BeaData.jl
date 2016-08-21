using Documenter, BeaData

makedocs(
    modules = [BeaData],
    format = Documenter.Formats.HTML,
    sitename = "BeaData.jl",
    doctest = false
)
