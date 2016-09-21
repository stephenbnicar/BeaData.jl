"""
    `nipa_metadata_tex(b::Bea)`

Arguments
---------
* `b`: a BEA API connection

Returns
---------
* A .tex file with the parmater list for the NIPA dataset and parameter values for the TableID parameter.  The file is written to the curent working directory.
"""
function nipa_metadata_tex(b::Bea)
    url = api_url(b)
    key = api_key(b)
    bea_dataset = "NIPA"

    bea_method2 = "GetParameterList"
    query2 = Dict("UserID" => key,
                     "Method" => bea_method2,
                     "DatasetName" => bea_dataset)
    response2 = get(url; query = query2)
    response_json2 = Requests.json(response2)
    paramlist = response_json2["BEAAPI"]["Results"]["Parameter"]

    bea_method3 = "GetParameterValues"
    parameter_name = "TableID"
    query3 = Dict("UserID" => key,
                     "Method" => bea_method3,
                     "DatasetName" => bea_dataset,
                     "ParameterName" => parameter_name)
    response3 = get(url; query = query3)
    response_json3 = Requests.json(response3)
    paramvals = response_json3["BEAAPI"]["Results"]["ParamValue"]

    f = open("NipaMetadata.tex", "w") do f

        # preamble
        write(f, "\\documentclass[12pt]{article} \n")
        write(f, "\\usepackage[margin=1in]{geometry} \n")
        write(f, "\\usepackage{booktabs} \n")
        write(f, "\\usepackage{parskip} \n")
        write(f, "\\usepackage{longtable} \n")
        write(f, "\\usepackage{hyperref} \n")
        write(f, "\\begin{document} \n \n")
        write(f, "Date Created: \\today \n\n")

        # Table of NIPA Dataset parameters
        write(f, "\\section{Dataset Parameters: $bea_dataset}  \n")
        write(f, "\\begin{tabular}{lp{3.5in}} \n")
        write(f, "\\toprule \n")
        for param in paramlist
            write(f, string("Parameter Name: & \\verb|", param["ParameterName"], "| \\\\ \n"))
            for (key, value) in param
                key != "ParameterName" && write(f, string("\\hspace{1em} \\verb|", key, "| & ", value, " \\\\ \n"))
            end
            param != paramlist[end] && write(f, "\\midrule \n")
        end
        write(f, "\\bottomrule \n")
        write(f, "\\end{tabular} \n\n")
        write(f, "\\clearpage \n\n")

        # Table with parameter values for NIPA TableID
        write(f, "\\section{Parameter Values: $bea_dataset $parameter_name}  \n")
        write(f, "\\begin{longtable}{cp{5in}} \n")
        write(f, "\\toprule \n")
        write(f, "\\verb|TableID| & Description \\\\ \n")
        write(f, "\\midrule \\endhead \n")
        for val in paramvals
            write(f, "\\verb|", string(val["TableID"], "| & ", val["Description"], " \\\\ \n"))
        end
        write(f, "\\bottomrule \n")
        write(f, "\\end{longtable} \n\n")

        # end document
        write(f, "\\end{document} \n")
    end

end # function
