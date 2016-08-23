isdefined(Base, :__precompile__) && __precompile__()

module BeaData

using Requests
using DataFrames, DataStructures
using DocStringExtensions

export
    Bea,
    BeaNipaTable,
    api_url,
    api_key,
    api_dataset,
    get_nipa_table,
    nipa_metadata_tex,
    table_metadata_tex

const DEFAULT_API_URL   = "http://www.bea.gov/api/data"
const API_KEY_LENGTH    = 36
const DEFAULT_DATASET   = "NIPA"

"""
A connection to the U.S. Bureau of Economic Analysis (BEA) Data API.

Constructors
------------
* `Bea()`
* `Bea(key::AbstractString)`

Arguments
---------
* `key`: Registration key provided by the BEA.

* A valid registration key is *required* to retrieve data from the BEA's API.
  A key can be obtained by registering at the BEA website.

* A default API key can be specified in a ~/.beadatarc file.

Methods
-------
* `api_url(b::Bls)`: Get the base URL used to connect to the server
* `api_key(b::Bls)`: Get the API key

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
                key = readall(f)
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

api_url(b::Bea) = b.url
api_key(b::Bea) = b.key
api_dataset(b::Bea) = b.dataset

function Base.show(io::IO, b::Bea)
    @printf io "BEA API Connection\n"
    @printf io "\turl: %s\n" api_url(b)
    @printf io "\tkey: %s\n" api_key(b)
    @printf io "\tdataset: %s\n" api_dataset(b)
end

"""
A NIPA table with data and metadata returned from a `get_nipa_table` call.

Fields
---

* `tablenum::AbstractString`: NIPA table number
* `tableid::Int`: API TableID
* `tabledesc::AbstractString`: The table title (e.g., "Real Gross Domestic Product,
 Chained Dollars" for Table 1.1.6)
* `linedesc::OrderedDict`: Dictionary of descriptions for each line of the table
* `tablenotes::Any`: Table notes, if any
* `frequency::AbstractString`: "A" or "Q"
* `startyear::Int`
* `endyear::Int`
* `df::DataFrame`: the data values from the table; column names are the line numbers from the table,
the first column contains the date for each observation in Julia `Date` format

"""
type BeaNipaTable
    tablenum::AbstractString
    tableid::Int
    tabledesc::AbstractString
    linedesc::OrderedDict
    tablenotes::Any
    frequency::AbstractString
    startyear::Int
    endyear::Int
    df::DataFrame
end

function Base.show(io::IO, b::BeaNipaTable)
    @printf io "BEA NIPA Table\n"
    @printf io "\tTable: %s\n" b.tablenum
    @printf io "\tTableID: %s\n" b.tableid
    @printf io "\tDescription: %s\n" b.tabledesc
    @printf io "\tCoverage: %s, from %s to %s\n" b.frequency b.startyear b.endyear
end

include("get_nipa_table.jl")
include("nipa_metadata_tex.jl")
include("table_metadata_tex.jl")

end # module
