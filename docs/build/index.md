
<a id='BeaData.jl-Documentation-1'></a>

# BeaData.jl Documentation


A Julia interface for retrieving data from the U.S. Bureau of Economic Analysis (BEA) Data API.

<a id='BeaData.Bea' href='#BeaData.Bea'>#</a>
**`BeaData.Bea`** &mdash; *Type*.



A connection to the U.S. Bureau of Economic Analysis (BEA) Data API.

**Constructors**

  * `Bea()`
  * `Bea(key::AbstractString)`

**Arguments**

  * `key`: Registration key provided by the BEA.

  * A valid registration key is *required* to retrieve data from the BEA's API.   A key can be obtained by registering at the BEA website.

  * A default API key can be specified in a ~/.beadatarc file.

**Methods**

  * `api_url(b::Bls)`: Get the base URL used to connect to the server
  * `api_key(b::Bls)`: Get the API key

<a id='BeaData.BeaNipaTable' href='#BeaData.BeaNipaTable'>#</a>
**`BeaData.BeaNipaTable`** &mdash; *Type*.



A NIPA table with data and metadata returned from a `get_nipa_table` call.

<a id='BeaData.get_nipa_table-Tuple{BeaData.Bea,Int64,AbstractString,Int64,Int64}' href='#BeaData.get_nipa_table-Tuple{BeaData.Bea,Int64,AbstractString,Int64,Int64}'>#</a>
**`BeaData.get_nipa_table`** &mdash; *Method*.



```
    get_nipa_table(b::Bea, TableID::Int, frequency::AbstractString,
        startyear::Int, endyear::Int)
```

Request a NIPA table from the BEA data API.

**Arguments**

  * `b`: a BEA API connection
  * `TableID`: the integer Table ID for the desired NIPA table
  * `frequency`: "A" for annual, "Q" for quarerly
  * `startyear`: first year of data requested, in YYYY format
  * `endyear`: last year of data requested, in YYYY format

**Returns**

  * An object of type `BeaNipaTable`

<a id='BeaData.nipa_metadata_tex-Tuple{BeaData.Bea}' href='#BeaData.nipa_metadata_tex-Tuple{BeaData.Bea}'>#</a>
**`BeaData.nipa_metadata_tex`** &mdash; *Method*.



```
`nipa_metadata_tex(b::Bea)`
```

**Arguments**

  * `b`: a BEA API connection

**Returns**

  * A .tex file with the parmater list for the NIPA dataset and parameter values for the TableID parameter.  The file is written to the curent working directory.

<a id='BeaData.table_metadata_tex-Tuple{BeaData.BeaNipaTable}' href='#BeaData.table_metadata_tex-Tuple{BeaData.BeaNipaTable}'>#</a>
**`BeaData.table_metadata_tex`** &mdash; *Method*.



```
`table_metadata_tex(bnt::BeaNipaTable)`
```

**Arguments**

  * `bnt`: a BEA NIPA Table object

**Returns**

  * A .tex file with metadata (table name and description, line numbers and descriptions, and table notes) for a NIPA table.  The file is written to the curent working directory.

