# BeaData.jl

## Installation

At the Julia REPL:

```julia
    (@v1.x) pkg> add BeaData
```
## Preliminaries

A valid User ID key is required to use the BEA's API. A User ID can be obtained by registering  at the BEA website: [https://apps.bea.gov/API/signup/index.cfm](https://apps.bea.gov/API/signup/index.cfm).

All metadata and data retrieval functions require your User ID key as a keyword argument. If you plan to use the package frequently, the most convenient option is store your User ID key in a file named `.beadatarc` in your home directory.  The package will look for this file on startup and will assign the key to the global variable `USER_ID` if it is present.

## Supported Datasets

This package currently only works with the BEA datasets that return tables (as opposed to individual data series): `NIPA`, `NIUnderlyingDetail`, and `FixedAssets`.

A full list of the datasets available through the BEA data API can be seen using the [`bea_datasets`](@ref) method described below.

## Retrieving a Table

```@docs
bea_table
```

```@docs
BeaTable
```
## Metadata Methods
```@docs
bea_datasets
bea_parameterlist
bea_parametervalues
```
