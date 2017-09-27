# uCSV.jl

[![Build Status](https://travis-ci.org/cjprybol/uCSV.jl.svg?branch=master)](https://travis-ci.org/cjprybol/uCSV.jl)
[![Build status](https://ci.appveyor.com/api/projects/status/re2a08kgjfserv6x/branch/master?svg=true)](https://ci.appveyor.com/project/cjprybol/ucsv-jl/branch/master)
[![Coverage Status](https://coveralls.io/repos/github/cjprybol/uCSV.jl/badge.svg?branch=master)](https://coveralls.io/github/cjprybol/uCSV.jl?branch=master)
[![codecov.io](http://codecov.io/github/cjprybol/uCSV.jl/coverage.svg?branch=master)](http://codecov.io/github/cjprybol/uCSV.jl?branch=master)

## Getting Started

First, Install the package
```julia
Pkg.clone("https://github.com/cjprybol/uCSV.jl")
```

Then head on over to the [![](https://img.shields.io/badge/docs-latest-blue.svg)](https://cjprybol.github.io/uCSV.jl/latest)!

## Why uCSV?

**Spend less time fighting your dataset and more time analyzing it**

Package goals:

1. The documentation and examples should be thorough enough that you can find examples of parsing most common data types and formats
2. The errors and warnings should be verbose and informative, instructing you how to fix errors and improve upon inefficient parsing strategies
3. The parser should be flexible enough that you can write custom parsers for those large, complex datasets that trip up even the most well-vetted parse strategies
4. After you've finished reading and manipulating the dataset in Julia, getting that data written back out of Julia with a simple and robust write function

I wrote this package to explore what user-facing APIs create the most convenient and flexible methods for reading and writing data. uCSV.jl strips away clever internal tricks for guessing types and compressing memory to focus on feature completeness and overall usability.

## Contributing

If you find a file you cannot parse after reading through the documentation and would like help, please file an issue!

If you find a limitation in capability or a performance bottleneck that you can improve upon, or would like to improve upon the documentation, please open a PR!

## License

[MIT](https://github.com/cjprybol/uCSV.jl/blob/master/LICENSE.md)

## Acknowledgements

- [Contributors](https://github.com/cjprybol/uCSV.jl/graphs/contributors)
- 🐛 🕵️s:
    - **Thanks to everyone who has diagnosed a bug or contributed a dataset for testing**
    - *your name here?*
