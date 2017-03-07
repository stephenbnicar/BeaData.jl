# BeaData.jl

A Julia interface for retrieving data from the U.S. Bureau of Economic Analysis (BEA) Data API.

## Installation

At the Julia REPL:

```julia
    Pkg.add("BeaData")
```

## Usage

See the [Package Guide](@ref).

#### Known Issue
All requests by BeaData.jl to the BEA API currently throw an `HTTP Parser Exception`,
though this does not prevent the requested query from being completed successfully
as long as valid arguments are provided to the functions.  This is not a client-side issue, caused instead by an extra space character returned by the BEA server's response (thanks to  [@quinnj](https://github.com/quinnj) - Jacob Quinn - for figuring this out).  This will be fixed in a future update.


## Index

```@index
Pages = ["lib/public.md"]
```
