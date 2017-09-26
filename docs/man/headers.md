# Headers

Headers can either be supplied as an integer indicating which line of the dataset should be parsed as the column names.
```jldoctest
julia> using uCSV

julia> s =
       """
       c1,c2,c3
       1,1.0,a
       2,2.0,b
       3,3.0,c
       """;

julia> data, header = uCSV.read(IOBuffer(s), header = 1);

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

The user can also supply their own names
```jldoctest
julia> using uCSV, DataFrames

julia> s =
       """
       1,1.0,a
       2,2.0,b
       3,3.0,c
       """;

julia> DataFrame(uCSV.read(IOBuffer(s), header = ["Ints", "Floats", "Strings"]))
3×3 DataFrames.DataFrame
│ Row │ Ints │ Floats │ Strings │
├─────┼──────┼────────┼─────────┤
│ 1   │ 1    │ 1.0    │ a       │
│ 2   │ 2    │ 2.0    │ b       │
│ 3   │ 3    │ 3.0    │ c       │

```
