isdefined(Base, :__precompile__) && __precompile__()

module BeaData

using Requests
using DataFrames, DataStructures

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
            # Key validation
            if length(key) > API_KEY_LENGTH
                key = key[1:API_KEY_LENGTH]
                warn("Key too long. First ", API_KEY_LENGTH, " chars used.")
            end
        catch err
        end

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

# """
# A NIPA table with metadata returned from a `get_nipa_table` call.
#
# Access fields with
# ```
# id(s::BeaNipaTable)
# series(s::BeaNipaTable)
# notes(s::BeaNipaTable)
# ```
# """
type BeaNipaTable
    tablenum::AbstractString
    tableid::AbstractString
    tabledesc::AbstractString
    linedesc::OrderedDict
    tablenotes::Any
    frequency::AbstractString
    startyear::Int
    endyear::Int
    df::DataFrame
end
EMPTY_RESPONSE() = BeaNipaTable("", "", "", 0, 0, DataFrame())

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
