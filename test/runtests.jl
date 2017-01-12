using BeaData
using Base.Test
using Compat

b = Bea()
nipatable = get_nipa_table(b, 5, "Q", 2014, 2014)
