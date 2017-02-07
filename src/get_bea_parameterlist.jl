"""

$(SIGNATURES)

Return, in a `DataFrame`, a list of parameters for `dataset`.

Arguments
---------
* `b` -- a [`Bea`](@ref) connection
* `dataset` -- String indicating the dataset ID.

Returns
----
A `DataFrame` listing the following:
* Parameter ID
* Parmameter description
* `required` -- 1 for yes, 0 for no
* `default_value` -- empty if none
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
    parameter_req = String[]
    default_value = String[]
    for dict in response_dict
        push!(parameter_id, dict["ParameterName"])
        push!(parameter_desc, dict["ParameterDescription"])
        push!(parameter_req, dict["ParameterIsRequiredFlag"])
        push!(default_value, dict["ParameterDefaultValue"])
    end
    parameter_list = DataFrame(parameter_id = parameter_id, parameter_description = parameter_desc,
                                required = parameter_req, default_value = default_value)

    return parameter_list
end
