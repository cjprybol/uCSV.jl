# uCSV.jl

A flexible and transparent toolkit for reading and writing delimited-text with [Julia](https://github.com/JuliaLang/julia).

**when going public, swap travis-ci.com for .org**

[![Build Status](https://travis-ci.org/cjprybol/uCSV.jl.svg?branch=master)](https://travis-ci.org/cjprybol/uCSV.jl)

[![Build Status](https://travis-ci.com/cjprybol/uCSV.jl.svg?token=szmv7beYF5EYPTfqLsSR&branch=master)](https://travis-ci.com/cjprybol/uCSV.jl)
[![Coverage Status](https://coveralls.io/repos/cjprybol/uCSV.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/cjprybol/uCSV.jl?branch=master)
[![codecov.io](http://codecov.io/github/cjprybol/uCSV.jl/coverage.svg?branch=master)](http://codecov.io/github/cjprybol/uCSV.jl?branch=master)

## Getting Started

### Installing the package

```julia
Pkg.clone("https://github.com/cjprybol/uCSV.jl")
```

### And then head on over to the docs!

[Documentation]()

## why uCSV.jl?

**Spend less time pre-formatting your dataset and more time working with it**

Some keys requirements to acheiving this are:

1. The documentation and examples must be thorough enough to help users construct appropriate function calls
2. The errors and warnings must be verbose and informative enough to coach users through successfully updating improperly set arguments
3. The parser must be flexible enough to allow arbitrary parsing rules, enabling advanced users to predifine functions that improve efficiency and extend the parsing capabilities well beyond the functionality supported in base Julia

This is primarily an experimental proving ground to explore what user-facing APIs create the most convenient and flexible methods for reading and writing data. uCSV.jl strips away all of the extraneous features and (internal) code complexity to focus on features and overall usability. My long term goal is to merge the features that work best in this package with the more efficient lower level parsers in CSV.jl and/or TextParse.jl.

## Contributing

If you find a file you cannot parse after reading through the documentation, please file an issue!

If you find a limitation in capability or performance bottleneck that you can improve upon, please open a PR!

## License

[MIT](https://github.com/cjprybol/uCSV.jl/blob/master/LICENSE.md)

## Acknowledgements

[Contributors](https://github.com/cjprybol/uCSV.jl/graphs/contributors)
Bug Finders:
    - Your name here!

# Thoroughly Vetted

Currently tested against:

- 75+ datasets hand-curated for their thorough coverage of common edge-cases and ugly formatting.
- IN PROGRESS: 75 additional datasets from RDatasets
