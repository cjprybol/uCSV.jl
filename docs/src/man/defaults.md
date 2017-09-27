# Getting Started

## `uCSV.read`

`uCSV.read` enables you to construct more complex parsing-rules through a compact and flexible API that aims to handle everything from the simple to the nightmarish.

By default, it assumes that you're starting with a simple comma-delimited data matrix. This makes `uCSV.read` a suitable tool for reading raw numeric datasets for conversion to 2-D `Arrays`, in addition to reading more complex datasets

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

julia> uCSV.tomatrix(uCSV.read(IOBuffer(s)))
3×3 Array{Float64,2}:
 1.0  1.0  1.0
 2.0  2.0  2.0
 3.0  3.0  3.0

```

Some examples of what `uCSV.read` can handle:

- String delimiters
- Unlimited field => value encodings for when you have multiple null-strings, boolean encodings, or other special fields
- Built-in support for Strings, Ints, Float64s, Symbols, Dates, DateTimes, and Booleans with default formatting rules
- Flexible methods for manually specifying column types, column nullability, type-specific parsers, column-specific parsers, and columns that should be CategoricalVectors
- Commented lines are skipped on request, blank lines skipped by default
- Ability to skip any rows in the dataset during parsing
- Ability to skip malformed rows
- Ability to trim extra whitespace around fields and end of lines
- Ability to specify how many rows to read for detecting column types
- Escape characters for quotes within quoted fields, and for quotes, newlines, and delimiters outside of quoted fields
- Reading files from URLs (via [HTTP.jl](https://github.com/JuliaWeb/HTTP.jl)) and from compressed sources (via [TranscodingStreams.jl](https://github.com/bicycle1885/TranscodingStreams.jl#codec-packages))
- And more!

`uCSV.read` will only try and parse your data into `Int`s, `Float64`s, or `String`s, by default. No need to worry about the parser imposing any specialty vector- or element-types during the parsing that may conflict with downstream processing. If there's something `uCSV` doesn't support that you'd like to see, file an issue or open a pull request!

## `uCSV.write()`

Give `uCSV.write` some data and a header (or just one or the other), a delimiter (if you wan't something other than a comma), a quote character (if you want fields to be quoted), and a declaration of what column-types you'd like to be quoted (it defaults to string columns). That's it!
