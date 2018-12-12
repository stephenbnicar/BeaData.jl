# BeaData

*A Julia interface for retrieving data from the U.S. Bureau of Economic Analysis (BEA)
Data API.*

|**Repo Status**| **Build Status** | **Coverage** |
|:-------------:|:----------------:|:------------:|
|[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.][repo-img]][repo-url] | [![][travis-img]][travis-url] [![AppVeyor][appveyor-img]][appveyor-url] | [![codecov.io][codecov-img]][codecov-url] |


## Installation

At the Julia REPL:

```julia
    (v1.0) pkg> add BeaData
```
## Usage

A valid registration key is required to use the BEA's API. A key can be obtained by registering [here](http://www.bea.gov/API/signup/index.cfm).

For now, the package only retrieves full tables from the standard National
Income and Product Accounts (NIPA) (i.e., no downloads of individual data series or
    from other BEA datasets).

### Initialize a connection

Initialize a connection to the BEA API:

```julia
b = Bea("your-36-character-registration-key")
```
Alternatively, you can save your key in the file `~/.beadatarc` and call the constructor
with no argument:

```julia
b = Bea()
```

### Retrieve a table

Download a NIPA table using the `get_nipa_table` method:

```julia
mytable = get_nipa_table(b::Bea, TableName::AbstractString, frequency::AbstractString,
    startyear::Int, endyear::Int)
```

Arguments:

* `b`: a `Bea` connection
* `TableName`: the string TableName for the desired NIPA table (see "NIPA Table Names" below)
* `frequency`: "A" for annual, "Q" for quarerly
* `startyear`: first year of data requested, in YYYY format
* `endyear`: last year of data requested, in YYYY format

The method returns an object of type `BeaTable`, with the following fields:

* `tablenum`: Table number
* `tablename`: TableName
* `tabledesc`: Table description
* `linedesc`: an `OrderedDict` with table line numbers and the corresponding variable descriptions
* `tablenotes`: an `OrderedDict` with any notes to the table
* `frequency`
* `startyear`
* `endyear`
* `df`: a `DataFrame` containing the data values; column names are the line numbers from the table (see "NIPA Table line numbers" below)

### NIPA Table Names

The `TableName`s necessary to retrieve data from the API are not exactly the same as the NIPA
table numbers.  The general pattern for many tables is to replace the periods in the table number
with zeros and add "T" to the beginning. For example, the `TableName` for Table 1.1.5 is "T10105".
(this pattern does not hold for all tables, however, so check the BEA site).

## NIPA Table line numbers

The `DataFrame` returned by a call to the API has dates in the first column and
the table data in the remaining columns.  Data columns are named for the corresponding
line numbers of the NIPA table (e.g., `:line1`, `:line2`, etc.).

## Disclaimer
BeaData.jl is not affiliated with, officially maintained, or otherwise supported by the Bureau of Economic Analysis.

[docs-latest-img]: https://img.shields.io/badge/docs-latest-blue.svg
[docs-latest-url]: https://stephenbnicar.github.io/BeaData.jl/latest

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://stephenbnicar.github.io/BeaData.jl/stable

[travis-img]: https://travis-ci.org/stephenbnicar/BeaData.jl.svg?branch=master
[travis-url]: https://travis-ci.org/stephenbnicar/BeaData.jl

[appveyor-img]: https://ci.appveyor.com/api/projects/status/vs710r7oqax2b25m/branch/master?svg=true
[appveyor-url]: https://ci.appveyor.com/project/stephenbnicar/beadata-jl/branch/master

[codecov-img]: http://codecov.io/github/stephenbnicar/BeaData.jl/coverage.svg?branch=master
[codecov-url]: http://codecov.io/github/stephenbnicar/BeaData.jl?branch=master

[repo-img]: http://www.repostatus.org/badges/latest/active.svg
[repo-url]: http://www.repostatus.org/#active
