# Benchmarks

Note these are not exhaustive, but I've done by best to cover various common formats and to ensure that all of the readers output the data using standard Julia Vectors and Types for accurate comparison. This does not necessarily reflect the strengths or weaknesses of the other packages relative to uCSV.

## Read

### Setup

All data will be read into equivalent DataFrames
```julia
using uCSV, CSV, TextParse, CodecZlib, Nulls, DataFrames, Base.Test
GDS = GzipDecompressionStream;

function textparse2DF(x)
    DataFrame(Any[x[1]...], Symbol.(x[2]))
end
```

### [Iris](https://github.com/cjprybol/uCSV.jl/blob/master/test/data/iris.csv.gz)
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

### [0s-1s](https://github.com/cjprybol/uCSV.jl/blob/master/test/data/0s-1s.csv.gz)
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

### [Flights](https://github.com/cjprybol/uCSV.jl/blob/master/test/data/2010_BSA_Carrier_PUF.csv.gz)
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

### [Human Genome Feature Format](https://github.com/cjprybol/uCSV.jl/blob/master/test/data/Homo_sapiens.GRCh38.90.gff3.gz)
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

### [Country Indicators](https://github.com/cjprybol/uCSV.jl/blob/master/test/data/indicators.csv.gz)
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

### [Yellow Taxi](https://s3.amazonaws.com/nyc-tlc/trip+data/yellow_tripdata_2015-01.csv)
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

## Write

If you're interested in seeing this, let me know by filing an issue or by running some comparisons yourself and opening a PR with the results!
