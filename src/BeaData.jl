module BeaData

import HTTP
import JSON
using Dates
using DataFrames, DataStructures

import Base.show

export
    # Types
    Bea,
    BeaTable,
    # Methods
    get_bea_datasets,
    get_bea_parameterlist,
    get_nipa_table

const DEFAULT_API_URL = "https://APPS.BEA.GOV/api/data"
const API_KEY_LENGTH  = 36

"""

A connection to the U.S. Bureau of Economic Analysis (BEA) Data API.

Constructors
------------
* `Bea()`
* `Bea(key::AbstractString)`

Arguments
---------
* `key`: Registration key provided by the BEA.

A valid registration key is required to retrieve data from the BEA's API.  A key can be obtained by registering at the BEA website.

A default API key can be specified in a ~/.beadatarc file.

"""
mutable struct Bea
    url::AbstractString
    key::AbstractString
end

Bea(key) = Bea(DEFAULT_API_URL, key)

function Bea()
    key = ""
    if "BEA_KEY" in keys(ENV)
        key = ENV["BEA_KEY"]
    elseif isfile(joinpath(homedir(), ".beadatarc"))
        open(joinpath(homedir(),".beadatarc"), "r") do f
            key = read(f, String)
        end
        key = rstrip(key)
    else
        error("No API key found, connection not initialized")
    end

    println("API key loaded.")

    # Key validation
    if length(key) > API_KEY_LENGTH || length(key) < API_KEY_LENGTH
        error("Invalid key length (≠ ", API_KEY_LENGTH, " chars), connection not initialized")
    end

    return Bea(key)
end

function Base.show(io::IO, b::Bea)
    println(io, "BEA API Connection")
    println(io, "url: $(b.url)")
    println(io, "key: $(b.key)")
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

include("get_bea_datasets.jl")
include("get_bea_parameterlist.jl")
include("get_nipa_table.jl")

end # module
