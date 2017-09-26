# uCSV.jl

[![Build Status](https://travis-ci.org/cjprybol/uCSV.jl.svg?branch=master)](https://travis-ci.org/cjprybol/uCSV.jl)
[![Coverage Status](https://coveralls.io/repos/cjprybol/uCSV.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/cjprybol/uCSV.jl?branch=master)
[![codecov.io](http://codecov.io/github/cjprybol/uCSV.jl/coverage.svg?branch=master)](http://codecov.io/github/cjprybol/uCSV.jl?branch=master)

## Getting Started

First, Install the package
```julia
Pkg.clone("https://github.com/cjprybol/uCSV.jl")
```

Then head on over to the [![](https://img.shields.io/badge/docs-latest-blue.svg)](https://cjprybol.github.io/uCSV.jl/latest)!

## Why uCSV?

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

- [Contributors](https://github.com/cjprybol/uCSV.jl/graphs/contributors)
- Bug Finders:
    - Your name here!
