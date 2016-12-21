"""

$(SIGNATURES)

Return, in a `DataFrame`, a list of parameter IDs and descriptions for `dataset`.

Arguments
---------
* `b` -- a [`Bea`](@ref) connection
* `dataset` -- String indicating the dataset ID.

"""
function get_bea_parameterlist(b::BeaData.Bea, dataset::String)
    url = b.url
    key = b.key
    bea_method = "GetParameterList"

    querydict = Dict("UserID" => key,
                     "Method" => bea_method,
                     "DatasetName" => dataset,
                     "ResultFormat" => "JSON")

    response = get(url; query = querydict)
    response_json = Requests.json(response)
    response_dict = response_json["BEAAPI"]["Results"]["Parameter"]

    parameter_id = String[]
    parameter_desc = String[]
    for dict in response_dict
        push!(parameter_id, dict["ParameterName"])
        push!(parameter_desc, dict["ParameterDescription"])
    end
    parameter_list = DataFrame(parameter_id = parameter_id, parameter_description = parameter_desc)

    return parameter_list
end
