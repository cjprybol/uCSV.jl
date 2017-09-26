# Missing Data

Missing data is very common in many fields of work, but not all fields of work. In addition, users may want to handle different encodings for missing data differently, e.g. if a datum is missing from the dataset or if it has been masked for privacy reasons. Because of this, uCSV requires that users provide arguments that instruct `uCSV.read` how they would like missing data to be parsed, in which columns it should be parsed, or how many rows should be read to automatically detect nulls values encoded by the user.

Detecting columns that contain missing values via `typedetectrows`
```jldoctest
julia> using uCSV, DataFrames, Nulls

julia> s =
       """
       1,hey,1
       2,you,2
       3,,3
       4,"",4
       5,NULL,5
       6,NA,6
       """;

julia> encodings = Dict{String, Any}("" => null, "\"\"" => null, "NULL" => null, "NA" => null);

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

```

Declaring that all columns may contain missing values
```jldoctest
using uCSV, DataFrames, Nulls
s =
"""
1,hey,1
2,you,2
3,,3
4,"",4
5,NULL,5
6,NA,6
""";
encodings = Dict{String, Any}("" => null, "\"\"" => null, "NULL" => null, "NA" => null);
DataFrame(uCSV.read(IOBuffer(s), encodings=encodings, isnullable=true))
```

Declaring whether each column may contain missing values with a boolean vector
```jldoctest
julia> using uCSV, DataFrames, Nulls

julia> s =
       """
       1,hey,1
       2,you,2
       3,,3
       4,"",4
       5,NULL,5
       6,NA,6
       """;

julia> encodings = Dict{String, Any}("" => null, "\"\"" => null, "NULL" => null, "NA" => null);

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

```

Declaring the nullability of a subset of columns with a Dictionary (keys are column indices)
```jldoctest
julia> using uCSV, DataFrames, Nulls

julia> s =
       """
       1,hey,1
       2,you,2
       3,,3
       4,"",4
       5,NULL,5
       6,NA,6
       """;

julia> encodings = Dict{String, Any}("" => null, "\"\"" => null, "NULL" => null, "NA" => null);

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

```

Declaring the nullability of a subset of columns with a Dictionary (keys are column names)
```jldoctest
julia> using uCSV, DataFrames, Nulls

julia> s =
       """
       a,b,c
       1,hey,1
       2,you,2
       3,,3
       4,"",4
       5,NULL,5
       6,NA,6
       """;

julia> encodings = Dict{String, Any}("" => null, "\"\"" => null, "NULL" => null, "NA" => null);

julia> DataFrame(uCSV.read(IOBuffer(s), encodings=encodings, header=1, isnullable=Dict("b" => true)))
6×3 DataFrames.DataFrame
│ Row │ a │ b    │ c │
├─────┼───┼──────┼───┤
│ 1   │ 1 │ hey  │ 1 │
│ 2   │ 2 │ you  │ 2 │
│ 3   │ 3 │ null │ 3 │
│ 4   │ 4 │ null │ 4 │
│ 5   │ 5 │ null │ 5 │
│ 6   │ 6 │ null │ 6 │

```

Declaring the type of a subset of columns that can handle missing values
```jldoctest
julia> using uCSV, DataFrames, Nulls

julia> s =
       """
       1,hey,1
       2,you,2
       3,,3
       4,"",4
       5,NULL,5
       6,NA,6
       """;

julia> encodings = Dict{String, Any}("" => null, "\"\"" => null, "NULL" => null, "NA" => null);

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
