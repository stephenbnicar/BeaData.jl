isdefined(Base, :__precompile__) && __precompile__()

module BeaData

using Requests
using DataFrames, DataStructures
using DocStringExtensions
using Compat
import Base.show

export
    Bea,
    get_bea_datasets,
    get_bea_parameterlist,
    BeaNipaTable,
    get_nipa_table,
    nipa_metadata_tex,
    table_metadata_tex

const DEFAULT_API_URL   = "https://www.bea.gov/api/data"
const API_KEY_LENGTH    = 36
const DEFAULT_DATASET   = "NIPA"

"""
$(TYPEDEF)

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

Fields
------
$(FIELDS)

"""
type Bea
    url::AbstractString
    key::AbstractString
    dataset::AbstractString
end

function Bea(key="")
    if isempty(key)
        try
            open(joinpath(homedir(),".beadatarc"), "r") do f
                key = readstring(f)
            end
            key = rstrip(key)
            @printf "API key loaded.\n"
        catch
            error("No API key found, connection not initialized")
        end
    end

    # Key validation
    if length(key) > API_KEY_LENGTH || length(key) < API_KEY_LENGTH
        error("Invalid key length (≠ ", API_KEY_LENGTH, " chars), connection not initialized")
    end

    url = DEFAULT_API_URL
    dataset = DEFAULT_DATASET
    Bea(url, key, dataset)
end

function Base.show(io::IO, b::Bea)
    @printf io "BEA API Connection\n"
    @printf io "\turl: %s\n" b.url
    @printf io "\tkey: %s\n" b.key
    @printf io "\tdataset: %s\n" b.dataset
end

"""
$(TYPEDEF)

A NIPA table with data and metadata returned from a [`get_nipa_table`](@ref) call.

Fields
---
$(FIELDS)

"""
type BeaNipaTable
    "- NIPA table number"
    tablenum::AbstractString
    "- API TableID"
    tableid::Int
    "- The table title (e.g., 'Real Gross Domestic Product, Chained Dollars' for Table 1.1.6)"
    tabledesc::AbstractString
    "- `OrderedDict` of descriptions for each line of the table"
    linedesc::OrderedDict
    "- Table notes, if any"
    tablenotes::Any
    frequency::AbstractString
    startyear::Int
    endyear::Int
    "- `DataFrame` containing the data values from the table; column names are the line numbers from the table, the first column contains the date for each observation in Julia `Date` format"
    df::DataFrame
end

function Base.show(io::IO, b::BeaNipaTable)
    @printf io "BEA NIPA Table\n"
    @printf io "\tTable: %s\n" b.tablenum
    @printf io "\tTableID: %s\n" b.tableid
    @printf io "\tDescription: %s\n" b.tabledesc
    @printf io "\tCoverage: %s, from %s to %s\n" b.frequency b.startyear b.endyear
end

include("get_bea_datasets.jl")
include("get_bea_parameterlist.jl")
include("get_nipa_table.jl")
include("nipa_metadata_tex.jl")
include("table_metadata_tex.jl")

end # module
