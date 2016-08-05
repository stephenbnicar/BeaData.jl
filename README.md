# BeaData

[![Build Status](https://travis-ci.org/sbnicar/BeaData.jl.svg?branch=master)](https://travis-ci.org/sbnicar/BeaData.jl)

A Julia interface for retrieving data from the U.S. Bureau of Economic Analysis (BEA)
Data API.

A valid registration key is *required* to use the BEA's API. A key can be obtained by registering [here](http://www.bea.gov/API/signup/index.cfm).

## Installation

BeaData is not yet a registered package, so install using:

```julia
    Pkg.clone("https://github.com/sbnicar/BeaData")
```

## Usage

Currently, the package only retrieves full tables from the standard National
Income and Product Accounts (NIPA) (i.e., no downloads of single data series or
    from other datasets such as the International Transactions Accounts).

Initialize a connection to the BEA API:

```julia
   b = Bea("your-36-character-registration-key")
```
Alternatively, you can save your key in the file `~/.beadatarc` and call the constructor
with no argument:

```julia
    b = Bea()
```
Download a NIPA table using the `get_nipa_table` method:

```julia
   mytable = get_nipa_table(b::Bea, TableID::Int, frequency::AbstractString,
        startyear::Int, endyear::Int)
```

Arguments:
* `b`: a BEA API connection
* `TableID`: the integer Table ID for the desired NIPA table
* `frequency`: "A" for annual, "Q" for quarerly
* `startyear`: first year of data requested, in YYYY format
* `endyear`: last year of data requested, in YYYY format

The method returns an object of type `BeaNipaTable`, with the following fields:
* `tablenum`: Table number
* `tabledesc`: Table description
* `linedesc`: an `OrderedDict` with table line numbers and the corresponding variable descriptions
* `tablenotes`: an `OrderedDict` with any notes to the table
* `frequency`
* `startyear`
* `endyear`
* `df`: a `DataFrame` containing the data values; column names are the line numbers from the table

## Note
All requests to the BEA API currently throw an `HTTP Parser Exception`.  This appears
**not** to be a client-side issue, but caused rather by the data returned by the BEA
server (a similar error occurs when using R).

# Disclaimer
BeaData is not affiliated with, officially maintained, or otherwise supported by the Bureau of Economic Analysis.
