using BeaData
using Base.Test

b = Bea()
nipatable = get_nipa_table(b, 5, "Q", 2014, 2014)

## Use for travis test when no key in environment
# try
#     open(joinpath(homedir(),".beadatarc"), "r") do f
#         key = readall(f)
#     end
#     key = rstrip(key)
#     include("test_with_key.jl")
# catch err
# end
