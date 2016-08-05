import BeaData

x = BeaData.Bea()
y = BeaData.nipa_metadata_tex(x)

TableID = "86"
frequency = "Q"
startyear = 2014
endyear = 2014
years = collect(startyear:1:endyear)

z = BeaData.get_nipa_table(x, TableID, frequency, startyear, endyear)
