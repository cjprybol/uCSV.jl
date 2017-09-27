# Declaring Column Vector Types

```@contents
```
## CategoricalArrays

Declaring all columns should be parsed as CategoricalArrays
```jldoctest
julia> using uCSV, DataFrames

julia> s =
       """
       a,b,c
       a,b,c
       a,b,c
       a,b,c
       """;

julia> eltype.(DataFrame(uCSV.read(IOBuffer(s), iscategorical=true)).columns)
3-element Array{DataType,1}:
 CategoricalArrays.CategoricalValue{String,UInt32}
 CategoricalArrays.CategoricalValue{String,UInt32}
 CategoricalArrays.CategoricalValue{String,UInt32}

```

Declaring whether each column should be a CategoricalArray or not
```jldoctest
julia> using uCSV, DataFrames

julia> s =
       """
       a,b,c
       a,b,c
       a,b,c
       a,b,c
       """;

julia> eltype.(DataFrame(uCSV.read(IOBuffer(s), iscategorical=[true, true, true])).columns)
3-element Array{DataType,1}:
 CategoricalArrays.CategoricalValue{String,UInt32}
 CategoricalArrays.CategoricalValue{String,UInt32}
 CategoricalArrays.CategoricalValue{String,UInt32}

```

Declaring whether specific columns should be CategoricalArrays by index
```jldoctest
julia> using uCSV, DataFrames

julia> s =
       """
       a,b,c
       a,b,c
       a,b,c
       a,b,c
       """;

julia> eltype.(DataFrame(uCSV.read(IOBuffer(s), iscategorical=Dict(3 => true))).columns)
3-element Array{DataType,1}:
 String
 String
 CategoricalArrays.CategoricalValue{String,UInt32}

```

Declaring whether specific columns should be CategoricalArrays by column name
```jldoctest
julia> using uCSV, DataFrames

julia> s =
       """
       a,b,c
       a,b,c
       a,b,c
       a,b,c
       """;

julia> eltype.(DataFrame(uCSV.read(IOBuffer(s), header=1, iscategorical=Dict("a" => true))).columns)
3-element Array{DataType,1}:
 CategoricalArrays.CategoricalValue{String,UInt32}
 String
 String

```

## Other Vector Types

### TODO
