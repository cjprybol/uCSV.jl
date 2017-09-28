# Declaring Column Vector Types

```@contents
```
## CategoricalArrays & other column types

Declaring all columns should be parsed as CategoricalArrays
```jldoctest
julia> using uCSV, DataFrames, CategoricalArrays

julia> s =
       """
       a,b,c
       a,b,c
       a,b,c
       a,b,c
       """;

julia> eltype.(DataFrame(uCSV.read(IOBuffer(s), coltypes=CategoricalVector)).columns)
3-element Array{DataType,1}:
 CategoricalArrays.CategoricalValue{String,UInt32}
 CategoricalArrays.CategoricalValue{String,UInt32}
 CategoricalArrays.CategoricalValue{String,UInt32}

```

Declaring whether each column should be a CategoricalArray or not
```jldoctest
julia> using uCSV, DataFrames, CategoricalArrays

julia> s =
       """
       a,b,c
       a,b,c
       a,b,c
       a,b,c
       """;

julia> eltype.(DataFrame(uCSV.read(IOBuffer(s), coltypes=fill(CategoricalVector, 3))).columns)
3-element Array{DataType,1}:
 CategoricalArrays.CategoricalValue{String,UInt32}
 CategoricalArrays.CategoricalValue{String,UInt32}
 CategoricalArrays.CategoricalValue{String,UInt32}

```

Declaring whether specific columns should be CategoricalArrays by index
```jldoctest
julia> using uCSV, DataFrames, CategoricalArrays

julia> s =
       """
       a,b,c
       a,b,c
       a,b,c
       a,b,c
       """;

julia> eltype.(DataFrame(uCSV.read(IOBuffer(s), coltypes=Dict(3 => CategoricalVector))).columns)
3-element Array{DataType,1}:
 String
 String
 CategoricalArrays.CategoricalValue{String,UInt32}

```

Declaring whether specific columns should be CategoricalArrays by column name
```jldoctest
julia> using uCSV, DataFrames, CategoricalArrays

julia> s =
       """
       a,b,c
       a,b,c
       a,b,c
       a,b,c
       """;

julia> eltype.(DataFrame(uCSV.read(IOBuffer(s), header=1, coltypes=Dict("a" => CategoricalVector))).columns)
3-element Array{DataType,1}:
 CategoricalArrays.CategoricalValue{String,UInt32}
 String
 String

```
