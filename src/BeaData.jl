module BeaData

using HTTP, JSON, Retry
using DataFrames, DataStructures, Dates
import Base.show

export
    # Types
    BeaTable,
    # Methods
    bea_datasets,
    bea_parameterlist,
    bea_parametervalues,
    bea_table,
    get_bea_datasets,
    get_bea_parameterlist,
    get_nipa_table

const API_URL = "https://apps.bea.gov/api/data"

function __init__()
    global USER_ID = ""
    if "BEA_USERID" in keys(ENV)
        USER_ID = ENV["BEA_USERID"]
        println("BEA UserID found!")
    elseif isfile(joinpath(homedir(), ".beadatarc"))
        open(joinpath(homedir(),".beadatarc"), "r") do f
            USER_ID = String(strip(read(f, String)))
        end
        println("BEA UserID found!")
    else
        println("No BEA UserID found!")
    end
end

include("deprecated.jl")
include("metadata_methods.jl")
include("bea_table.jl")

end # module
