"""
    bea_table(dataset::String, table_name::String, frequency::String,
        startyear::Int, endyear::Int; user_id = USER_ID) -> BeaTable

Return a [`BeaTable`](@ref) with data and metadata for `table_name`.  Pass
integer value `0` for both `startyear` and `endyear` to retrieve all available years for
the table. The data values are returned in a `DataFrame` accessed through the
`data_values` field of the `BeaTable` struct.

Example:
```julia
# User ID stored in ~/.beadatarc
julia> nipa116 = bea_table("NIPA", "T10106", "Q", 2015, 2018)
BEA Table
Dataset:   NIPA
Table No.: 1.1.6
Title:     Real Gross Domestic Product, Chained Dollars
Metric:    Chained Dollars
Units:     Billions of chained (2012) dollars
Frequency: Q
Dates:     2015 - 2018
Revised:   August 29, 2019
```
"""
function bea_table(dataset::String, table_name::String, frequency::String,
    startyear::Int, endyear::Int; user_id = USER_ID)

    supported = ["NIPA", "NIUnderlyingDetail", "FixedAssets"]
    if dataset ∉ supported
        error("Dataset $dataset not supported.")
    end

    api_method = "GetData"
    years = (startyear == 0 && endyear == 0) ? "X" : join(collect(startyear:1:endyear), ",")

    querydict = Dict("UserID" => user_id,
                     "Method" => api_method,
                     "DatasetName" => dataset,
                     "TableName" => table_name,
                     "Frequency" => frequency,
                     "Year" => years,
                     "ResultFormat" => "JSON")

     r_json = bea_query(API_URL, querydict)
     data_dicts = r_json["Data"]
     table_notes_dict = r_json["Notes"]

    # Extract metadata for the table
    tablenum, tabledesc, title_units, notes, api_tablename, last_revised =
        parse_table_metadata(table_notes_dict)
    api_units  = data_dicts[1]["CL_UNIT"]
    metric = data_dicts[1]["METRIC_NAME"]
    units = api_units == "Level" ? title_units : api_units
    unit_mult = data_dicts[1]["UNIT_MULT"]

    # Extract the data
    all_data = [parse_data_dict(d) for d in data_dicts]
    linenums = [tup[1] for tup in all_data]
    linenums = [length(num) == 1 ? "0"*num : num for num in linenums]
    varnames = [tup[2] for tup in all_data]
    sercodes = [tup[3] for tup in all_data]
    dates    = [tup[4] for tup in all_data]
    actual_start = Dates.year(dates[1])
    actual_end   = Dates.year(dates[end])

    # Resolve difference in reported units and actual units:
    # billions vs. millions
    datavals = [tup[5] for tup in all_data]
    if unit_mult == "6" && occursin("Billions", units)
        datavals ./= 1000
    end

    dflong = DataFrame(TimePeriod = dates, LineNumber = linenums, value = datavals)
    # Convert to "wide" format: unstack(dfname, :id, :variable, :value)
    # - :id identifies the rows (here it's the date)
    # - :variable identifies what will become columns (here, the line number)
    # - :value identifies the data values
    dfwide = unstack(dflong, :TimePeriod, :LineNumber, :value)
    newnames = [Symbol(string("Line", name)) for name in names(dfwide)[2:end]]
    rename!(dfwide, [:TimePeriod; newnames])

    linekeys = unique(DataFrame(LineNumber = linenums, SeriesCode = sercodes,
        LineDescription = varnames))

    return BeaTable(dataset, tablenum, tabledesc, metric, units, linekeys,
        notes, frequency, actual_start, actual_end, api_tablename, last_revised, dfwide)
end

function parse_table_metadata(d)
    tableinfo = d[1]["NoteText"]
    m1 = match(r"\s(?<tablenum>.*)\.\s", tableinfo)
    tablenum = m1[:tablenum] != nothing ? String(m1[:tablenum]) : ""
    m2 = match(r"\.\s(?<tabledesc>.*)\s\[", tableinfo)
    m2 = m2 == nothing ? match(r"\.\s(?<tabledesc>.*)\s\-", tableinfo) : m2
    tabledesc = m2 != nothing ? String(m2[:tabledesc]) : ""
    m3 = match(r"\[(?<units>.*)\]", tableinfo)
    title_units = m3 != nothing ? String(m3[:units]) : ""
    m4 = match(r"(?=LastRevised: (?<revised>.*))", tableinfo)
    last_revised = m4 != nothing ? m4[:revised] : ""

    api_tablename = d[1]["NoteRef"]

    noteref = [note["NoteRef"] for note in d]
    notetext = [note["NoteText"] for note in d]
    notes = DataFrame(noteref = noteref, notetext = notetext)

    return tablenum, tabledesc, title_units, notes, api_tablename, last_revised
end

function parse_data_dict(d::Dict)
    #-Line number and variable name
    linenum = d["LineNumber"]
    varname = d["LineDescription"]
    seriescode = d["SeriesCode"]
    # Add footnote indicator to varname if present
    if haskey(d, "NoteRef")
        fn = d["NoteRef"]
        varname = string(varname, " (", fn, ")")
    end

    #--Get the date of the observation--#
    # Convert from String to Date() type
    timeperiod = d["TimePeriod"]
    obs_year = parse(Int, timeperiod[1:4])
    #- Monthly data
    if occursin("M", timeperiod)
        obs_month = parse(Int, timeperiod[6:end])
        date  = Date(obs_year, obs_month, 1)
    #- Quarterly data
    elseif occursin("Q", timeperiod)
        obs_quarter = parse(Int, timeperiod[end])
        date = Date(obs_year, (obs_quarter*3), 1)
    #- Annual data
    else
        date = Date(obs_year, 12, 1)
    end

    #-Get data value-#
    # Remove commas and convert to float
    dataval = parse(Float64, replace(d["DataValue"], "," => ""))

    return (linenum, varname, seriescode, date, dataval)
end


"""
s   truct BeaTable

A BEA table with data and metadata returned from a [`bea_table`](@ref) call.

Fields
------
* `dataset`: dataset the table was retrieved from
* `table_number`: the non-API table number
* `table_description`: description of the data contained in the table
* `metric`: measurement metric for the data, e.g. index, dollars, etc.
* `units`: billions, millions, etc.
* `line_descriptions`: `DataFrame` containing line number descriptions
* `table_notes`: `DataFrame` containing any notes for the table
* `frequency`: (M)onthly, (Q)uarterly, or (A)nnual
* `data_startyear`: first year of data returned (may differ from what was requested)
* `data_endyear`: last year of data returned (may differ from what was requested)
* `api_tablename`: `table_name` parameter value for the table
* `last_revised`: date the table was last revised
* `data_values`: `DataFrame` containing the table data values
"""
struct BeaTable
    dataset::String
    table_number::String
    table_description::String
    metric::String
    units::String
    line_descriptions::DataFrame
    table_notes::DataFrame
    frequency::String
    data_startyear::Int
    data_endyear::Int
    api_tablename::String
    last_revised::String
    data_values::DataFrame
end

function Base.show(io::IO, b::BeaTable)
    println(io, "BEA Table")
    println(io, "Dataset:     $(b.dataset)")
    println(io, "Table No.:   $(b.table_number)")
    println(io, "Description: $(b.table_description)")
    println(io, "Metric:      $(b.metric)")
    println(io, "Units:       $(b.units)")
    println(io, "Frequency:   $(b.frequency)")
    println(io, "Dates:       $(b.data_startyear) - $(b.data_endyear)")
    println(io, "Revised:     $(b.last_revised)")
end

struct BeaDataError
    dataset::String
    api_tablename::String
    frequency::String
    startyear::Int
    endyear::Int
    emsg::String
end

function Base.show(io::IO, b::BeaDataError)
    println(io, "BEA Data Error")
    println(io, "$(b.emsg)")
    println(io, "Dataset:   $(b.dataset)")
    println(io, "TableName: $(b.api_tablename)")
    println(io, "Frequency: $(b.frequency)")
    println(io, "Dates:     $(b.startyear) - $(b.endyear)")
end
