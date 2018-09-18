using BeaData
using Test

b = Bea()
dataset_list = get_bea_datasets(b)
parameter_list = get_bea_parameterlist(b, "NIPA")
nipatable = get_nipa_table(b, "T10105", "Q", 2014, 2014)
