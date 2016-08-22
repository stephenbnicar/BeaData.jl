# Package Guide

For now, the package only retrieves full tables from the standard National
Income and Product Accounts (NIPA) (i.e., no downloads of single data series or
    from other datasets such as the International Transactions Accounts).

## Initialize a connection

Initialize a connection to the BEA API:

```julia
   b = Bea("your-36-character-registration-key")
```
Alternatively, you can save your key in the file `~/.beadatarc` and call the constructor
with no argument:

```julia
    b = Bea()
```

## Retrieve a table

Download a NIPA table using the `get_nipa_table` method:

```julia
   mytable = get_nipa_table(b::Bea, TableID::Int, frequency::AbstractString,
        startyear::Int, endyear::Int)
```

Arguments:

* `b`: a BEA API connection
* `TableID`: the integer Table ID for the desired NIPA table (see "NIPA Table IDs" below)
* `frequency`: "A" for annual, "Q" for quarerly
* `startyear`: first year of data requested, in YYYY format
* `endyear`: last year of data requested, in YYYY format

The method returns an object of type `BeaNipaTable`, with the following fields:

* `tablenum`: Table number
* `tableid`: Table ID
* `tabledesc`: Table description
* `linedesc`: an `OrderedDict` with table line numbers and the corresponding variable descriptions
* `tablenotes`: an `OrderedDict` with any notes to the table
* `frequency`
* `startyear`
* `endyear`
* `df`: a `DataFrame` containing the data values; column names are the line numbers from the table (see "NIPA Table line numbers" below)

## NIPA Table IDs

The `TableID`s necessary to retrieve data from the API are not the same as the NIPA
table numbers, and they are not listed anywhere (that I've found) on the BEA's website.
I've provided a function that will retrieve the full list of `TableID` values and their
corresponding table numbers and descriptions and write them to a .tex file.

Once a BEA API connection has been initialized, the function
```julia
    nipa_metadata_tex(b::Bea)
```
will write a file named "NipaMetadata.tex" to the current working directory.

## NIPA Table line numbers

The data frame returned by a call to the API has dates in the first column and
the table data in the remaining columns.  Data columns are named for the corresponding
line numbers of the NIPA table.  

Once a table has been retrieved, the function
```julia
    table_metadata_tex(bnt::BeaNipaTable)
```
will write a .tex file to the current working directory that contains the table name and description, line numbers and descriptions, and table notes.
