# Getting Started

## `uCSV.read`

`uCSV.read` enables you to construct more complex parsing-rules through a compact and flexible API that aims to handle everything from the simple to the nightmarish.

By default, it assumes that you're starting with a simple comma-delimited data matrix. This makes `uCSV.read` a suitable tool for reading raw numeric datasets for conversion to 2-D `Arrays` in addition to reading more complex datasets

```jldoctest
julia> using uCSV

julia> s =
       """
       1.0,1.0,1.0
       2.0,2.0,2.0
       3.0,3.0,3.0
       """;

julia> data, header = uCSV.read(IOBuffer(s));

julia> data
3-element Array{Any,1}:
 [1.0, 2.0, 3.0]
 [1.0, 2.0, 3.0]
 [1.0, 2.0, 3.0]

julia> header
0-element Array{String,1}

# get it as a matrix!
julia> uCSV.tomatrix(uCSV.read(IOBuffer(s)))
3×3 Array{Float64,2}:
 1.0  1.0  1.0
 2.0  2.0  2.0
 3.0  3.0  3.0

```

Some examples of what `uCSV.read` can handle:

- [x] String delimiters
- [x] Unlimited field => value encodings for when you have multiple null-strings, boolean encodings, or other special fields
- [x] Built-in support for Strings, Ints, Float64s, Symbols, Dates, DateTimes, and Booleans with default formatting rules
- [x] Flexible methods for manually specifying column types, nullability, type- and column-specific parsers, and CategoricalVectors
- [x] Commented lines are skipped on request, blank lines skipped by default
- [x] Ability to skip any rows in the dataset during parsing
- [x] Ability to skip malformed rows
- [x] Ability to trim extra whitespace around fields and end of lines
- [x] Ability to specify how many rows to read for detecting column types
- [x] Escape characters for quotes within quoted fields, and for quotes, newlines, and delimiters outside of quoted fields
- [x] Reading files from URLs (via [HTTP.jl](https://github.com/JuliaWeb/HTTP.jl)) and from compressed sources (via [TranscodingStreams.jl](https://github.com/bicycle1885/TranscodingStreams.jl#codec-packages))

`uCSV.read` will only try and parse your data into `Int`s, `Float64`s, or `String`s, by default. No need to worry about the parser imposing any specialty vector- or element-types during the parsing that may conflict with downstream processing, although you're more than welcome to request specialized types when desired. If there's something `uCSV` doesn't support that you'd like to see, file an issue or open a pull request!

## `uCSV.write()`

Give `uCSV.write` some data and a header (or just one of them), a delimiter (if you wan't something other than a comma), and a quote character (if you want fields to be quoted). It'll create a file at the specified location and write to disk. Writing to IOStreams is not yet supported, but if you'd like this feature, please file an issue or open a pull request!
