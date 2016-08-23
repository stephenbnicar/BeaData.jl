# BeaData

[![Build Status](https://travis-ci.org/stephenbnicar/BeaData.jl.svg?branch=master)](https://travis-ci.org/stephenbnicar/BeaData.jl)
[![BeaData](http://pkg.julialang.org/badges/BeaData_0.4.svg)](http://pkg.julialang.org/?pkg=BeaData)
[![BeaData](http://pkg.julialang.org/badges/BeaData_0.5.svg)](http://pkg.julialang.org/?pkg=BeaData)
[![](https://img.shields.io/badge/docs-stable-blue.svg)](https://stephenbnicar.github.io/BeaData.jl/stable)
[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://stephenbnicar.github.io/BeaData.jl/latest)


A Julia interface for retrieving data from the U.S. Bureau of Economic Analysis (BEA)
Data API.

## Installation

At the Julia REPL:

```julia
    Pkg.add("BeaData")
```

## Usage

See the [package documentation](https://stephenbnicar.github.io/BeaData.jl/latest).

A valid registration key is required to use the BEA's API. A key can be obtained by registering [here](http://www.bea.gov/API/signup/index.cfm).

For now, the package only retrieves full tables from the standard National
Income and Product Accounts (NIPA) (i.e., no downloads of single data series or
    from other datasets such as the International Transactions Accounts).


## Known Issue
All requests to the BEA API currently throw an `HTTP Parser Exception`,
though this does not prevent the requested query from being completed successfully
as long as valid arguments are provided to the functions.  This appears **not**
to be a client-side issue, caused instead (as far as I've been able to determine)
by some superfluous data returned by the BEA server -- a similar error occurs when using R.

## Disclaimer
BeaData is not affiliated with, officially maintained, or otherwise supported by the Bureau of Economic Analysis.
