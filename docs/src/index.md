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

This package currently only works with the following BEA datasets (descriptions
    are taken from the BEA website):
* `NIPA`: National Income and Product Accounts, which "provide a comprehensive picture of the U.S. economy and feature many macroeconomic statistics."
* `NIUnderlyingDetail`: "[D]etailed estimates of underlying NIPA series that appear regularly in the national income and product account (NIPA) tables[.]"
* `FixedAssets`: "[S]tatistics on both fixed assets, which are used continuously in processes of production for an extended period of time, and consumer durables, which are generally defined as tangible products that can be stored or inventoried and that have an average life of at least three years."

## API Request Limits

The BEA imposes the following limits on calls to the API:
* a maximum of 100 requests per minute, and/or
* a maximum of 100 MB retrieved per minute (100 MB), and/or
* a maximum of 30 errors per minute.

If you exceed these limits you will be blocked from accessing the API for 1 hour.
This package does not provide any warning if you're approaching these limits; it
is up to the user to monitor their usage.

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
