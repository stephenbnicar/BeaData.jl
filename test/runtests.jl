using BeaData
using Base.Test
using Compat

# try
#     open(joinpath(homedir(),".beadatarc"), "r") do f
#         key = readstring(f)
#     end
#     key = rstrip(key)
#     include("test_with_key.jl")
# catch err
# end

key = ENV["BEA_KEY"]
b = Bea(key)
nipatable = get_nipa_table(b, 5, "Q", 2014, 2014)
