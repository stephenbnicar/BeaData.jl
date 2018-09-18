# BeaData

*A Julia interface for retrieving data from the U.S. Bureau of Economic Analysis (BEA)
Data API.*

|**Repo Status**|**Documentation** | **Build Status** | **Coverage** |
|:-------------:|:----------------:|:----------------:|:------------:|
|[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.][repo-img]][repo-url] | [![][docs-stable-img]][docs-stable-url] |  [![][travis-img]][travis-url] [![AppVeyor][appveyor-img]][appveyor-url] | [![codecov.io][codecov-img]][codecov-url] |


## Installation

At the Julia REPL:

```julia
    (v1.0) pkg> add BeaData
```
## Usage

See the [package documentation][docs-stable-url].

A valid registration key is required to use the BEA's API. A key can be obtained by registering [here](http://www.bea.gov/API/signup/index.cfm).

For now, the package only retrieves full tables from the standard National
Income and Product Accounts (NIPA) (i.e., no downloads of individual data series or
    from other BEA datasets).

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
