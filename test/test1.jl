using Requests
# Required parameters for NIPA dataset
url = "http://www.bea.gov/api/data"
key = "4FA1AD1D-5522-4FDF-B275-6B429A2148E4"
bea_method = "GetParameterValues"
bea_dataset = "NIPA"
parameter_name = "TableID"
querydict = Dict("UserID" => key,
                 "Method" => bea_method,
                 "DatasetName" => bea_dataset,
                 "ParameterName" => parameter_name)
a = get(url; query = querydict)
b = Requests.json(a)
paramvals = b["BEAAPI"]["Results"]["ParamValue"]
