import Base: @deprecate

mutable struct Bea
    url::AbstractString
    key::AbstractString
end

function Bea()
    Base.depwarn("The `Bea` struct is deprected; " *
        "`key` is now autoloaded on package startup " *
        "or use `USER_ID = key`.", :Bea)
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

    return Bea(API_URL, key)
end

@deprecate Bea(key) USER_ID = key

function bea_query_dep(url, querydict)
    r = try
        HTTP.request("GET", url, query = querydict)
    catch e
        if isa(e, Base.IOError)
            println("Caught $e")
            HTTP.request("GET", url, query = querydict)
        else
            rethrow(e)
        end
    end
    r_body = String(r.body)
    r_json = JSON.parse(r_body)
    if haskey(r_json["BEAAPI"]["Results"], "Error")
        error(r_json["BEAAPI"]["Results"]["Error"]["APIErrorDescription"])
    end
    return r_json
end


function get_bea_datasets(b::Bea)
    Base.depwarn("`get_bea_datasets` is deprecated, use `bea_datasets` instead.",
        :get_bea_datasets)
    url = b.url
    key = b.key
    bea_method = "GetDataSetList"

    querydict = Dict("UserID" => key,
                     "Method" => bea_method,
                     "ResultFormat" => "JSON")

    response_json = bea_query_dep(url, querydict)
    response_dict = response_json["BEAAPI"]["Results"]["Dataset"]
    datasets = Dict(d["DatasetName"] => d["DatasetDescription"] for d in response_dict)

    return datasets
end

function get_bea_parameterlist(b::Bea, dataset::String)
    Base.depwarn("`get_bea_parameterlist` is deprecated, use `bea_parameterlist` instead.",
        :get_bea_parameterlist)
    url = b.url
    key = b.key
    bea_method = "GetParameterList"

    querydict = Dict("UserID" => key,
                     "Method" => bea_method,
                     "DatasetName" => dataset,
                     "ResultFormat" => "JSON")

    response_json = bea_query_dep(url, querydict)
    response_dict = response_json["BEAAPI"]["Results"]["Parameter"]

    return response_dict
end

function get_nipa_table(b::Bea, TableName::AbstractString, frequency::AbstractString, startyear::Int, endyear::Int)
    Base.depwarn("`get_nipa_table` is deprecated, use `bea_table` instead.",
        :bea_table)
    url = b.url
    key = b.key
    dataset = "NIPA"
    bea_method = "GetData"
    years = join(collect(startyear:1:endyear), ",")

    querydict = Dict("UserID" => key,
                     "Method" => bea_method,
                     "DatasetName" => dataset,
                     "TableName" => TableName,
                     "Frequency" => frequency,
                     "Year" => years,
                     "ResultFormat" => "JSON")

    response_json = bea_query(url, querydict)

    # Extract the vector of Dicts containing the data
    # data_dicts = response_json["BEAAPI"]["Results"]["Data"]
    data_dicts = response_json["Data"] # new format
    # Retrieve data from each Dict
    all_data = [parse_data_dict_dep(d) for d in data_dicts]
    values = [tup[1] for tup in all_data]
    dates = [tup[2] for tup in all_data]
    linenums = [tup[3] for tup in all_data]
    # Create data frame of values, reshape, and create names
    dflong = DataFrame(date = dates, line = linenums, value = values)
    df = unstack(dflong, :date, :line, :value) # Convert to "wide" format
    newnames = [Symbol(string("line", name)) for name in names(df)[2:end]]
    rename!(df, [:date; newnames])

    # Create OrderedDict of line descriptions
    linedesc = [tup[4] for tup in all_data]
    linekeys = OrderedDict{AbstractString, AbstractString}(zip(linenums, linedesc))

    # Extract metadata for the table
    # tablenotes = response_json["BEAAPI"]["Results"]["Notes"]
    tablenotes = response_json["Notes"]
    tableinfo = split(tablenotes[1]["NoteText"])
    tablenum = rstrip(tableinfo[2], '.')
    tabledesc = join(tableinfo[3:end], " ")
    if length(tablenotes) > 1
        noteref = [note["NoteRef"] for note in tablenotes[2:end]]
        notetext = [note["NoteText"] for note in tablenotes[2:end]]
        notes = OrderedDict{AbstractString, AbstractString}(zip(noteref, notetext))
    else
        notes = ""
    end

    frequency == "Q" ? freq = "Quarterly" : freq = "Annual"
    out = BeaTable("NIPA", tablenum, tabledesc, "", "", DataFrame(), DataFrame(),
        freq, startyear, endyear, TableName, "", df)
    return out
end

function parse_data_dict_dep(dict::Dict)
    linenum = dict["LineNumber"]
    linedesc = dict["LineDescription"]
    # Add footnote indicator to line description
    if haskey(dict, "NoteRef")
        fn = dict["NoteRef"]
        linedesc = string(linedesc, " (", fn, ")")
    end
    # Remove commas from data values
    dataval = parse(Float64, replace(dict["DataValue"], "," => ""))

    # Change date from string to Date() type
    timeperiod = dict["TimePeriod"]
    year = parse(Int, timeperiod[1:4])
    # Quarterly data
    if occursin(r"Q", timeperiod)
        quarter = parse(Int, timeperiod[end])
        date = Date(year, (quarter*3), 1)
    # Annual data
    else
        date = Date(year, 12, 1)
    end

    return (dataval, date, linenum, linedesc)
end
