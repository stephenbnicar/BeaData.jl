var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "BeaData.jl Documentation",
    "title": "BeaData.jl Documentation",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#BeaData.Bea",
    "page": "BeaData.jl Documentation",
    "title": "BeaData.Bea",
    "category": "Type",
    "text": "A connection to the U.S. Bureau of Economic Analysis (BEA) Data API.\n\nConstructors\n\nBea()\nBea(key::AbstractString)\n\nArguments\n\nkey\n: Registration key provided by the BEA.\n\nA valid registration key is \nrequired\n to retrieve data from the BEA's API.   A key can be obtained by registering at the BEA website.\n\nA default API key can be specified in a ~/.beadatarc file.\n\nMethods\n\napi_url(b::Bls)\n: Get the base URL used to connect to the server\napi_key(b::Bls)\n: Get the API key\n\n\n\n"
},

{
    "location": "index.html#BeaData.BeaNipaTable",
    "page": "BeaData.jl Documentation",
    "title": "BeaData.BeaNipaTable",
    "category": "Type",
    "text": "A NIPA table with data and metadata returned from a get_nipa_table call.\n\n\n\n"
},

{
    "location": "index.html#BeaData.get_nipa_table-Tuple{BeaData.Bea,Int64,AbstractString,Int64,Int64}",
    "page": "BeaData.jl Documentation",
    "title": "BeaData.get_nipa_table",
    "category": "Method",
    "text": "    get_nipa_table(b::Bea, TableID::Int, frequency::AbstractString,\n        startyear::Int, endyear::Int)\n\nRequest a NIPA table from the BEA data API.\n\nArguments\n\nb\n: a BEA API connection\nTableID\n: the integer Table ID for the desired NIPA table\nfrequency\n: \"A\" for annual, \"Q\" for quarerly\nstartyear\n: first year of data requested, in YYYY format\nendyear\n: last year of data requested, in YYYY format\n\nReturns\n\nAn object of type \nBeaNipaTable\n\n\n\n"
},

{
    "location": "index.html#BeaData.nipa_metadata_tex-Tuple{BeaData.Bea}",
    "page": "BeaData.jl Documentation",
    "title": "BeaData.nipa_metadata_tex",
    "category": "Method",
    "text": "`nipa_metadata_tex(b::Bea)`\n\nArguments\n\nb\n: a BEA API connection\n\nReturns\n\nA .tex file with the parmater list for the NIPA dataset and parameter values for the TableID parameter.  The file is written to the curent working directory.\n\n\n\n"
},

{
    "location": "index.html#BeaData.table_metadata_tex-Tuple{BeaData.BeaNipaTable}",
    "page": "BeaData.jl Documentation",
    "title": "BeaData.table_metadata_tex",
    "category": "Method",
    "text": "`table_metadata_tex(bnt::BeaNipaTable)`\n\nArguments\n\nbnt\n: a BEA NIPA Table object\n\nReturns\n\nA .tex file with metadata (table name and description, line numbers and descriptions, and table notes) for a NIPA table.  The file is written to the curent working directory.\n\n\n\n"
},

{
    "location": "index.html#BeaData.jl-Documentation-1",
    "page": "BeaData.jl Documentation",
    "title": "BeaData.jl Documentation",
    "category": "section",
    "text": "A Julia interface for retrieving data from the U.S. Bureau of Economic Analysis (BEA) Data API.Modules = [BeaData]"
},

]}
