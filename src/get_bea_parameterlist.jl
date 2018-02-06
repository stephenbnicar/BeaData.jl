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

    query = string(url,
                "?&UserID=", key,
                "&method=", bea_method,
                "&DatasetName=", dataset,
                "&ResultFormat=JSON&")

    response = HTTP.get(query)
    response_body = String(response.body)
    response_json = JSON.parse(response_body)
    response_dict = response_json["BEAAPI"]["Results"]["Parameter"]

    # parameter_id = String[]
    # parameter_desc = String[]
    # parameter_req = String[]
    # default_value = String[]
    # for dict in response_dict
    #     push!(parameter_id, dict["ParameterName"])
    #     push!(parameter_desc, dict["ParameterDescription"])
    #     push!(parameter_req, dict["ParameterIsRequiredFlag"])
    #     if haskey(dict, "ParameterDefaultValue")
    #         push!(default_value, dict["ParameterDefaultValue"])
    #     else
    #         push!(default_value, "")
    #     end
    # end
    # parameter_list = DataFrame(parameter_id = parameter_id, parameter_description = parameter_desc,
    #                             required = parameter_req, default_value = default_value)

    return response_dict
end
