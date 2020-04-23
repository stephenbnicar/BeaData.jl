using Documenter
using BeaData

makedocs(
    sitename = "BeaData",
    format = Documenter.HTML(),
    modules = [BeaData]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
