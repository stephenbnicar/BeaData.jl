using BeaData
using Base.Test

b = Bea()
parameter_list = get_bea_parameterlist(b, "NIPA")
nipatable = get_nipa_table(b, 5, "Q", 2014, 2014)
