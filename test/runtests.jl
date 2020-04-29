using BeaData
using Test

@testset "metadata methods" begin
    ds = bea_datasets()
    @test "NIPA" ∈ ds[!, :DatasetName]

    pl = bea_parameterlist("FixedAssets")
    @test "TableName" ∈ pl[!, :ParameterName]

    pv = bea_parametervalues("NIUnderlyingDetail", "TableName")
    @test "U001A" ∈ pv[!, :Value]
end

@testset "data retrieval" begin
    nipa111 = bea_table("NIPA", "T10101", "A", 0 , 0)
    @test typeof(nipa111) <: BeaTable

    ud1a = bea_table("NIUnderlyingDetail", "U001A", "Q", 1996, 1996)
    @test typeof(ud1a) <: BeaTable

    faat101 = bea_table("FixedAssets", "FAAt101", "A", 0, 0)
    @test typeof(faat101) <: BeaTable
end

@testset "deprecated methods" begin
    b = Bea()
    dataset_list = get_bea_datasets(b)
    @test haskey(dataset_list, "NIPA")
    parameter_list = get_bea_parameterlist(b, "NIPA")
    @test typeof(parameter_list[1]) <: Dict
    nipatable = get_nipa_table(b, "T10105", "Q", 2014, 2014)
    @test typeof(nipatable) <: BeaTable
end
