function get_bea_datasets(b::Bea)
    url = b.url
    key = b.key
    bea_method = "GetDataSetList"

    querydict = Dict("UserID" => key,
                     "Method" => bea_method,
                     "ResultFormat" => "JSON")

    response = get(url; query = querydict)
    response_json = Requests.json(response)
    rdict = response_json["BEAAPI"]["Results"]["Dataset"]
    dbid = String[]
    dbdesc = String[]
    for dict in rdict
        push!(dbid, dict["DatasetName"])
        push!(dbdesc, dict["DatasetDescription"])
    end
    datasets = DataFrame(dataset_id = dbid, dataset_description = dbdesc)

    return datasets
end
