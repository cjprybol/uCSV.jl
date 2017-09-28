# Missing Data

Missing data is very common in many fields of research, but not *ALL* fields of research. In addition, users may want to handle different encodings for missing data differently, e.g. encoding data that has been masked/removed for privacy reasons with a different value than data that simply doesn't exist. To enable these distinctions, uCSV requires that users provide arguments that instruct `uCSV.read` how they would like missing data to be parsed, how many rows should be read to automatically detect null values encoded by the user (for setting column types to `Union{T, Null}`), and/or to declare up-front which columns should allow missing values (For cases when the first missing value encountered in a column is many rows into the dataset. Declaring these columns to be nullable up-front and keeping `typedetectrows` set to low values improves parsing performance relative to asking `uCSV.read` to auto-detect columns with missing values via large `typedetectrows` values).

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

Declaring the nullability of a subset of columns by specifying the element-type
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