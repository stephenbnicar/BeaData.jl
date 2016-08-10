function table_metadata_tex(bnt::BeaNipaTable)
    tablenum = bnt.tablenum
    tableid = bnt.tableid
    tabledesc = bnt.tabledesc
    linedesc = bnt.linedesc
    tabnotes = bnt.tablenotes

    tablename = DataFrames.makeidentifier(string("nipa", tablenum))
    fname = string(tablename, ".tex")

    f = open(fname, "w") do f
        write(f, "\\begin{longtable}{lp{5in}} \n")
        write(f, "\\toprule \n")
        write(f, string("Table & ", tablenum, " \\\\ \n"))
        write(f, string("Table ID & ", tableid, " \\\\ \n"))
        write(f, string("Description & ", tabledesc, " \\\\ \n"))
        write(f, "\\midrule \n")
        write(f, "Line No. & Description \\\\ \n")
        write(f, "\\midrule \\endhead \n")
        for (k, v) in zip(keys(linedesc), values(linedesc))
            write(f, string(k, " & ", v, " \\\\ \n"))
        end
        if tabnotes != ""
            write(f, "& \\\\ \n")
            write(f, "\\midrule \n")
            write(f, "Note & Description \\\\ \n")
            write(f, "\\midrule \n")
            for (k, v) in zip(keys(tabnotes), values(tabnotes))
                write(f, string(k, " & ", v, " \\\\ \n"))
            end
        end
        write(f, "\\bottomrule \n")
        write(f, "\\end{longtable} \n\n")
    end
end
