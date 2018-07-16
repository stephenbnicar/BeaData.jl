"""
    get_nipa_table(b::Bea, TableName::AbstractString, frequency::AbstractString, startyear::Int, endyear::Int)

Request a NIPA table from the BEA data API and return an object of type [`BeaTable`](@ref).

Arguments
---------
* `b` -- a [`Bea`](@ref) connection
* `TableName` -- the Table Name (string) for the desired NIPA table
* `frequency` -- "A" for annual, "Q" for quarerly
* `startyear` -- first year of data requested, in YYYY format
* `endyear` -- last year of data requested, in YYYY format

"""
function get_nipa_table(b::Bea, TableName::AbstractString, frequency::AbstractString, startyear::Int, endyear::Int)
    url = b.url
    key = b.key
    dataset = "NIPA"
    bea_method = "GetData"
    years = join(collect(startyear:1:endyear), ",")

    query = string(url,
          "?&UserID=", key,
          "&method=", bea_method,
          "&DatasetName=", dataset,
          "&TableName=", TableName,
          "&Frequency=", frequency,
          "&Year=", years,
          "&ResultFormat=JSON&")

    response = HTTP.get(query)
    response_body = String(response.body)
    response_json = JSON.parse(response_body)

    if haskey(response_json["BEAAPI"], "Error")
        notes = response_json["BEAAPI"]["Error"]["ErrorDetail"]["Description"]
        linekeys = OrderedDict()
        df = DataFrame()
        out = BeaTable("", TableName, "", linekeys, notes, frequency, startyear, endyear, df)
    else
        # Extract the vector of Dicts containing the data
        data_dicts = response_json["BEAAPI"]["Results"]["Data"]
        # Retrieve data from each Dict
        all_data = [parse_data_dict(d) for d in data_dicts]
        values = [tup[1] for tup in all_data]
        dates = [tup[2] for tup in all_data]
        linenums = [tup[3] for tup in all_data]
        # Create data frame of values, reshape, and create names
        dflong = DataFrame(date = dates, line = linenums, value = values)
        df = unstack(dflong, :date, :line, :value) # Convert to "wide" format
        newnames = [Symbol(string("line", name)) for name in names(df)[2:end]]
        names!(df, [:date; newnames])

        # Create OrderedDict of line descriptions
        linedesc = [tup[4] for tup in all_data]
        linekeys = OrderedDict{AbstractString, AbstractString}(zip(linenums, linedesc))

        # Extract metadata for the table
        tablenotes = response_json["BEAAPI"]["Results"]["Notes"]
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
        out = BeaTable(tablenum, TableName, tabledesc, linekeys, notes, freq, startyear, endyear, df)
    end
    return out
end

"""
    parse_data_dict(dict::Dict)

Extract information for a single observation and return as a tuple.  (Internal method for [`get_nipa_table`](@ref).)
"""
function parse_data_dict(dict::Dict)
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
