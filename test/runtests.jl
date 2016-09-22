using BeaData
using Base.Test
using Compat

try
    open(joinpath(homedir(),".beadatarc"), "r") do f
        key = readstring(f)
    end
    key = rstrip(key)
    include("test_with_key.jl")
catch err
end
