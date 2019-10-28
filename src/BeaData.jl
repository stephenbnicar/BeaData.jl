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

"""
A NIPA table with data and metadata returned from a [`get_nipa_table`](@ref) call.

Fields
---

* tablenum - NIPA table number
* tablename - API TableName
* tabledesc - The table title (e.g., 'Real Gross Domestic Product, Chained Dollars' for Table 1.1.6)
* linedesc - `OrderedDict` of descriptions for each line of the table
* tablenotes - Table notes, if any
* frequency
* startyear
* endyear
* df - `DataFrame` containing the data values from the table; column names are the line numbers from the table, the first column contains the date for each observation in Julia `Date` format

"""
mutable struct BeaTable
    tablenum::AbstractString
    tablename::AbstractString
    tabledesc::AbstractString
    linedesc::OrderedDict
    tablenotes::Any
    frequency::AbstractString
    startyear::Int
    endyear::Int
    df::DataFrame
end

function Base.show(io::IO, b::BeaTable)
    println(io, "BEA NIPA Table")
    println(io, "Table: $(b.tablenum)")
    println(io, "TableName: $(b.tablename)")
    println(io, "Description: $(b.tabledesc)")
    println(io, "Coverage: $(b.frequency), from $(b.startyear) to $(b.endyear)")
end

include("deprecated.jl")
include("metadata_methods.jl")
include("get_nipa_table.jl")

end # module
