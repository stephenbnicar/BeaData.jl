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

Download a NIPA table using the [`get_nipa_table`](@ref) method:

```julia
   mytable = get_nipa_table(b::Bea, TableName::AbstractString, frequency::AbstractString,
        startyear::Int, endyear::Int)
```

Arguments:

* `b`: a [`Bea`](@ref) connection
* `TableName`: the string TableName for the desired NIPA table (see "NIPA Table Names" below)
* `frequency`: "A" for annual, "Q" for quarerly
* `startyear`: first year of data requested, in YYYY format
* `endyear`: last year of data requested, in YYYY format

The method returns an object of type [`BeaTable`](@ref), with the following fields:

* `tablenum`: Table number
* `tablename`: TableName
* `tabledesc`: Table description
* `linedesc`: an `OrderedDict` with table line numbers and the corresponding variable descriptions
* `tablenotes`: an `OrderedDict` with any notes to the table
* `frequency`
* `startyear`
* `endyear`
* `df`: a `DataFrame` containing the data values; column names are the line numbers from the table (see "NIPA Table line numbers" below)

## NIPA Table Names

The `TableName`s necessary to retrieve data from the API are not exactly the same as the NIPA
table numbers.  The general pattern for many tables is to replace the periods in the table number
with zeros and add "T" to the beginning. For example, the `TableName` for Table 1.1.5 is "T10105".
This pattern does not hold for all tables, however, so use the [`get_bea_parameterlist`](@ref)
function to retreive a `Dict` of `TableNames` and descriptions.

## NIPA Table line numbers

The `DataFrame` returned by a call to the API has dates in the first column and
the table data in the remaining columns.  Data columns are named for the corresponding
line numbers of the NIPA table (e.g., `:line1`, `:line2`, etc.).  
