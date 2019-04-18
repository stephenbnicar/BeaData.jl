function bea_query(url, querydict)
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


"""
    get_bea_datasets(b::Bea)

Return a `Dict` of dataset names and descriptions.

Arguments
---------
* `b` -- a [`Bea`](@ref) connection

"""
function get_bea_datasets(b::Bea)
    url = b.url
    key = b.key
    bea_method = "GetDataSetList"

    querydict = Dict("UserID" => key,
                     "Method" => bea_method,
                     "ResultFormat" => "JSON")

    response_json = bea_query(url, querydict)
    response_dict = response_json["BEAAPI"]["Results"]["Dataset"]
    datasets = Dict(d["DatasetName"] => d["DatasetDescription"] for d in response_dict)

    return datasets
end
