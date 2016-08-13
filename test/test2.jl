import BeaData
using DataFrames

x = BeaData.Bea()
# BeaData.nipa_metadata_tex(x)

TableID = 4
frequency = "Q"
startyear = 2014
endyear = 2014

z = BeaData.get_nipa_table(x, TableID, frequency, startyear, endyear)
# BeaData.table_metadata_tex(z)
