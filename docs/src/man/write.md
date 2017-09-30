# Writing Data

`uCSV.write` supports writing generic datasets as well as writing `DataFrames`

```jldoctest
julia> using uCSV, DataFrames, CodecZlib, Nulls

julia> df = DataFrame(uCSV.read(GzipDecompressionStream(open(joinpath(Pkg.dir("uCSV"), "test", "data", "iris.csv.gz"))), header=1));

julia> head(df)
6×6 DataFrames.DataFrame
│ Row │ Id │ SepalLengthCm │ SepalWidthCm │ PetalLengthCm │ PetalWidthCm │ Species     │
├─────┼────┼───────────────┼──────────────┼───────────────┼──────────────┼─────────────┤
│ 1   │ 1  │ 5.1           │ 3.5          │ 1.4           │ 0.2          │ Iris-setosa │
│ 2   │ 2  │ 4.9           │ 3.0          │ 1.4           │ 0.2          │ Iris-setosa │
│ 3   │ 3  │ 4.7           │ 3.2          │ 1.3           │ 0.2          │ Iris-setosa │
│ 4   │ 4  │ 4.6           │ 3.1          │ 1.5           │ 0.2          │ Iris-setosa │
│ 5   │ 5  │ 5.0           │ 3.6          │ 1.4           │ 0.2          │ Iris-setosa │
│ 6   │ 6  │ 5.4           │ 3.9          │ 1.7           │ 0.4          │ Iris-setosa │

julia> outpath = joinpath(Pkg.dir("uCSV"), "test", "temp.txt");

julia> uCSV.write(outpath, header = string.(names(df)), data = df.columns)

julia> for line in readlines(open(outpath))[1:5]
          println(line)
       end
Id,SepalLengthCm,SepalWidthCm,PetalLengthCm,PetalWidthCm,Species
1,5.1,3.5,1.4,0.2,Iris-setosa
2,4.9,3.0,1.4,0.2,Iris-setosa
3,4.7,3.2,1.3,0.2,Iris-setosa
4,4.6,3.1,1.5,0.2,Iris-setosa

julia> uCSV.write(outpath, df)

julia> for line in readlines(open(outpath))[1:5]
          println(line)
       end
Id,SepalLengthCm,SepalWidthCm,PetalLengthCm,PetalWidthCm,Species
1,5.1,3.5,1.4,0.2,Iris-setosa
2,4.9,3.0,1.4,0.2,Iris-setosa
3,4.7,3.2,1.3,0.2,Iris-setosa
4,4.6,3.1,1.5,0.2,Iris-setosa

```

Users can specify delimiters other than `','`
```jldoctest
ulia> using uCSV, DataFrames, CodecZlib, Nulls

julia> df = DataFrame(uCSV.read(GzipDecompressionStream(open(joinpath(Pkg.dir("uCSV"), "test", "data", "iris.csv.gz"))), header=1));

julia> outpath = joinpath(Pkg.dir("uCSV"), "test", "temp.txt");

julia> uCSV.write(outpath, df, delim='\t')

julia> for line in readlines(open(outpath))[1:5]
          println(line)
       end
Id	SepalLengthCm	SepalWidthCm	PetalLengthCm	PetalWidthCm	Species
1	5.1	3.5	1.4	0.2	Iris-setosa
2	4.9	3.0	1.4	0.2	Iris-setosa
3	4.7	3.2	1.3	0.2	Iris-setosa
4	4.6	3.1	1.5	0.2	Iris-setosa

```

Quotes can also be requested, and by default they apply only to `String` (and `Union{String, Null}`) columns and the header
```jldoctest
julia> using uCSV, DataFrames, CodecZlib, Nulls

julia> df = DataFrame(uCSV.read(GzipDecompressionStream(open(joinpath(Pkg.dir("uCSV"), "test", "data", "iris.csv.gz"))), header=1));

julia> outpath = joinpath(Pkg.dir("uCSV"), "test", "temp.txt");

julia> uCSV.write(outpath, df, quotes='"')

julia> for line in readlines(open(outpath))[1:5]
          println(line)
       end
"Id","SepalLengthCm","SepalWidthCm","PetalLengthCm","PetalWidthCm","Species"
1,5.1,3.5,1.4,0.2,"Iris-setosa"
2,4.9,3.0,1.4,0.2,"Iris-setosa"
3,4.7,3.2,1.3,0.2,"Iris-setosa"
4,4.6,3.1,1.5,0.2,"Iris-setosa"


julia> # columns that are Union{T, Null} where T <: quotetypes also works
       df_with_nulls = deepcopy(df);

julia> df_with_nulls[6] = convert(Vector{Union{String, Null}}, df_with_nulls[6]);

julia> df_with_nulls[6][2:3] = null;

julia> uCSV.write(outpath, df_with_nulls, quotes='"')

julia> for line in readlines(open(outpath))[1:5]
          println(line)
       end
"Id","SepalLengthCm","SepalWidthCm","PetalLengthCm","PetalWidthCm","Species"
1,5.1,3.5,1.4,0.2,"Iris-setosa"
2,4.9,3.0,1.4,0.2,"null"
3,4.7,3.2,1.3,0.2,"null"
4,4.6,3.1,1.5,0.2,"Iris-setosa"

julia> # but not if the column is ONLY nulls
       df_with_nulls[6] = nulls(size(df_with_nulls, 1));

julia> uCSV.write(outpath, df_with_nulls, quotes='"')

julia> for line in readlines(open(outpath))[1:5]
          println(line)
       end
"Id","SepalLengthCm","SepalWidthCm","PetalLengthCm","PetalWidthCm","Species"
1,5.1,3.5,1.4,0.2,null
2,4.9,3.0,1.4,0.2,null
3,4.7,3.2,1.3,0.2,null
4,4.6,3.1,1.5,0.2,null
```

To quote every field in the dataset or other custom rules, use the `quotetypes` argument
```jldoctest
julia> using uCSV, DataFrames, CodecZlib, Nulls

julia> df = DataFrame(uCSV.read(GzipDecompressionStream(open(joinpath(Pkg.dir("uCSV"), "test", "data", "iris.csv.gz"))), header=1));

julia> outpath = joinpath(Pkg.dir("uCSV"), "test", "temp.txt");

julia> uCSV.write(outpath, df, quotes='"', quotetypes=Any)

julia> for line in readlines(open(outpath))[1:5]
          println(line)
       end
"Id","SepalLengthCm","SepalWidthCm","PetalLengthCm","PetalWidthCm","Species"
"1","5.1","3.5","1.4","0.2","Iris-setosa"
"2","4.9","3.0","1.4","0.2","Iris-setosa"
"3","4.7","3.2","1.3","0.2","Iris-setosa"
"4","4.6","3.1","1.5","0.2","Iris-setosa"

julia> uCSV.write(outpath, df, quotes='"', quotetypes=Real)

julia> for line in readlines(open(outpath))[1:5]
          println(line)
       end
"Id","SepalLengthCm","SepalWidthCm","PetalLengthCm","PetalWidthCm","Species"
"1","5.1","3.5","1.4","0.2",Iris-setosa
"2","4.9","3.0","1.4","0.2",Iris-setosa
"3","4.7","3.2","1.3","0.2",Iris-setosa
"4","4.6","3.1","1.5","0.2",Iris-setosa

```
