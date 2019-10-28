"""
    bea_query(url, querydict)

Internal method for handling requests to the BEA data API
"""
function bea_query(url, querydict)
    # Catch "broken pipe" IOError
    # https://github.com/stephenbnicar/BeaData.jl/issues/10
    # https://github.com/JuliaWeb/HTTP.jl/issues/382
    response = @repeat 3 try
        HTTP.request("GET", url, query = querydict)
    catch e
        @delay_retry if isa(e, Base.IOError) end
    end

    response_body = String(response.body)
    response_json = JSON.parse(response_body)

    # Check for bad requests
    if !haskey(response_json["BEAAPI"], "Results")
        if haskey(response_json["BEAAPI"], "Error")
            error(string(response_json["BEAAPI"]["Error"]["APIErrorDescription"]),
                " ", response_json["BEAAPI"]["Error"]["ErrorDetail"]["Description"])
        end
    elseif haskey(response_json["BEAAPI"]["Results"], "Error")
        error(response_json["BEAAPI"]["Results"]["Error"]["APIErrorDescription"])
    end

    return response_json["BEAAPI"]["Results"]
end

"""
    bea_datasets(;user_id::String = USER_ID) -> DataFrame

Return a `DataFrame` of names and descriptions for datasets accessible through the BEA data API.

Example:
```julia
# User ID stored in ~/.beadatarc
julia> bea_datsets();

julia> show(ans[1:3, :])
3×2 DataFrames.DataFrame
│ Row │ DatasetName        │ Description                          │
│     │ String             │ String                               │
├─────┼────────────────────┼──────────────────────────────────────┤
│ 1   │ NIPA               │ Standard NIPA tables                 │
│ 2   │ NIUnderlyingDetail │ Standard NI underlying detail tables │
│ 3   │ MNE                │ Multinational Enterprises            │
```
"""
function bea_datasets(;user_id = USER_ID)
    # These datasets are deprecated by BEA, though still show up in requests
    excluded_sets = ["RegionalData", "RegionalIncome", "RegionalProduct",
        "APIDatasetMetaData"]

    api_method = "GetDatasetList"

    querydict = Dict("UserID" => user_id,
                     "Method" => api_method,
                     "ResultFormat" => "JSON")

    r_json = bea_query(API_URL, querydict)
    r_dict = r_json["Dataset"]

    ids = [d["DatasetName"] for d in r_dict if d["DatasetName"] ∉ excluded_sets]
    descriptions = [d["DatasetDescription"] for d in r_dict if d["DatasetName"] ∉ excluded_sets]

    return DataFrame(DatasetName = ids, Description = descriptions)
end

"""
    bea_parameterlist(dataset::String; user_id = USER_ID) -> DataFrame

Return a `DataFrame` of parameter names and attributes for `dataset`.

Example:
```julia
# User ID stored in ~/.beadatarc
julia> bea_parameterlist("NIPA")
5×3 DataFrames.DataFrame. Omitted printing of 1 columns
│ Row │ ParameterName │ ParameterDescription                                           │
│     │ String        │ String                                                         │
├─────┼───────────────┼────────────────────────────────────────────────────────────────┤
│ 1   │ Frequency     │ A - Annual, Q-Quarterly, M-Monthly                             │
│ 2   │ ShowMillions  │ A flag indicating that million-dollar data should be returned. │
│ 3   │ TableID       │ The standard NIPA table identifier                             │
│ 4   │ TableName     │ The new NIPA table identifier                                  │
│ 5   │ Year          │ List of year(s) of data to retrieve (X for All)                │
```
"""
function bea_parameterlist(dataset::String; user_id = USER_ID)

    api_method = "GetParameterList"

    querydict = Dict("UserID" => user_id,
                     "Method" => api_method,
                     "DatasetName" => dataset,
                     "ResultFormat" => "JSON")

    r_json = bea_query(API_URL, querydict)
    r_dict = r_json["Parameter"]

    nparams = length(r_dict)
    parameter_id = Array{String}(undef, nparams)
    parameter_desc = Array{String}(undef, nparams)
    parameter_req = Array{String}(undef, nparams)
    for i = 1:nparams
        parameter_id[i] = r_dict[i]["ParameterName"]
        parameter_desc[i] = r_dict[i]["ParameterDescription"]
        parameter_req[i] = r_dict[i]["ParameterIsRequiredFlag"] == "1" ? "Yes" : "No"
    end

    return DataFrame(ParameterName = parameter_id, ParameterDescription = parameter_desc,
        ParamaterRequired = parameter_req)
end

"""
    bea_parametervalues(dataset::String, param_name:: String;
        user_id = USER_ID) -> DataFrame

Return a `DataFrame` of permissible values for `param_name`, with descriptions.

Example:
```julia
# User ID stored in ~/.beadatarc
julia> bea_parametervalues("NIPA", "TableName");

julia> show(ans[1:3, :])
3×2 DataFrame
│ Row │ Value  │ Description                                                                              │
│     │ String │ String                                                                                   │
├─────┼────────┼──────────────────────────────────────────────────────────────────────────────────────────┤
│ 1   │ T10101 │ Table 1.1.1. Percent Change From Preceding Period in Real Gross Domestic Product (A) (Q) │
│ 2   │ T10102 │ Table 1.1.2. Contributions to Percent Change in Real Gross Domestic Product (A) (Q)      │
│ 3   │ T10103 │ Table 1.1.3. Real Gross Domestic Product, Quantity Indexes (A) (Q)                       │

```
"""
function bea_parametervalues(dataset::String, param_name:: String; user_id = USER_ID)

    no_year = ["NIPA", "NIUnderlyingDetail", "FixedAssets", "GDPbyIndustry"]
    no_table_id = ["NIPA", "NIUnderlyingDetail"]
    no_frequency = ["UnderlyingGDPbyIndustry"]

    if  (param_name == "Year" && dataset ∈ no_year) ||
        (param_name == "TableID" && dataset ∈ no_table_id) ||
        (param_name == "Frequency" && dataset ∈ no_frequency)
        error("Parameter $param_name in dataset $dataset not supported.")
    end

    api_method = "GetParameterValues"

    querydict = Dict("UserID" => user_id,
                     "Method" => api_method,
                     "DatasetName" => dataset,
                     "ParameterName" => param_name,
                     "ResultFormat" => "JSON")

    r_json = bea_query(API_URL, querydict)
    r_dict = r_json["ParamValue"]

    nvalues = length(r_dict)
    param_vals = Array{String}(undef, nvalues)
    param_desc = Array{String}(undef, nvalues)

    k = if in(param_name, keys(r_dict[1]))
        param_name
    elseif in("Key", keys(r_dict[1]))
        "Key"
    elseif in("key", keys(r_dict[1]))
        "key"
    else
        param_name * "ID"
    end

    desc = if in("Description", keys(r_dict[1]))
        "Description"
    elseif in("Desc", keys(r_dict[1]))
        "Desc"
    elseif in("Descr", keys(r_dict[1]))
        "Descr"
    else
        "desc"
    end

    for i in 1:nvalues
        param_vals[i] = r_dict[i][k]
        param_desc[i] = r_dict[i][desc]
    end

    return DataFrame(Value = param_vals, Description = param_desc)
end
