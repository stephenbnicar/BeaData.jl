using Documenter
using BeaData

makedocs(
    sitename = "BeaData",
    format = Documenter.HTML(),
    modules = [BeaData]
)

deploydocs(
    repo = "github.com/stephenbnicar/BeaData.jl.git",
    versions = ["stable" => "v^", devurl => devurl]
)
