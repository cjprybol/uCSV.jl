using uCSV, HTTP, CodecZlib, DataFrames, RDatasets, Base.Test, Nulls

s =
"""
1,1.0,a
2,2.0,b
3,3.0,c
"""
data, header = uCSV.read(IOBuffer(s))
@test data == Any[[1, 2, 3],
                  [1.0, 2.0, 3.0],
                  ["a", "b", "c"]]
@test header == Vector{String}()

s =
"""
1.0,1.0,1.0
2.0,2.0,2.0
3.0,3.0,3.0
"""
data, header = uCSV.read(IOBuffer(s))
@test data ==  Any[[1.0, 2.0, 3.0],
                   [1.0, 2.0, 3.0],
                   [1.0, 2.0, 3.0]]
@test header == Vector{String}()

s =
"""
c1,c2,c3
1,1.0,a
2,2.0,b
3,3.0,c
"""
data, header = uCSV.read(IOBuffer(s))
@test data == Any[["c1", "1", "2", "3"],
                  ["c2", "1.0", "2.0", "3.0"],
                  ["c3", "a", "b", "c"]]
@test header == Vector{String}()


data, header = uCSV.read(IOBuffer(s), header = 1)
@test data == Any[[1, 2, 3],
                  [1.0, 2.0, 3.0],
                  ["a", "b", "c"]]
@test header == ["c1", "c2", "c3"]

s =
"""
1997,Ford,E350
"""
data, header = uCSV.read(IOBuffer(s))
@test data == Any[[1997],
                  ["Ford"],
                  ["E350"]]
@test header == Vector{String}()

s =
"""
1997,Ford,E350
"""
data, header = uCSV.read(IOBuffer(s), header = 1)
@test data == Any[]
@test header == ["1997", "Ford", "E350"]

s =
"""
1997,Ford,E350\n
"""
data, header = uCSV.read(IOBuffer(s))
@test data == Any[[1997],
                  ["Ford"],
                  ["E350"]]
@test header == Vector{String}()

s =
"""
"1997","Ford","E350"
"""
data, header = uCSV.read(IOBuffer(s))
@test data == Any[["\"1997\""],
                  ["\"Ford\""],
                  ["\"E350\""]]
@test header == Vector{String}()

s =
"""
"1997","Ford","E350"
"""
data, header = uCSV.read(IOBuffer(s), quotes='"')
@test data == Any[["1997"],
                  ["Ford"],
                  ["E350"]]
@test header == Vector{String}()

s =
"""
"19"97,"Fo"rd,E3"50"
"""
data, header = uCSV.read(IOBuffer(s))
@test data == Any[["\"19\"97"],
                  ["\"Fo\"rd"],
                  ["E3\"50\""]]
@test header == Vector{String}()

s =
"""
\"\"\"1997\"\"\",\"Ford\",\"E350\"
"""
data, header = uCSV.read(IOBuffer(s))
@test data == Any[["\"\"\"1997\"\"\""],
                  ["\"Ford\""],
                  ["\"E350\""]]
@test header == Vector{String}()

data, header = uCSV.read(IOBuffer(s), quotes='"')
@test data == Any[["1997"],
                  ["Ford"],
                  ["E350"]]
@test header == Vector{String}()

data, header = uCSV.read(IOBuffer(s), quotes='"', escape='"')
@test data == Any[["\"1997\""],
                  ["Ford"],
                  ["E350"]]
@test header == Vector{String}()


s =
"""
1997,Ford,E350,"Super, luxurious truck"
"""
data, header = uCSV.read(IOBuffer(s))
@test data == Any[[1997],
                  ["Ford"],
                  ["E350"],
                  ["\"Super"],
                  [" luxurious truck\""]]
@test header == Vector{String}()

data, header = uCSV.read(IOBuffer(s), quotes='"')
@test data == Any[[1997],
                  ["Ford"],
                  ["E350"],
                  ["Super, luxurious truck"]]
@test header == Vector{String}()

s =
"""
1997,Ford,E350,"Super,, luxurious truck"
"""
data, header = uCSV.read(IOBuffer(s), quotes='"')
@test data == Any[[1997],
                  ["Ford"],
                  ["E350"],
                  ["Super,, luxurious truck"]]
@test header == Vector{String}()

s =
"""
1997,Ford,E350,"Super,,, luxurious truck"
"""
data, header = uCSV.read(IOBuffer(s), quotes='"')
@test data == Any[[1997],
                  ["Ford"],
                  ["E350"],
                  ["Super,,, luxurious truck"]]
@test header == Vector{String}()

s =
"""
1997,Ford,E350,Super\\, luxurious truck
"""
data, header = uCSV.read(IOBuffer(s), escape='\\')
@test data == Any[[1997],
                  ["Ford"],
                  ["E350"],
                  ["Super, luxurious truck"]]
@test header == Vector{String}()

s =
"""
1997,Ford,E350,Super\\,\\, luxurious truck
"""
data, header = uCSV.read(IOBuffer(s), escape='\\')
@test data == Any[[1997],
                  ["Ford"],
                  ["E350"],
                  ["Super,, luxurious truck"]]
@test header == Vector{String}()

s =
"""
1997,Ford,E350,Super\\,\\,\\, luxurious truck
"""
data, header = uCSV.read(IOBuffer(s), escape='\\')
@test data == Any[[1997],
                  ["Ford"],
                  ["E350"],
                  ["Super,,, luxurious truck"]]
@test header == Vector{String}()


s = "1997,Ford,E350,\"Super, \"\"luxurious\"\" truck\""
data, header = uCSV.read(IOBuffer(s), quotes='"', escape='"')
@test data == Any[[1997],
                  ["Ford"],
                  ["E350"],
                  ["Super, \"luxurious\" truck"]]
@test header == Vector{String}()

s =
"""
1997,Ford,E350,"Super, \\\"luxurious\\\" truck"
"""
data, header = uCSV.read(IOBuffer(s), quotes='"', escape='\\')
@test data == Any[[1997],
                  ["Ford"],
                  ["E350"],
                  ["Super, \"luxurious\" truck"]]
@test header == Vector{String}()

s =
"""
1997,Ford,E350,Super "luxurious" truck
"""
data, header = uCSV.read(IOBuffer(s))
@test data == Any[[1997],
                  ["Ford"],
                  ["E350"],
                  ["Super \"luxurious\" truck"]]
@test header == Vector{String}()

s =
"""
19,97;Ford;E350;Super "luxurious" truck
"""
data, header = uCSV.read(IOBuffer(s), delim=';', colparsers=Dict(1 => x -> parse(Float64, replace(x, ',', '.'))))
@test data == Any[[19.97],
                  ["Ford"],
                  ["E350"],
                  ["Super \"luxurious\" truck"]]
@test header == Vector{String}()

data, header = uCSV.read(IOBuffer(s),
                         delim=';',
                         types=Dict(1 => Float64),
                         typeparsers=Dict(Float64 => x -> parse(Float64, replace(x, ',', '.'))))
@test data == Any[[19.97],
                  ["Ford"],
                  ["E350"],
                  ["Super \"luxurious\" truck"]]
@test header == Vector{String}()


s = "1997,Ford,E350,\"Go get one now\nthey are going fast\""
data, header = uCSV.read(IOBuffer(s), quotes='"')
@test data == Any[[1997],
                  ["Ford"],
                  ["E350"],
                  ["Go get one now\nthey are going fast"]]
@test header == Vector{String}()

s = "1997,Ford,E350,\"Go get one now\n\nthey are going fast\""
data, header = uCSV.read(IOBuffer(s), quotes='"')
@test data == Any[[1997],
                  ["Ford"],
                  ["E350"],
                  ["Go get one now\n\nthey are going fast"]]
@test header == Vector{String}()

s =
"""
1997,Ford,E350,"Go get one now\\nthey are going fast"
"""
data, header = uCSV.read(IOBuffer(s), quotes='"')
@test data == Any[[1997],
                  ["Ford"],
                  ["E350"],
                  ["Go get one now\\nthey are going fast"]]
@test header == Vector{String}()

s =
"""
1997, Ford, E350
"""
data, header = uCSV.read(IOBuffer(s))
@test data == Any[[1997],
                  [" Ford"],
                  [" E350"]]
@test header == Vector{String}()

data, header = uCSV.read(IOBuffer(s), trimwhitespace=true)
@test data == Any[[1997],
                  ["Ford"],
                  ["E350"]]
@test header == Vector{String}()

s =
"""
1997, "Ford" ,E350
"""
data, header = uCSV.read(IOBuffer(s))
@test data == Any[[1997],
                  [" \"Ford\" "],
                  ["E350"]]
@test header ==  Vector{String}()

data, header = uCSV.read(IOBuffer(s), trimwhitespace=true)
@test data == Any[[1997],
                  ["\"Ford\""],
                  ["E350"]]
@test header ==  Vector{String}()

data, header = uCSV.read(IOBuffer(s), quotes='"')
@test data == Any[[1997],
                  [" Ford "],
                  ["E350"]]
@test header ==  Vector{String}()

data, header = uCSV.read(IOBuffer(s), quotes='"', trimwhitespace=true)
@test data == Any[[1997],
                  ["Ford"],
                  ["E350"]]
@test header ==  Vector{String}()


s =
"""
1997,Ford,E350," Super luxurious truck "
"""
data, header = uCSV.read(IOBuffer(s))
@test data == Any[[1997],
                  ["Ford"],
                  ["E350"],
                  ["\" Super luxurious truck \""]]
@test header ==  Vector{String}()

data, header = uCSV.read(IOBuffer(s), quotes='"')
@test data == Any[[1997],
                  ["Ford"],
                  ["E350"],
                  [" Super luxurious truck "]]
@test header ==  Vector{String}()

data, header = uCSV.read(IOBuffer(s), quotes='"', trimwhitespace=true)
@test data == Any[[1997],
                  ["Ford"],
                  ["E350"],
                  [" Super luxurious truck "]]
@test header ==  Vector{String}()

s =
"""
Los Angeles,34°03′N,118°15′W
"""
data, header = uCSV.read(IOBuffer(s))
@test data == Any[["Los Angeles"],
                  ["34°03′N"],
                  ["118°15′W"]]
@test header == Vector{String}()

s =
"""
New York City,40°42′46″N,74°00′21″W
"""
data, header = uCSV.read(IOBuffer(s))
@test data == Any[["New York City"],
                  ["40°42′46″N"],
                  ["74°00′21″W"]]
@test header == Vector{String}()

s =
"""
Paris,48°51′24″N,2°21′03″E
"""
data, header = uCSV.read(IOBuffer(s))
@test data == Any[["Paris"],
                  ["48°51′24″N"],
                  ["2°21′03″E"]]
@test header == Vector{String}()

s =
"""
x≤y≤z
"""
data, header = uCSV.read(IOBuffer(s), delim='≤')
@test data == Any[["x"],
                  ["y"],
                  ["z"]]
@test header == Vector{String}()

s =
"""
x≤≥y≤≥z
"""
data, header = uCSV.read(IOBuffer(s), delim="≤≥")
@test data == Any[["x"],
                  ["y"],
                  ["z"]]
@test header == Vector{String}()

s =
"""
2013-01-01T00:00:00
"""
data, header = uCSV.read(IOBuffer(s), types=DateTime)
@test data == Any[[DateTime("2013-01-01T00:00:00")]]
@test header == Vector{String}()

s =
"""
2013-01-01
"""
data, header = uCSV.read(IOBuffer(s), types=Date)
@test data == Any[[Date("2013-01-01")]]
@test header == Vector{String}()


encodings = Dict{String, Any}("" => null, "\"\"" => null, "NULL" => null, "NA" => null)
s =
"""
1,hey,1
2,you,2
3,,3
4,"",4
5,NULL,5
6,NA,6
"""
data, header = uCSV.read(IOBuffer(s), encodings=encodings, typedetectrows=3)
@test data == Any[[1, 2, 3, 4, 5, 6],
                  ["hey", "you", null, null, null, null],
                  [1, 2, 3, 4, 5, 6]]
@test header == Vector{String}()

uCSV.read(IOBuffer(s), encodings=encodings, isnullable=true)
@test data == Any[[1, 2, 3, 4, 5, 6],
                  ["hey", "you", null, null, null, null],
                  [1, 2, 3, 4, 5, 6]]
@test header == Vector{String}()

uCSV.read(IOBuffer(s), encodings=encodings, isnullable=Dict(2 => true))
@test data == Any[[1, 2, 3, 4, 5, 6],
                  ["hey", "you", null, null, null, null],
                  [1, 2, 3, 4, 5, 6]]
@test header == Vector{String}()

uCSV.read(IOBuffer(s), encodings=encodings, isnullable=[false, true, false])
@test data == Any[[1, 2, 3, 4, 5, 6],
                  ["hey", "you", null, null, null, null],
                  [1, 2, 3, 4, 5, 6]]
@test header == Vector{String}()

@test_throws ArgumentError uCSV.read(IOBuffer(s), encodings=encodings, isnullable=[false, true])

html = "https://raw.github.com/vincentarelbundock/Rdatasets/master/csv/datasets/USPersonalExpenditure.csv"
data, header = uCSV.read(HTTP.body(HTTP.get(html)), quotes='"', header=1)
@test data == Any[["Food and Tobacco", "Household Operation", "Medical and Health", "Personal Care", "Private Education"],
                  [22.2, 10.5, 3.53, 1.04, 0.341],
                  [44.5, 15.5, 5.76, 1.98, 0.974],
                  [59.6, 29.0, 9.71, 2.45, 1.8],
                  [73.2, 36.5, 14.0, 3.4, 2.6],
                  [86.8, 46.2, 21.1, 5.4, 3.64]]
@test header == String["", "1940", "1945", "1950", "1955", "1960"]

s =
"""
# i am a comment
data
"""
data, header = uCSV.read(IOBuffer(s), comment='#')
@test data == Any[["data"]]
@test header == Vector{String}()

s =
"""
# i am a comment
I'm the header
"""
data, header = uCSV.read(IOBuffer(s), header=2)
@test data == Any[]
@test header == ["I'm the header"]

data, header = uCSV.read(IOBuffer(s), comment='#', header=1)
@test data == Any[]
@test header == ["I'm the header"]

s =
"""
# i am a comment
I'm the header
skipped data
included data
"""
data, header = uCSV.read(IOBuffer(s), comment='#', header=1, skiprows=1:1)
@test data == Any[["included data"]]
@test header == ["I'm the header"]

s =
"""
# i am a comment
I'm the header
skipped data
included data
"""
data, header = uCSV.read(IOBuffer(s), skiprows=1:3)
@test data == Any[["included data"]]
@test header == Vector{String}()

s =
"""
a,b,c
a,b,c
a,b,c
a,b,c
"""
data, header = uCSV.read(IOBuffer(s), iscategorical=true)
@test data == Any[CategoricalVector(["a", "a", "a", "a"]),
                  CategoricalVector(["b", "b", "b", "b"]),
                  CategoricalVector(["c", "c", "c", "c"])]
@test header == Vector{String}()

data, header = uCSV.read(IOBuffer(s), iscategorical=[true, true, true])
@test data == Any[CategoricalVector(["a", "a", "a", "a"]),
                  CategoricalVector(["b", "b", "b", "b"]),
                  CategoricalVector(["c", "c", "c", "c"])]
@test header == Vector{String}()

data, header = uCSV.read(IOBuffer(s), iscategorical=Dict(1 => true, 2 => true, 3 => true))
@test data == Any[CategoricalVector(["a", "a", "a", "a"]),
                  CategoricalVector(["b", "b", "b", "b"]),
                  CategoricalVector(["c", "c", "c", "c"])]
@test header == Vector{String}()

data, header = uCSV.read(IOBuffer(s), header=1, iscategorical=Dict("a" => true, "b" => true, "c" => true))
@test data == Any[CategoricalVector(["a", "a", "a"]),
                  CategoricalVector(["b", "b", "b"]),
                  CategoricalVector(["c", "c", "c"])]
@test header == ["a", "b", "c"]

s =
"""
A;B;C
1,1,10
2,0,16
"""
e = @test_throws ErrorException uCSV.read(IOBuffer(s))
@test e.value.msg == "Parsed 3 fields on row 2. Expected 1.\nPossible fixes may include:\n  1. including 2 in the `skiprows` argument\n  2. setting `skipmalformed=true`\n  3. if this line is a comment, set the `comment` argument\n  4. fixing the malformed line in the source or file\n"

e = @test_throws ErrorException uCSV.read(IOBuffer(s), header = 1)
@test e.value.msg == "parsed header String[\"A;B;C\"] has 1 columns, but 3 were detected the in dataset.\n"

s =
"""
A,B,C
1,1,10
6,1
"""
e = @test_throws ErrorException uCSV.read(IOBuffer(s))
@test e.value.msg == "Parsed 2 fields on row 3. Expected 3.\nPossible fixes may include:\n  1. including 3 in the `skiprows` argument\n  2. setting `skipmalformed=true`\n  3. if this line is a comment, set the `comment` argument\n  4. fixing the malformed line in the source or file\n"

s =
"""
true
"""
data, header = uCSV.read(IOBuffer(s), types=Bool)
@test data == Any[[true]]
@test header == Vector{String}()

# TODO make this @__FILE__
files = joinpath(Pkg.dir("uCSV"), "test", "data")
df = DataFrame(uCSV.read(GzipDecompressionStream(open(joinpath(files, "iris.csv.gz"))), header=1)...)
@test head(df, 1) == DataFrame(Id = 1,
                               SepalLengthCm = 5.1,
                               SepalWidthCm = 3.5,
                               PetalLengthCm = 1.4,
                               PetalWidthCm = 0.2,
                               Species = "Iris-setosa")


# write data
# write header
# write header and data
# write nothing
# write header and data with quotes

# test on local files

#test on RDatasets files
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/COUNT/loomis.csv.gz #NA's with bools
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/COUNT/titanic.csv.gz #categorical int
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/Ecdat/Clothing.csv.gz # quoted headers
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/Ecdat/Garch.csv.gz # encode and transform days of week
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/Ecdat/Grunfeld.csv.gz # parse year
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/Ecdat/Icecream.csv.gz # F -> C transform
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/Ecdat/MCAS.csv.gz # diverse data types
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/Ecdat/RetSchool.csv.gz # NAs
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/Ecdat/TranspEq.csv.gz # encode states as two letters
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/Ecdat/incomeInequality.csv.gz # like it
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/HSAUR/aspirin.csv.gz # ugly bibtex citations
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/HSAUR/birthdeathrates.csv.gz # recode countries
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/HSAUR/heptathlon.csv.gz # transform countries, names
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/HSAUR/meteo.csv.gz # year range
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/HSAUR/pottery.csv.gz # recode column names, transform to Kevlin
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/HSAUR/rearrests.csv.gz # convert to Freq Table
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/HSAUR/smoking.csv.gz # encode ugly bibtex
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/HSAUR/voting.csv.gz # split into republican and democrat
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/HistData/Jevons.csv.gz # multiple error encodings
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/HistData/Minard.temp.csv.gz # strange date parsing
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/HistData/Snow.pumps.csv.gz # missing values
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/HistData/Wheat.monarchs.csv.gz # dates and roman numerals
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/KMsurv/baboon.csv.gz # more dates
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/KMsurv/bcdeter.csv.gz # NA's after row detect
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/KMsurv/kidtran.csv.gz # boolean encodings and age groupings
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/KMsurv/pneumon.csv.gz # lots of fun encodings
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/MASS/Boston.csv.gz
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/MASS/beav1.csv.gz # day time conversions
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/MASS/beav2.csv.gz # day time conversions
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/MASS/caith.csv.gz # freqtable fun
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/MASS/cpus.csv.gz # cpu names and convert memory
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/MASS/mammals.csv.gz # animal name conversions
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/MASS/newcomb.csv.gz # int parsing
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/MASS/npr1.csv.gz # make sure column one doesn't parse as int
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/MASS/road.csv.gz # state encodings
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/MASS/waders.csv.gz # read letter as char
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/Zelig/SupremeCourt.csv.gz # nullable bit array
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/Zelig/approval.csv.gz # month year
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/Zelig/immigration.csv.gz # lots of NAs
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/adehabitatLT/albatross.csv.gz # fun dates and 0 in R2n followed by floats !!maybe drop!!
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/adehabitatLT/bear.csv.gz # same as above but even better
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/adehabitatLT/buffalo.csv.gz # again
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/adehabitatLT/whale.csv.gz # ugly again
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/boot/acme.csv.gz # month parse
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/boot/coal.csv.gz # what kind of date is this?
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/boot/neuro.csv.gz # lots of NAs
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/car/Anscombe.csv.gz # state conversions
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/car/Depredations.csv.gz # convert lat long into something else
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/car/Florida.csv.gz # counties to lowercase & dots to spaces
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/car/Freedman.csv.gz # dots to spaces
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/cluster/animals.csv.gz
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/cluster/votes.repub.csv.gz # headers to dates
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/datasets/HairEyeColor.csv.gz # categorical recode
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/datasets/Titanic.csv.gz # categorical recode
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/datasets/UCBAdmissions.csv.gz # categorical recode
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/datasets/USJudgeRatings.csv.gz # judge name processing
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/datasets/VADeaths.csv.gz # age range
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/datasets/mtcars.csv.gz # have to
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/datasets/randu.csv.gz # exponential parsing of numerics
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/gap/PD.csv.gz # so ugly
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/gap/lukas.csv.gz # MF sex recoding
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/gap/mao.csv.gz # Int and Int/Int
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/ggplot2/economics.csv.gz # more dates
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/ggplot2/presidential.csv.gz # more dates
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/plyr/baseball.csv.gz # lots of NAs
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/pscl/ca2006.csv.gz # true false encodings
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/pscl/presidentialElections.csv.gz # different true false
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/pscl/UKHouseOfCommons.csv.gz
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/psych/Reise.csv.gz # make headers and first column the same
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/psych/Schmid.csv.gz # another freqtable
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/psych/Thurstone.csv.gz # another freqtable with recodings
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/psych/bfi.csv.gz # late NAs
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/psych/neo.csv.gz # freqtable recodings
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/robustbase/Animals2.csv.gz # unsure
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/robustbase/ambientNOxCH.csv.gz # scattered NAs
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/robustbase/condroz.csv.gz # fun pH conversion
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/robustbase/education.csv.gz # state recodings
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/sem/Tests.csv.gz # late NAs
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/survival/lung.csv.gz # 1-2 status and late NAs
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/vcd/Bundesliga.csv.gz # year column & date column!
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/vcd/Employment.csv.gz # employment length
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/vcd/PreSex.csv.gz # lots of encodings
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/vcd/RepVict.csv.gz # FreqTable
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/vcd/Lifeboats.csv.gz # dates
