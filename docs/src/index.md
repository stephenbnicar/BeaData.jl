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
All requests to the BEA API currently throw an `HTTP Parser Exception`,
though this does not prevent the requested query from being completed successfully
as long as valid arguments are provided to the functions.  This appears **not**
to be a client-side issue, caused instead (as far as I've been able to determine)
by some superfluous data returned by the BEA server -- a similar error occurs when using R.


## Index

```@index
Pages = ["lib/public.md"]
```
