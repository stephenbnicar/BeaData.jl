using Requests
using DataFrames

API_URL   = "https://www.bea.gov/api/data"
beadatarc = open(joinpath(homedir(),".beadatarc"), "r")
key = readstring(beadatarc)
close(beadatarc)
key = rstrip(key)

# Get list of datasets
querydict = Dict("UserID" => key,
                 "Method" => "GetDataSetList",
                 "ResultFormat" => "JSON")

response = get(API_URL; query = querydict)
response_json = Requests.json(response)
rdict = response_json["BEAAPI"]["Results"]["Dataset"]
dbid = String[]
dbdesc = String[]
for dict in rdict
    push!(dbid, dict["DatasetName"])
    push!(dbdesc, dict["DatasetDescription"])
end
datasets = DataFrame(dataset_id = dbid, dataset_desc = dbdesc)

# ds_dict = [d["DatasetName"] => d["DatasetDescription"] for d in rdict]
