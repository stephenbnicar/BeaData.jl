isdefined(Base, :__precompile__) && __precompile__()

module BeaData

using Requests
using DataFrames, DataStructures
using DocStringExtensions
using Compat
import Base.show

export
    # Types
    Bea,
    BeaNipaTable,
    # Methods
    get_bea_datasets,
    get_bea_parameterlist,
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

Bea(key) = Bea(DEFAULT_API_URL, key, DEFAULT_DATASET)

function Bea()
    key = ""
    if "BEA_KEY" in keys(ENV)
        key = ENV["BEA_KEY"]
    elseif isfile(joinpath(homedir(), ".beadatarc"))
        open(joinpath(homedir(),".beadatarc"), "r") do f
            key = readstring(f)
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
    @printf io "BEA API Connection\n"
    @printf io "\turl: %s\n" b.url
    @printf io "\tkey: %s\n" b.key
end

"""
$(TYPEDEF)

A NIPA table with data and metadata returned from a [`get_nipa_table`](@ref) call.

Fields
---

* tablenum - NIPA table number
* tableid - API TableID
* tabledesc - The table title (e.g., 'Real Gross Domestic Product, Chained Dollars' for Table 1.1.6)
* linedesc - `OrderedDict` of descriptions for each line of the table
* tablenotes - Table notes, if any
* frequency
* startyear
* endyear
* df - `DataFrame` containing the data values from the table; column names are the line numbers from the table, the first column contains the date for each observation in Julia `Date` format

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

include("get_bea_datasets.jl")
include("get_bea_parameterlist.jl")
include("get_nipa_table.jl")
include("nipa_metadata_tex.jl")
include("table_metadata_tex.jl")

end # module
