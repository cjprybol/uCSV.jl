# Reading Compressed Datasets

Using the [TranscodingStreams.jl](https://github.com/bicycle1885/TranscodingStreams.jl#codec-packages) ecosystem of packages is the currently recommended approach, although other methods should work as well!
```jldoctest
julia> using uCSV, DataFrames, CodecZlib

julia> iris_file = joinpath(Pkg.dir("uCSV"), "test", "data", "iris.csv.gz");

julia> iris_io = GzipDecompressionStream(open(iris_file));

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
