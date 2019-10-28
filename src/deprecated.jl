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
