# International Representations for Numbers

This strategy applies to any number of international data representation formats, however the most commonly requested format to support appears to be [decimal-comma floats](https://en.wikipedia.org/wiki/Decimal_mark#Hindu.E2.80.93Arabic_numeral_system).

This can be done by declaring the column types in conjunction with a type-specific parser that overrides the default Float64 parsing
```jldoctest
julia> using uCSV, DataFrames

julia> s =
       """
       19,97;3,14;999
       """;

julia> imperialize(x) = parse(Float64, replace(x, ',', '.'))
imperialize (generic function with 1 method)

julia> DataFrame(uCSV.read(IOBuffer(s), delim=';', types=Dict(1 => Float64, 2 => Float64), typeparsers=Dict(Float64 => x -> imperialize(x))))
1×3 DataFrames.DataFrame
│ Row │ x1    │ x2   │ x3  │
├─────┼───────┼──────┼─────┤
│ 1   │ 19.97 │ 3.14 │ 999 │

```

Or by declaring the column parsers directly
```jldoctest
julia> using uCSV, DataFrames

julia> s =
       """
       19,97;3,14;999
       """;

julia> imperialize(x) = parse(Float64, replace(x, ',', '.'))
imperialize (generic function with 1 method)

julia> DataFrame(uCSV.read(IOBuffer(s), delim=';', colparsers=Dict(1 => x -> imperialize(x), 2 => x -> imperialize(x))))
1×3 DataFrames.DataFrame
│ Row │ x1    │ x2   │ x3  │
├─────┼───────┼──────┼─────┤
│ 1   │ 19.97 │ 3.14 │ 999 │
```
