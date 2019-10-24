module BeaData

using HTTP, JSON, Retry
using DataFrames, DataStructures, Dates
import Base.show

export
    # Types
    Bea,
    BeaTable,
    # Methods
    get_bea_datasets,
    get_bea_parameterlist,
    get_nipa_table

const API_URL = "https://apps.bea.gov/api/data"
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
include("deprecated.jl")

end # module
