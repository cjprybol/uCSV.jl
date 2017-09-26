# uCSV.jl

[![Build Status](https://travis-ci.org/cjprybol/uCSV.jl.svg?branch=master)](https://travis-ci.org/cjprybol/uCSV.jl)

[![Coverage Status](https://coveralls.io/repos/cjprybol/uCSV.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/cjprybol/uCSV.jl?branch=master)

[![codecov.io](http://codecov.io/github/cjprybol/uCSV.jl/coverage.svg?branch=master)](http://codecov.io/github/cjprybol/uCSV.jl?branch=master)

uCSV.jl implements 2 main functions, `uCSV.read` and `uCSV.write`

# `uCSV.read`

`uCSV.read` assumes that you're starting with a comma-delimited UTF-8 text file, that looks something like this:
```
1,1.0,"a"
2,2.0,"b"
3,3.0,"c"
```

It will give you back the parsed dataset and an empty header.

`uCSV.read` enables you to construct more complex parsing-rules through a compact and flexible API that aims to handle everything from the simple to the nightmarish. Do you have multi-character unicode delimiters? If so, `uCSV.read()` has you covered. Your co-workers couldn't decide if they wanted to use `"TRUE"`, `"True"`, `"true"`, `"T"`, `"t"`, `"yes"`, or `1` for booleans, and they ended up using all of them? No problem, you can specify as many or as few as you want to encode as Julia's `true` upon parsing. You can specify datetime parsing semantics, request that `Float64`s be parsed with european-style decimals, e.g. `145,67` -> `145.67`, and skip comments, malformed lines, or just lines that you don't want. `uCSV.read` will only try and parse your data into `Int`s, `Float64`s, or `String`s, by default. No need to worry about the parser imposing any specialty vector- or element-types during the parsing, although you're more than welcome to request any more specialized types if you wish. If there's something `uCSV` doesn't support that you'd like to see, file an issue or open a PR and we'll see what we can do!

# `uCSV.write()`

`uCSV.write` is similarly simple. Give it a some data, a header, a delimiter (if you wan't something other than a comma), and a quote character (if you want fields to be quoted). It'll do some simple formatting behind the scenes before writing to disk. If anyone would like to write to IO streams as well, please open an issue or file a pull request so I know there is interest!

# why uCSV.jl?

**uCSV.jl wants you to spend less time figuring out how to parse your data and more time actually working with it**.

This is primarily an experimental proving ground to explore what user-facing APIs create the most convenient and flexible methods for reading and writing data. uCSV.jl strips away all of the extraneous features and (internal) code complexity to focus on features and overall usability. The long term goal is to merge the features that work best in this package with the more efficient lower level parses in CSV.jl and/or TextParse.jl.

# Testing library

Currently tested against:

    - >50 datasets hand-curated for their thorough coverage of common edge-cases and ugly formatting.
    - TODO: RDatasets

# Parsing cheatsheet

**default**
```julia
# input
using uCSV
s =
"""
1.0,1.0,1.0
2.0,2.0,2.0
3.0,3.0,3.0
""";
data, header = uCSV.read(IOBuffer(s));

# ouptut
julia> data
3-element Array{Any,1}:
 [1.0, 2.0, 3.0]
 [1.0, 2.0, 3.0]
 [1.0, 2.0, 3.0]

julia> header
0-element Array{String,1}

```

**header**
```julia
# input
using uCSV
s =
"""
c1,c2,c3
1,1.0,a
2,2.0,b
3,3.0,c
""";
data, header = uCSV.read(IOBuffer(s), header = 1);

# output
julia> data
3-element Array{Any,1}:
 [1, 2, 3]
 [1.0, 2.0, 3.0]
 String["a", "b", "c"]

julia> header
3-element Array{String,1}:
 "c1"
 "c2"
 "c3"

```

**reading into a DataFrame**

```julia
# input
using uCSV, DataFrames
s =
"""
1.0,1.0,1.0
2.0,2.0,2.0
3.0,3.0,3.0
""";

# output
julia> DataFrame(uCSV.read(IOBuffer(s)))
3×3 DataFrames.DataFrame
│ Row │ x1  │ x2  │ x3  │
├─────┼─────┼─────┼─────┤
│ 1   │ 1.0 │ 1.0 │ 1.0 │
│ 2   │ 2.0 │ 2.0 │ 2.0 │
│ 3   │ 3.0 │ 3.0 │ 3.0 │
```
or with a header
```julia
# input
s =
"""
c1,c2,c3
1,1.0,a
2,2.0,b
3,3.0,c
""";

# output
julia> DataFrame(uCSV.read(IOBuffer(s), header = 1))
3×3 DataFrames.DataFrame
│ Row │ c1 │ c2  │ c3 │
├─────┼────┼─────┼────┤
│ 1   │ 1  │ 1.0 │ a  │
│ 2   │ 2  │ 2.0 │ b  │
│ 3   │ 3  │ 3.0 │ c  │

```


**nulls**

```julia
# input
using uCSV, DataFrames, Nulls
encodings = Dict{String, Any}("" => null, "\"\"" => null, "NULL" => null, "NA" => null);
s =
"""
1,hey,1
2,you,2
3,,3
4,"",4
5,NULL,5
6,NA,6
""";

# output
julia> DataFrame(uCSV.read(IOBuffer(s), encodings=encodings, typedetectrows=3))
6×3 DataFrames.DataFrame
│ Row │ x1 │ x2   │ x3 │
├─────┼────┼──────┼────┤
│ 1   │ 1  │ hey  │ 1  │
│ 2   │ 2  │ you  │ 2  │
│ 3   │ 3  │ null │ 3  │
│ 4   │ 4  │ null │ 4  │
│ 5   │ 5  │ null │ 5  │
│ 6   │ 6  │ null │ 6  │

julia> DataFrame(uCSV.read(IOBuffer(s), encodings=encodings, isnullable=true))
6×3 DataFrames.DataFrame
│ Row │ x1 │ x2   │ x3 │
├─────┼────┼──────┼────┤
│ 1   │ 1  │ hey  │ 1  │
│ 2   │ 2  │ you  │ 2  │
│ 3   │ 3  │ null │ 3  │
│ 4   │ 4  │ null │ 4  │
│ 5   │ 5  │ null │ 5  │
│ 6   │ 6  │ null │ 6  │

julia> DataFrame(uCSV.read(IOBuffer(s), encodings=encodings, isnullable=[false, true, false]))
6×3 DataFrames.DataFrame
│ Row │ x1 │ x2   │ x3 │
├─────┼────┼──────┼────┤
│ 1   │ 1  │ hey  │ 1  │
│ 2   │ 2  │ you  │ 2  │
│ 3   │ 3  │ null │ 3  │
│ 4   │ 4  │ null │ 4  │
│ 5   │ 5  │ null │ 5  │
│ 6   │ 6  │ null │ 6  │

julia> DataFrame(uCSV.read(IOBuffer(s), encodings=encodings, isnullable=Dict(2 => true)))
6×3 DataFrames.DataFrame
│ Row │ x1 │ x2   │ x3 │
├─────┼────┼──────┼────┤
│ 1   │ 1  │ hey  │ 1  │
│ 2   │ 2  │ you  │ 2  │
│ 3   │ 3  │ null │ 3  │
│ 4   │ 4  │ null │ 4  │
│ 5   │ 5  │ null │ 5  │
│ 6   │ 6  │ null │ 6  │

julia> DataFrame(uCSV.read(IOBuffer(s), encodings=encodings, types=Dict(2 => Union{String, Null})))
6×3 DataFrames.DataFrame
│ Row │ x1 │ x2   │ x3 │
├─────┼────┼──────┼────┤
│ 1   │ 1  │ hey  │ 1  │
│ 2   │ 2  │ you  │ 2  │
│ 3   │ 3  │ null │ 3  │
│ 4   │ 4  │ null │ 4  │
│ 5   │ 5  │ null │ 5  │
│ 6   │ 6  │ null │ 6  │

```

**booleans**
```julia
# input
using uCSV, DataFrames
s =
"""
true
false
""";

# output
julia> DataFrame(uCSV.read(IOBuffer(s), types=Bool))
2×1 DataFrames.DataFrame
│ Row │ x1    │
├─────┼───────┤
│ 1   │ true  │
│ 2   │ false │

julia> DataFrame(uCSV.read(IOBuffer(s), types=[Bool]))
2×1 DataFrames.DataFrame
│ Row │ x1    │
├─────┼───────┤
│ 1   │ true  │
│ 2   │ false │

julia> DataFrame(uCSV.read(IOBuffer(s), types=Dict(1 => Bool)))
2×1 DataFrames.DataFrame
│ Row │ x1    │
├─────┼───────┤
│ 1   │ true  │
│ 2   │ false │

julia> DataFrame(uCSV.read(IOBuffer(s), types=Dict(1 => Bool)))
2×1 DataFrames.DataFrame
│ Row │ x1    │
├─────┼───────┤
│ 1   │ true  │
│ 2   │ false │

```
or with encodings that Julia cannot parse as booleans by default
```julia
# input
s =
"""
T
F
""";

# output
julia> DataFrame(uCSV.read(IOBuffer(s), encodings=Dict{String,Any}("T" => true, "F" => false)))
2×1 DataFrames.DataFrame
│ Row │ x1    │
├─────┼───────┤
│ 1   │ true  │
│ 2   │ false │

```

**symbols**
```julia
# input
using uCSV, DataFrames
s =
"""
x1
y7
µ∆
""";

# output
julia> df1 = DataFrame(uCSV.read(IOBuffer(s), types=Symbol))
3×1 DataFrames.DataFrame
│ Row │ x1 │
├─────┼────┤
│ 1   │ x1 │
│ 2   │ y7 │
│ 3   │ µ∆ │

julia> df2 = DataFrame(uCSV.read(IOBuffer(s), types=[Symbol]))
3×1 DataFrames.DataFrame
│ Row │ x1 │
├─────┼────┤
│ 1   │ x1 │
│ 2   │ y7 │
│ 3   │ µ∆ │

julia> df3 = DataFrame(uCSV.read(IOBuffer(s), types=Dict(1 => Symbol)))
3×1 DataFrames.DataFrame
│ Row │ x1 │
├─────┼────┤
│ 1   │ x1 │
│ 2   │ y7 │
│ 3   │ µ∆ │

julia> df1 == df2 == df3
true

julia> eltype(df1[1]) == eltype(df2[1]) == eltype(df3[1]) == Symbol
true

```

**dates**
```julia
# input
using uCSV, DataFrames
s =
"""
2013-01-01
""";

# output
julia> DataFrame(uCSV.read(IOBuffer(s), types=Date))
1×1 DataFrames.DataFrame
│ Row │ x1         │
├─────┼────────────┤
│ 1   │ 2013-01-01 │

```
or with date formats other than the default
```julia
# input
s =
"""
12/24/36
""";

# output
julia> DataFrame(uCSV.read(IOBuffer(s), types=Date, typeparsers=Dict(Date => x -> Date(x, "m/d/y"))))
1×1 DataFrames.DataFrame
│ Row │ x1         │
├─────┼────────────┤
│ 1   │ 0036-12-24 │

julia> DataFrame(uCSV.read(IOBuffer(s), colparsers=Dict(1 => x -> Date(x, "m/d/y"))))
1×1 DataFrames.DataFrame
│ Row │ x1         │
├─────┼────────────┤
│ 1   │ 0036-12-24 │

```

**datetimes**
```julia
# input
using uCSV, DataFrames
s =
"""
2015-01-01 00:00:00
2015-01-02 00:00:01
2015-01-03 00:12:00.001
""";

function datetimeparser(x)
    if in('.', x)
       return DateTime(x, "y-m-d H:M:S.s")
   else
       return DateTime(x, "y-m-d H:M:S")
   end
end

# output
julia> df = DataFrame(uCSV.read(IOBuffer(s), colparsers=(x -> datetimeparser(x))))
3×1 DataFrames.DataFrame
│ Row │ x1                      │
├─────┼─────────────────────────┤
│ 1   │ 2015-01-01T00:00:00     │
│ 2   │ 2015-01-02T00:00:01     │
│ 3   │ 2015-01-03T00:12:00.001 │

```

**[decimal-comma floats](https://en.wikipedia.org/wiki/Decimal_mark#Hindu.E2.80.93Arabic_numeral_system)**
```julia
# input
using uCSV, DataFrames
s =
"""
19,97;3,14;999
"""
imperialize(x) = parse(Float64, replace(x, ',', '.'))

# output
julia> DataFrame(uCSV.read(IOBuffer(s), delim=';', types=Dict(1 => Float64, 2 => Float64), typeparsers=Dict(Float64 => x -> imperialize(x))))
1×3 DataFrames.DataFrame
│ Row │ x1    │ x2   │ x3  │
├─────┼───────┼──────┼─────┤
│ 1   │ 19.97 │ 3.14 │ 999 │

julia> DataFrame(uCSV.read(IOBuffer(s), delim=';', colparsers=Dict(1 => x -> imperialize(x), 2 => x -> imperialize(x))))
1×3 DataFrames.DataFrame
│ Row │ x1    │ x2   │ x3  │
├─────┼───────┼──────┼─────┤
│ 1   │ 19.97 │ 3.14 │ 999 │

```

**other custom parsers**
```julia
using uCSV, DataFrames
function myparser(x)
    # code
end
my_input = ...
uCSV.read(my_input, colparsers=Dict(column => x -> myparser(x)))

```

**quoted fields**
```julia
# input
uCSV, DataFrames
s =
"""
"I,have,delimiters,in,my,fields"
""";

# output
julia> DataFrame(uCSV.read(IOBuffer(s)))
1×6 DataFrames.DataFrame
│ Row │ x1 │ x2   │ x3         │ x4 │ x5 │ x6      │
├─────┼────┼──────┼────────────┼────┼────┼─────────┤
│ 1   │ "I │ have │ delimiters │ in │ my │ fields" │

# input
s =
"""
"I,have,delimiters,in,my,fields,that,I,don't,want"
""";

# output
julia> DataFrame(uCSV.read(IOBuffer(s), quotes='"'))
1×1 DataFrames.DataFrame
│ Row │ x1                                               │
├─────┼──────────────────────────────────────────────────┤
│ 1   │ I,have,delimiters,in,my,fields,that,I,don't,want │

```

**quoted fields with internal double quotes**
```julia
# input
using uCSV, DataFrames
names = ["\"Rich \"\"Goose\"\" Gossage\"",
         "\"Henry \"\"Hammerin' Hank\"\" Aaron\""]

# output
julia> DataFrame(uCSV.read(IOBuffer(join(names, '\n')), quotes='"', escape='"'))
2×1 DataFrames.DataFrame
│ Row │ x1                           │
├─────┼──────────────────────────────┤
│ 1   │ Rich "Goose" Gossage         │
│ 2   │ Henry "Hammerin' Hank" Aaron │

```

**escaped characters**
```julia
# input
using uCSV, DataFrames

names = ["\"Rich \\\"Goose\\\" Gossage\"",
         "\"Henry \\\"Hammerin' Hank\\\" Aaron\""]

# output
julia> DataFrame(uCSV.read(IOBuffer(join(names, '\n')), quotes='"', escape='\\'))
2×1 DataFrames.DataFrame
│ Row │ x1                           │
├─────┼──────────────────────────────┤
│ 1   │ Rich "Goose" Gossage         │
│ 2   │ Henry "Hammerin' Hank" Aaron │

```

**comments and skipping lines**
```julia
# input
using uCSV, DataFrames
s =
"""
# i am a comment
data
""";

# output
julia> DataFrame(uCSV.read(IOBuffer(s), comment='#'))
1×1 DataFrames.DataFrame
│ Row │ x1   │
├─────┼──────┤
│ 1   │ data │

# input
s =
"""
# i am a comment
I'm the header
""";

# output
julia> df = DataFrame(uCSV.read(IOBuffer(s), header=2))
0×1 DataFrames.DataFrame


julia> names(df)
1-element Array{Symbol,1}:
 Symbol("I'm the header")

julia> df = DataFrame(uCSV.read(IOBuffer(s), comment='#', header=1))
0×1 DataFrames.DataFrame


julia> names(df)
1-element Array{Symbol,1}:
 Symbol("I'm the header")

# input
s =
"""
# i am a comment
I'm the header
skipped data
included data
""";

# output
julia> DataFrame(uCSV.read(IOBuffer(s), comment='#', header=1, skiprows=1:1))
1×1 DataFrames.DataFrame
│ Row │ I'm the header │
├─────┼────────────────┤
│ 1   │ included data  │

# input
s =
"""
# i am a comment
I'm the header
skipped data
included data
""";

# output
julia> DataFrame(uCSV.read(IOBuffer(s), skiprows=1:3))
1×1 DataFrames.DataFrame
│ Row │ x1            │
├─────┼───────────────┤
│ 1   │ included data │

```

**malformed lines**
```julia
# input
using uCSV, DataFrames

s =
"""
1
1,2
""";

# output
julia> DataFrame(uCSV.read(IOBuffer(s)))
ERROR: Parsed 2 fields on row 2. Expected 1.
line:
1,2
Possible fixes may include:
  1. including 2 in the `skiprows` argument
  2. setting `skipmalformed=true`
  3. if this line is a comment, set the `comment` argument
  4. if fields are quoted, setting the `quotes` argument
  5. if special characters are escaped, setting the `escape` argument
  6. fixing the malformed line in the source or file before invoking `uCSV.read`

julia> DataFrame(uCSV.read(IOBuffer(s), skipmalformed=true))
WARNING: Parsed 2 fields on row 2. Expected 1. Skipping...
1×1 DataFrames.DataFrame
│ Row │ x1 │
├─────┼────┤
│ 1   │ 1  │

```

**read from a URL**
```julia
# input
using uCSV, DataFrames, HTTP
html = "https://raw.github.com/vincentarelbundock/Rdatasets/master/csv/datasets/USPersonalExpenditure.csv";

# output
julia> DataFrame(uCSV.read(HTTP.body(HTTP.get(html)), quotes='"', header=1))
5×6 DataFrames.DataFrame
│ Row │                     │ 1940  │ 1945  │ 1950 │ 1955 │ 1960 │
├─────┼─────────────────────┼───────┼───────┼──────┼──────┼──────┤
│ 1   │ Food and Tobacco    │ 22.2  │ 44.5  │ 59.6 │ 73.2 │ 86.8 │
│ 2   │ Household Operation │ 10.5  │ 15.5  │ 29.0 │ 36.5 │ 46.2 │
│ 3   │ Medical and Health  │ 3.53  │ 5.76  │ 9.71 │ 14.0 │ 21.1 │
│ 4   │ Personal Care       │ 1.04  │ 1.98  │ 2.45 │ 3.4  │ 5.4  │
│ 5   │ Private Education   │ 0.341 │ 0.974 │ 1.8  │ 2.6  │ 3.64 │

```

**compressed (e.g. gzip, bzip2) file**
```julia
# input
using uCSV, DataFrames, CodecZlib
iris_file = joinpath(Pkg.dir("uCSV"), "test", "data", "iris.csv.gz");
iris_io = GzipDecompressionStream(open(iris_file));

# output
julia> head(DataFrame(uCSV.read(iris_io, header=1)), 10)
10×6 DataFrames.DataFrame
│ Row │ Id │ SepalLengthCm │ SepalWidthCm │ PetalLengthCm │ PetalWidthCm │ Species     │
├─────┼────┼───────────────┼──────────────┼───────────────┼──────────────┼─────────────┤
│ 1   │ 1  │ 5.1           │ 3.5          │ 1.4           │ 0.2          │ Iris-setosa │
│ 2   │ 2  │ 4.9           │ 3.0          │ 1.4           │ 0.2          │ Iris-setosa │
│ 3   │ 3  │ 4.7           │ 3.2          │ 1.3           │ 0.2          │ Iris-setosa │
│ 4   │ 4  │ 4.6           │ 3.1          │ 1.5           │ 0.2          │ Iris-setosa │
│ 5   │ 5  │ 5.0           │ 3.6          │ 1.4           │ 0.2          │ Iris-setosa │
│ 6   │ 6  │ 5.4           │ 3.9          │ 1.7           │ 0.4          │ Iris-setosa │
│ 7   │ 7  │ 4.6           │ 3.4          │ 1.4           │ 0.3          │ Iris-setosa │
│ 8   │ 8  │ 5.0           │ 3.4          │ 1.5           │ 0.2          │ Iris-setosa │
│ 9   │ 9  │ 4.4           │ 2.9          │ 1.4           │ 0.2          │ Iris-setosa │
│ 10  │ 10 │ 4.9           │ 3.1          │ 1.5           │ 0.1          │ Iris-setosa │

```

**categorical arrays**
```julia
# input
using uCSV, DataFrames
s =
"""
a,b,c
a,b,c
a,b,c
a,b,c
""";
eltype.(DataFrame(uCSV.read(IOBuffer(s), iscategorical=true)).columns)
eltype.(DataFrame(uCSV.read(IOBuffer(s), iscategorical=[true, true, true])).columns)
eltype.(DataFrame(uCSV.read(IOBuffer(s), iscategorical=Dict(3 => true))).columns)
eltype.(DataFrame(uCSV.read(IOBuffer(s), header=1, iscategorical=Dict("a" => true))).columns)

# output
julia> eltype.(DataFrame(uCSV.read(IOBuffer(s), iscategorical=true)).columns)
3-element Array{DataType,1}:
 CategoricalArrays.CategoricalValue{String,UInt32}
 CategoricalArrays.CategoricalValue{String,UInt32}
 CategoricalArrays.CategoricalValue{String,UInt32}

julia> eltype.(DataFrame(uCSV.read(IOBuffer(s), iscategorical=[true, true, true])).columns)
3-element Array{DataType,1}:
 CategoricalArrays.CategoricalValue{String,UInt32}
 CategoricalArrays.CategoricalValue{String,UInt32}
 CategoricalArrays.CategoricalValue{String,UInt32}

julia> eltype.(DataFrame(uCSV.read(IOBuffer(s), iscategorical=Dict(3 => true))).columns)
3-element Array{DataType,1}:
 String
 String
 CategoricalArrays.CategoricalValue{String,UInt32}

julia> eltype.(DataFrame(uCSV.read(IOBuffer(s), header=1, iscategorical=Dict("a" => true))).columns)
3-element Array{DataType,1}:
 CategoricalArrays.CategoricalValue{String,UInt32}
 String
 String

```

**hopefully you never actually need to do this, but you can**
```julia
# input
using uCSV, DataFrames
s =
"""
†I am a quoted field†≤≥†and another†
"""

# output
julia> DataFrame(uCSV.read(IOBuffer(s), delim="≤≥", quotes='†'))
1×2 DataFrames.DataFrame
│ Row │ x1                  │ x2          │
├─────┼─────────────────────┼─────────────┤
│ 1   │ I am a quoted field │ and another │

```

# Common issues that are not supported

**dataset isn't UTF-8**
Try `iconv` or the [StringEncodings.jl]() package.

**dataset doesn't use Unix `\n` or Windows `\r\n` line endings**
Try viewing your file in a command-line plain text viewer like `vi` or `less`. If you see `^M` character sequences at the expected line breaks, you'll need to convert those to either `\n` or `\r\n` yourself.

**[fancy/smart quotes, apostrophes, and other punctation](http://smartquotesforsmartpeople.com/)**
Only single quote characters are supported at this point. Any individual "smart" quote will work, but different "smart" quotes for the beginning and end of a field is not supported. It should be possible to add but the number of possible "smart" quotes can get out of hand very quickly. You'll likely be better off converting all of them to simple `"` dumb-quotes for the purpose of your data analysis. Save the smart quotes for your publications!

# Read speed compared to others

**setup**

All data will be read into equivalent DataFrames
```julia
using uCSV, CSV, TextParse, CodecZlib, Nulls, DataFrames, Base.Test
GDS = GzipDecompressionStream;

function textparse2DF(x)
    DataFrame(Any[x[1]...], Symbol.(x[2]))
end
```

**[iris](https://github.com/cjprybol/uCSV.jl/blob/master/test/data/iris.csv.gz)**
```julia
iris_file = joinpath(Pkg.dir("uCSV"), "test", "data", "iris.csv.gz");
@time df1 = DataFrame(uCSV.read(GDS(open(iris_file)), header=1));
@time df2 = CSV.read(GDS(open(iris_file)), types=Dict(6=>String));
@time df3 = textparse2DF(csvread(GDS(open(iris_file)), pooledstrings=false));
@test df1 == df2 == df3
```

```julia
julia> @time df1 = DataFrame(uCSV.read(GDS(open(iris_file)), header=1));
  3.791587 seconds (2.52 M allocations: 127.846 MiB, 1.99% gc time)

julia> @time df2 = CSV.read(GDS(open(iris_file)), types=Dict(6=>String));
  6.818591 seconds (4.07 M allocations: 200.507 MiB, 3.18% gc time)

julia> @time df3 = textparse2DF(csvread(GDS(open(iris_file)), pooledstrings=false));
  2.667487 seconds (1.78 M allocations: 96.523 MiB, 2.51% gc time)

julia> @test df1 == df2 == df3
Test Passed

```

**[0s-1s](https://github.com/cjprybol/uCSV.jl/blob/master/test/data/0s-1s.csv.gz)**
```julia
ints_file = joinpath(Pkg.dir("uCSV"), "test", "data", "0s-1s.csv.gz");
@time df1 = DataFrame(uCSV.read(GDS(open(ints_file)), header=1));
@time df2 = CSV.read(GDS(open(ints_file)));
@time df3 = textparse2DF(csvread(GDS(open(ints_file))));
@test df1 == df2 == df3
```

```julia
julia> ints_file = joinpath(Pkg.dir("uCSV"), "test", "data", "0s-1s.csv.gz");

julia> @time df1 = DataFrame(uCSV.read(GDS(open(ints_file)), header=1));
  6.379254 seconds (33.76 M allocations: 1.425 GiB, 7.30% gc time)

julia> @time df2 = CSV.read(GDS(open(ints_file)));
 10.377598 seconds (10.11 M allocations: 358.625 MiB, 2.43% gc time)

julia> @time df3 = textparse2DF(csvread(GDS(open(ints_file))));
  2.525099 seconds (1.83 M allocations: 189.862 MiB, 3.67% gc time)

julia> @test df1 == df2 == df3
Test Passed

```

**[Flights](https://github.com/cjprybol/uCSV.jl/blob/master/test/data/2010_BSA_Carrier_PUF.csv.gz)**
```julia
carrier_file = joinpath(Pkg.dir("uCSV"), "test", "data", "2010_BSA_Carrier_PUF.csv.gz");
@time df1 = DataFrame(uCSV.read(GDS(open(carrier_file)), header=1, typedetectrows=2, encodings=Dict{String,Any}("" => null), types=Dict(3 =>  Union{String, Null})));
@time df2 = CSV.read(GDS(open(carrier_file)), types=Dict(3 => Union{String, Null}, 4 => String, 5 => String, 8 => String));
# does not parse correctly
@time df3 = textparse2DF(csvread(GDS(open(carrier_file)), pooledstrings=false, type_detect_rows=228990, nastrings=[""]));
@test_broken df1 == df2 == df3
@test df1 == df2
```

```julia
julia> carrier_file = joinpath(Pkg.dir("uCSV"), "test", "data", "2010_BSA_Carrier_PUF.csv.gz");

julia> @time df1 = DataFrame(uCSV.read(GDS(open(carrier_file)), header=1, typedetectrows=2, encodings=Dict{String,Any}("" => null), types=Dict(3 =>  Union{String, Null})));
 51.146730 seconds (229.57 M allocations: 9.036 GiB, 49.18% gc time)

julia> @time df2 = CSV.read(GDS(open(carrier_file)), types=Dict(3 => Union{String, Null}, 4 => String, 5 => String, 8 => String));
 13.113943 seconds (76.93 M allocations: 1.803 GiB, 32.44% gc time)

julia> # does not parse correctly
       @time df3 = textparse2DF(csvread(GDS(open(carrier_file)), pooledstrings=false, type_detect_rows=228990, nastrings=[""]));
 27.005981 seconds (49.83 M allocations: 2.734 GiB, 57.52% gc time)

julia> @test_broken df1 == df2 == df3
Test Broken
Expression: df1 == df2 == df3


julia> @test df1 == df2
Test Passed
```

**[Human Genome Feature Format](https://github.com/cjprybol/uCSV.jl/blob/master/test/data/Homo_sapiens.GRCh38.90.gff3.gz)**
```julia
genome_file = joinpath(Pkg.dir("uCSV"), "test", "data", "Homo_sapiens.GRCh38.90.gff3.gz");
@time df1 = DataFrame(uCSV.read(GDS(open(genome_file)), delim='\t', comment='#', types=Dict(1 => String)));
@time df2 = CSV.read(IOBuffer(join(filter(line -> !startswith(line, '#'), readlines(GDS(open(genome_file)))), '\n')), delim='\t', types=Dict(1 => String, 2 => String, 3 => String, 6 => String, 7 => String, 8 => String, 9 => String), header=[:x1, :x2, :x3, :x4, :x5, :x6, :x7, :x8, :x9]);
@test_broken df3 = textparse2DF(csvread(IOBuffer(join(filter(line -> !startswith(line, '#'), readlines(GDS(open(genome_file)))), '\n')), '\t', pooledstrings=false));
@test df1 == df2
```

```julia
julia> genome_file = joinpath(Pkg.dir("uCSV"), "test", "data", "Homo_sapiens.GRCh38.90.gff3.gz");

julia> @time df1 = DataFrame(uCSV.read(GDS(open(genome_file)), delim='\t', comment='#', types=Dict(1 => String)));
 48.559884 seconds (197.88 M allocations: 8.669 GiB, 50.47% gc time)

julia> @time df2 = CSV.read(IOBuffer(join(filter(line -> !startswith(line, '#'), readlines(GDS(open(genome_file)))), '\n')), delim='\t', types=Dict(1 => String, 2 => String, 3 => String, 6 => String, 7 => String, 8 => String, 9 => String), header=[:x1, :x2, :x3, :x4, :x5, :x6, :x7, :x8, :x9]);
 22.231910 seconds (85.95 M allocations: 3.893 GiB, 44.77% gc time)

julia> @test_broken df3 = textparse2DF(csvread(IOBuffer(join(filter(line -> !startswith(line, '#'), readlines(GDS(open(genome_file)))), '\n')), '\t', pooledstrings=false));

julia> @test df1 == df2
Test Passed

```

**[country indicators](https://github.com/cjprybol/uCSV.jl/blob/master/test/data/indicators.csv.gz)**
```julia
indicators_file = joinpath(Pkg.dir("uCSV"), "test", "data", "indicators.csv.gz");
@time df1 = DataFrame(uCSV.read(GDS(open(indicators_file)), quotes='"'));
@time df2 = CSV.read(GDS(open(indicators_file)), header=[:x1, :x2, :x3, :x4, :x5, :x6], types=Dict(1 => String, 2 => String, 3 => String, 4 => String));
@time df3 = textparse2DF(csvread(GDS(open(indicators_file)), pooledstrings=false, header_exists=false, colnames=[:x1, :x2, :x3, :x4, :x5, :x6]));
@test df1 == df2 == df3
```

```julia
julia> indicators_file = joinpath(Pkg.dir("uCSV"), "test", "data", "indicators.csv.gz");

julia> @time df1 = DataFrame(uCSV.read(GDS(open(indicators_file)), quotes='"'));
 77.891937 seconds (229.19 M allocations: 11.248 GiB, 41.44% gc time)

julia> @time df2 = CSV.read(GDS(open(indicators_file)), header=[:x1, :x2, :x3, :x4, :x5, :x6], types=Dict(1 => String, 2 => String, 3 => String, 4 => String));
 17.559485 seconds (55.74 M allocations: 1.922 GiB, 26.93% gc time)

julia> @time df3 = textparse2DF(csvread(GDS(open(indicators_file)), pooledstrings=false, header_exists=false, colnames=[:x1, :x2, :x3, :x4, :x5, :x6]));
 13.672462 seconds (13.38 M allocations: 1.384 GiB, 26.24% gc time)

julia> eltype.(df1.columns) == eltype.(df2.columns) == eltype.(df3.columns)
true

```

**[yellowtaxi](https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2015-01.csv)**
```julia
taxi_file = joinpath(homedir(), "Downloads", "yellow_tripdata_2015-01.csv");
@time df1 = DataFrame(uCSV.read(taxi_file, header=1, typedetectrows=6, types=Dict(18=>Union{Float64, Null}), encodings=Dict{String,Any}("" => null)));
@time df2 = CSV.read(taxi_file, types=eltype.(df1.columns));
@time df3 = textparse2DF(csvread(taxi_file));
```

```julia
julia> @time df1 = DataFrame(uCSV.read(taxi_file, header=1, typedetectrows=6, types=Dict(18=>Union{Float64, Null}), encodings=Dict{String,Any}("" => null)));
455.962678 seconds (1.79 G allocations: 70.441 GiB, 49.24% gc time)

julia> @time df2 = CSV.read(taxi_file, types=eltype.(df1.columns));
112.266853 seconds (692.94 M allocations: 13.221 GiB, 72.15% gc time)

julia> @time df3 = textparse2DF(csvread(taxi_file));
 67.999334 seconds (28.69 M allocations: 3.790 GiB, 56.92% gc time)

```

# Write speed

if you're interested in seeing this, let me know by filing an issue or by running some comparisons yourself and opening a PR with the results!
