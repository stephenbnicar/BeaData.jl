using BeaData
using Base.Test

try
    open(joinpath(homedir(),".beadatarc"), "r") do f
        key = readall(f)
    end
    key = rstrip(key)
    include("test_with_key.jl")
catch err
end
