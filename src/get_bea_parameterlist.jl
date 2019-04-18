"""
    get_bea_parameterlist(b::BeaData.Bea, dataset::String)

Return a `Dict` of parameters for `dataset`.

Arguments
---------
* `b` -- a [`Bea`](@ref) connection
* `dataset` -- String indicating the dataset ID.

"""
function get_bea_parameterlist(b::Bea, dataset::String)
    url = b.url
    key = b.key
    bea_method = "GetParameterList"

    querydict = Dict("UserID" => key,
                     "Method" => bea_method,
                     "DatasetName" => dataset,
                     "ResultFormat" => "JSON")

    response_json = bea_query(url, querydict)
    response_dict = response_json["BEAAPI"]["Results"]["Parameter"]
    
    return response_dict
end
