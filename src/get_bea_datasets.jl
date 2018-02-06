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

    query = string(url,
                   "?&UserID=", key,
                   "&method=", bea_method,
                   "&ResultFormat=JSON&")

    response = HTTP.get(query)
    response_body = String(response.body)
    response_json = JSON.parse(response_body)
    response_dict = response_json["BEAAPI"]["Results"]["Dataset"]
    datasets = Dict(d["DatasetName"] => d["DatasetDescription"] for d in response_dict)

    return datasets
end
