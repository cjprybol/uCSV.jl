using uCSV, HTTP, CodecZlib, DataFrames, RDatasets, Base.Test, Nulls, StringEncodings

# TODO make this @__FILE__
files = joinpath(Pkg.dir("uCSV"), "test", "data")
GDS = GzipDecompressionStream

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

df = DataFrame(uCSV.read(GzipDecompressionStream(open(joinpath(files, "iris.csv.gz"))), header=1)...)
@test head(df, 1) == DataFrame(Id = 1,
                               SepalLengthCm = 5.1,
                               SepalWidthCm = 3.5,
                               PetalLengthCm = 1.4,
                               PetalWidthCm = 0.2,
                               Species = "Iris-setosa")


if Sys.WORD_SIZE == 64
    outpath = joinpath(Pkg.dir("uCSV"), "test", "temp.txt")
    uCSV.write(outpath, header = string.(names(df)), data = df.columns)
    @test hash(read(open(outpath), String)) == 0x2f6e8bca9d9f43ed

    uCSV.write(outpath, header = string.(names(df)), data = df.columns, quotes='"')
    @test hash(read(open(outpath), String)) == 0x01eced86ce7925c3

    uCSV.write(outpath, header = string.(names(df)), data = df.columns, quotes='"', delim="≤≥")
    @test hash(read(open(outpath), String)) == 0x2cd049ba9cf45178

    uCSV.write(outpath, header = string.(names(df)))
    @test hash(read(open(outpath), String)) == 0x28eea4238d3c772f

    uCSV.write(outpath, data = df.columns)
    @test hash(read(open(outpath), String)) == 0x92a0c4b8ee59a667

    e = @test_throws ArgumentError uCSV.write(outpath)
    @test e.value.msg == "no header or data provided"

    e = @test_throws AssertionError uCSV.write(outpath, header = string.(names(df))[1:2], data = df.columns)
    @test e.value.msg == "length(header) == length(data)"

    rm(outpath)
end

# test on local files

f = joinpath(files, "2010_BSA_Carrier_PUF.csv.gz")
e = @test_throws ErrorException uCSV.read(GDS(open(f)), header=1)
@test e.value.msg == "Error parsing field \"A0425\" in row 2, column 4.\nUnable to parse field \"A0425\" as type Int64\nPossible fixes include:\n  1. set `typedetectrows` to a value >= 2\n  2. manually specify the element-type of column 4 via the `types` argument\n  3. manually specify a parser for column 4 via the `parsers` argument\n  4. if the value is null, setting the `isnullable` argument\n"
df = DataFrame(uCSV.read(GDS(open(f)), header=1, typedetectrows=2)...)
@test names(df) == [:BENE_SEX_IDENT_CD, :BENE_AGE_CAT_CD, :CAR_LINE_ICD9_DGNS_CD, :CAR_LINE_HCPCS_CD, :CAR_LINE_BETOS_CD, :CAR_LINE_SRVC_CNT, :CAR_LINE_PRVDR_TYPE_CD, :CAR_LINE_CMS_TYPE_SRVC_CD, :CAR_LINE_PLACE_OF_SRVC_CD, :CAR_HCPS_PMT_AMT, :CAR_LINE_CNT]
@test size(df) == (2801660, 11)
@test typeof.(df.columns) == [Vector{T} for T in
                              [Int, Int, String, String, String, Int, Int, String, Int, Int, Int]]

f = joinpath(files, "AIRSIGMET.csv.gz")
e = @test_throws ErrorException DataFrame(uCSV.read(GDS(open(f)))...)
@test e.value.msg == "Parsed 12 fields on row 6. Expected 1.\nPossible fixes may include:\n  1. including 6 in the `skiprows` argument\n  2. setting `skipmalformed=true`\n  3. if this line is a comment, set the `comment` argument\n  4. fixing the malformed line in the source or file\n"
data, header = uCSV.read(GDS(open(f)), skipmalformed=true, header=1)
@test data == Any[["No warnings", "285 ms", "data source=airsigmets", "1 results"]]
@test header == ["No errors"]
df = DataFrame(uCSV.read(GDS(open(f)), header=6)...)
@test names(df) == [:raw_text, :valid_time_from, :valid_time_to, Symbol("lon:lat points"), :min_ft_msl, :max_ft_msl, :movement_dir_degrees, :movement_speed_kt, :hazard, :severity, :airsigmet_type, Symbol("")]
@test size(df) == (1, 12)
@test typeof.(df.columns) ==  [Vector{T} for T in
                               [String, String, String, String, Int64, Int64, String, String, String, String, String, String]]

f = joinpath(files, "Ex3_human_rat_cirrhosis_signature_for_NTP.txt.gz")
df = DataFrame(uCSV.read(GDS(open(f)), header=1, delim='\t')...)
@test names(df) == [Symbol("Human.Symbol"), :DESCRIPTION, :cirrhosis1_normal2, Symbol("tstat.high.in.cirrhosis")]
@test size(df) == (1246, 4)
@test typeof.(df.columns) == [Vector{T} for T in
                              [String, String, Int, Float64]]

f = joinpath(files, "Ex4_multi_tissues_signature_for_NTP.txt.gz")
df = DataFrame(uCSV.read(GDS(open(f)), header=1, delim='\t')...)
@test names(df) == [:NAME, :DESCRIPTION, :Br1_Pr2_Lu3_Co4]
@test size(df) == (1603, 3)
@test typeof.(df.columns) == [Vector{T} for T in
                              [String, String, Int]]

# microsoft line endings
f = joinpath(files, "FL_insurance_sample.csv.gz")
e = @test_throws ErrorException uCSV.read(GDS(open(f)), header=1)
@test e.value.msg == "Error parsing field \"1322376.3\" in row 2, column 4.\nUnable to parse field \"1322376.3\" as type Int64\nPossible fixes include:\n  1. set `typedetectrows` to a value >= 2\n  2. manually specify the element-type of column 4 via the `types` argument\n  3. manually specify a parser for column 4 via the `parsers` argument\n"
df = DataFrame(uCSV.read(GDS(open(f)), header=1, typedetectrows=2439)...)
@test names(df) == [:policyID, :statecode, :county, :eq_site_limit, :hu_site_limit, :fl_site_limit, :fr_site_limit, :tiv_2011, :tiv_2012, :eq_site_deductible, :hu_site_deductible, :fl_site_deductible, :fr_site_deductible, :point_latitude, :point_longitude, :line, :construction, :point_granularity]
@test size(df) == (36634, 18)
@test typeof.(df.columns) == [Vector{T} for T in
                              [Int64, String, String, Float64, Float64, Float64, Float64, Float64, Float64, Float64, Float64, Float64, Int64, Float64, Float64, String, String, Int64]]

f = joinpath(files, "Fielding.csv.gz")
e = @test_throws ErrorException uCSV.read(GDS(open(f)), header=1)
@test e.value.msg == "Error parsing field \"\" in row 3460, column 11.\nUnable to parse field \"\" as type Int64\nPossible fixes include:\n  1. set `typedetectrows` to a value >= 3460\n  2. manually specify the element-type of column 11 via the `types` argument\n  3. manually specify a parser for column 11 via the `parsers` argument\n  4. if the value is null, setting the `isnullable` argument\n"

e = @test_throws ArgumentError uCSV.read(GDS(open(f)), header=1, isnullable=Dict(11 => true))
@test e.value.msg == "Nullable columns have been requested but the user has not specified any strings to interpret as null values via the `encodings` argument.\n"
df = DataFrame(uCSV.read(GDS(open(f)), header=1, types=Dict(8 => Int, 9 => Int, 14 => Int, 15 => Int, 16 => Int, 17 => Int, 18 => Int), encodings=Dict{String, Any}("" => null), isnullable=Dict(10 => true, 11 => true, 12 => true, 13 => true))...)
@test names(df) == [:playerID, :yearID, :stint, :teamID, :lgID, :POS, :G, :GS, :InnOuts, :PO, :A, :E, :DP, :PB, :WP, :SB, :CS, :ZR]
@test size(df) == (167938, 18)
@test typeof.(df.columns) == [Vector{T} for T in
                              [String, Int64, Int64, String, String, String, Int64, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}]

f = joinpath(files, "Gaz_zcta_national.txt.gz")
df = DataFrame(uCSV.read(GDS(open(f)), header=1, delim='\t', trimwhitespace=true)...)
@test names(df) == [:GEOID, :POP10, :HU10, :ALAND, :AWATER, :ALAND_SQMI, :AWATER_SQMI, :INTPTLAT, :INTPTLONG]
@test size(df) == (33120, 9)
@test typeof.(df.columns) == [Vector{T} for T in
                              [Int64, Int64, Int64, Int64, Int64, Float64, Float64, Float64, Float64]

f = joinpath(files, "Homo_sapiens.GRCh38.90.chr.gtf.gz")
df = DataFrame(uCSV.read(GDS(open(f)), delim='\t', comment="#!", types=Dict(1 => String))[1])
@test names(df) == [:x1, :x2, :x3, :x4, :x5, :x6, :x7, :x8, :x9]
@test size(df) == (2612129, 9)
@test typeof.(df.columns) == [Vector{T} for T in
                              [String, String, String, Int64, Int64, String, String, String, String]]

f = joinpath(files, "Homo_sapiens.GRCh38.90.gff3.gz")
df = DataFrame(uCSV.read(GDS(open(f)), delim='\t', comment='#', types=Dict(1 => Symbol))[1])
@test names(df) == [:x1, :x2, :x3, :x4, :x5, :x6, :x7, :x8, :x9]
@test size(df) == (2636880, 9)
@test typeof.(df.columns) == [Vector{T} for T in
                              [Symbol, String, String, Int64, Int64, String, String, String, String]]

f = joinpath(files, "Homo_sapiens_clinically_associated.vcf.gz")
df = DataFrame(uCSV.read(GDS(open(f)), delim='\t', comment="##", types=Dict(1 => Symbol), header=1)...)
@test names(df) == [Symbol("#CHROM"), :POS, :ID, :REF, :ALT, :QUAL, :FILTER, :INFO]
@test size(df) == (66600, 8)
@test typeof.(df.columns) == [Vector{T} for T in
                              [Symbol, Int64, String, String, String, String, String, String]]

f = joinpath(files, "METARs.csv.gz")
df = DataFrame(uCSV.read(GDS(open(f)), header=6)...)
@test names(df) == [:raw_text, :station_id, :observation_time, :latitude, :longitude, :temp_c, :dewpoint_c, :wind_dir_degrees, :wind_speed_kt, :wind_gust_kt, :visibility_statute_mi, :altim_in_hg, :sea_level_pressure_mb, :corrected, :auto, :auto_station, :maintenance_indicator_on, :no_signal, :lightning_sensor_off, :freezing_rain_sensor_off, :present_weather_sensor_off, :wx_string, :sky_cover, :cloud_base_ft_agl, :sky_cover_1, :cloud_base_ft_agl_1, :sky_cover_2, :cloud_base_ft_agl_2, :sky_cover_3, :cloud_base_ft_agl_3, :flight_category, :three_hr_pressure_tendency_mb, :maxT_c, :minT_c, :maxT24hr_c, :minT24hr_c, :precip_in, :pcp3hr_in, :pcp6hr_in, :pcp24hr_in, :snow_in, :vert_vis_ft, :metar_type, :elevation_m]
@test size(df) == (2, 44)
@test typeof.(df.columns) == [Vector{T} for T in
                              [String, String, String, Float64, Float64, Float64, Float64, Int64, Int64, String, Float64, Float64, Float64, String, String, String, String, String, String, String, String, String, String, Int64, String, Int64, String, Int64, String, String, String, String, String, String, String, String, String, String, String, String, String, String, String, Float64]]

f = joinpath(files, "Most-Recent-Cohorts-Scorecard-Elements.csv.gz")
@test_warn "Large values for `typedetectrows` will reduce performance. Consider using a lower value and specifying column-types via the `types` and `isnullable` arguments instead." uCSV.read(GDS(open(f)), header=1, encodings=Dict{String, Any}("NULL" => null, "PrivacySuppressed" => null), typedetectrows=7283, quotes='"', skiprows=2:typemax(Int))
df = DataFrame(uCSV.read(GDS(open(f)), header=1, encodings=Dict{String, Any}("NULL" => null, "PrivacySuppressed" => null), typedetectrows=200, quotes='"', isnullable=true)...)
@test names(df) == [Symbol("\ufeffUNITID"), :OPEID, :OPEID6, :INSTNM, :CITY, :STABBR, :INSTURL, :NPCURL, :HCM2, :PREDDEG, :CONTROL, :LOCALE, :HBCU, :PBI, :ANNHI, :TRIBAL, :AANAPII, :HSI, :NANTI, :MENONLY, :WOMENONLY, :RELAFFIL, :SATVR25, :SATVR75, :SATMT25, :SATMT75, :SATWR25, :SATWR75, :SATVRMID, :SATMTMID, :SATWRMID, :ACTCM25, :ACTCM75, :ACTEN25, :ACTEN75, :ACTMT25, :ACTMT75, :ACTWR25, :ACTWR75, :ACTCMMID, :ACTENMID, :ACTMTMID, :ACTWRMID, :SAT_AVG, :SAT_AVG_ALL, :PCIP01, :PCIP03, :PCIP04, :PCIP05, :PCIP09, :PCIP10, :PCIP11, :PCIP12, :PCIP13, :PCIP14, :PCIP15, :PCIP16, :PCIP19, :PCIP22, :PCIP23, :PCIP24, :PCIP25, :PCIP26, :PCIP27, :PCIP29, :PCIP30, :PCIP31, :PCIP38, :PCIP39, :PCIP40, :PCIP41, :PCIP42, :PCIP43, :PCIP44, :PCIP45, :PCIP46, :PCIP47, :PCIP48, :PCIP49, :PCIP50, :PCIP51, :PCIP52, :PCIP54, :DISTANCEONLY, :UGDS, :UGDS_WHITE, :UGDS_BLACK, :UGDS_HISP, :UGDS_ASIAN, :UGDS_AIAN, :UGDS_NHPI, :UGDS_2MOR, :UGDS_NRA, :UGDS_UNKN, :PPTUG_EF, :CURROPER, :NPT4_PUB, :NPT4_PRIV, :NPT41_PUB, :NPT42_PUB, :NPT43_PUB, :NPT44_PUB, :NPT45_PUB, :NPT41_PRIV, :NPT42_PRIV, :NPT43_PRIV, :NPT44_PRIV, :NPT45_PRIV, :PCTPELL, :RET_FT4, :RET_FTL4, :RET_PT4, :RET_PTL4, :PCTFLOAN, :UG25ABV, :MD_EARN_WNE_P10, :GT_25K_P6, :GRAD_DEBT_MDN_SUPP, :GRAD_DEBT_MDN10YR_SUPP, :RPY_3YR_RT_SUPP, :C150_L4_POOLED_SUPP, :C150_4_POOLED_SUPP]
@test size(df) == (7703, 122)
@test typeof.(df.columns) == [Vector{T} for T in
                              [Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Nulls.Null, String}, Union{Nulls.Null, String}, Union{Nulls.Null, String}, Union{Nulls.Null, String}, Union{Nulls.Null, String}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Int64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}, Union{Float64, Nulls.Null}]]

f = joinpath(files, "OP_DTL_OWNRSHP_PGYR2016_P06302017.csv.gz")
df = DataFrame(uCSV.read(GDS(open(f)), header=1)...)
@test names(df) ==
@test size(df) ==
@test typeof.(df.columns) == [Vector{T} for T in
                              []]

f = joinpath(files, "PIREPs.csv.gz")
df = DataFrame(uCSV.read(GDS(open(f)), header=1)...)
@test names(df) ==
@test size(df) ==
@test typeof.(df.columns) == [Vector{T} for T in
                              []]

f = joinpath(files, "STATIONINFO.csv.gz")
df = DataFrame(uCSV.read(GDS(open(f)), header=1)...)
@test names(df) ==
@test size(df) ==
@test typeof.(df.columns) == [Vector{T} for T in
                              []]

f = joinpath(files, "SacramentocrimeJanuary2006.csv.gz")
df = DataFrame(uCSV.read(GDS(open(f)), header=1)...)
@test names(df) ==
@test size(df) ==
@test typeof.(df.columns) == [Vector{T} for T in
                              []]

f = joinpath(files, "Sacramentorealestatetransactions.csv.gz")
df = DataFrame(uCSV.read(GDS(open(f)), header=1)...)
@test names(df) ==
@test size(df) ==
@test typeof.(df.columns) == [Vector{T} for T in
                              []]

f = joinpath(files, "SalesJan2009.csv.gz")
df = DataFrame(uCSV.read(GDS(open(f)), header=1)...)
@test names(df) ==
@test size(df) ==
@test typeof.(df.columns) == [Vector{T} for T in
                              []]

f = joinpath(files, "TAFs.csv.gz")
df = DataFrame(uCSV.read(GDS(open(f)), header=1)...)
@test names(df) ==
@test size(df) ==
@test typeof.(df.columns) == [Vector{T} for T in
                              []]

f = joinpath(files, "TechCrunchcontinentalUSA.csv.gz")
df = DataFrame(uCSV.read(GDS(open(f)), header=1)...)
@test names(df) ==
@test size(df) ==
@test typeof.(df.columns) == [Vector{T} for T in
                              []]

f = joinpath(files, "WellIndex_20160811.csv.gz")
df = DataFrame(uCSV.read(GDS(open(f)), header=1)...)
@test names(df) ==
@test size(df) ==
@test typeof.(df.columns) == [Vector{T} for T in
                              []]

f = joinpath(files, "baseball.csv.gz")
df = DataFrame(uCSV.read(GDS(open(f)), header=1)...)
@test names(df) ==
@test size(df) ==
@test typeof.(df.columns) == [Vector{T} for T in
                              []]

f = joinpath(files, "battles.csv.gz")
df = DataFrame(uCSV.read(GDS(open(f)), header=1)...)
@test names(df) ==
@test size(df) ==
@test typeof.(df.columns) == [Vector{T} for T in
                              []]

f = joinpath(files, "character-deaths.csv.gz")
f = joinpath(files, "character-predictions.csv.gz")
f = joinpath(files, "comma_in_quotes.csv.gz")
f = joinpath(files, "complications-and-deaths-hospital.csv.gz")
f = joinpath(files, "diabetes.csv.gz")
f = joinpath(files, "empty.csv.gz")
f = joinpath(files, "empty_crlf.csv.gz")
f = joinpath(files, "escaped_quotes.csv.gz")
f = joinpath(files, "final-cjr-quality-pr.csv.gz")
f = joinpath(files, "globalterrorismdb_0617dist.csv.gz")
f = joinpath(files, "goa_human.gaf.gz")
f = joinpath(files, "hospice-compare-casper-aspen-contacts.csv.gz")
f = joinpath(files, "hospice-compare-general-info.csv.gz")
f = joinpath(files, "hospice-compare-provider-data.csv.gz")
f = joinpath(files, "indicators.csv.gz")
f = joinpath(files, "iris.csv.gz")
f = joinpath(files, "json.csv.gz")
f = joinpath(files, "latest.csv.gz")
f = joinpath(files, "movie_metadata.csv.gz")
f = joinpath(files, "newlines.csv.gz")
f = joinpath(files, "newlines_crlf.csv.gz")
f = joinpath(files, "pandas_zeros.csv.gz")
f = joinpath(files, "payment-year-2017.csv.gz")
f = joinpath(files, "quotes_and_newlines.csv.gz")
f = joinpath(files, "simple.csv.gz")
f = joinpath(files, "simple_crlf.csv.gz")
f = joinpath(files, "species.txt.gz")
f = joinpath(files, "stocks.csv.gz")
f = joinpath(files, "student-por.csv.gz")
f = joinpath(files, "test_2_footer_rows.csv.gz")
f = joinpath(files, "test_basic.csv.gz")
f = joinpath(files, "test_basic_pipe.csv.gz")
f = joinpath(files, "test_crlf_line_endings.csv.gz")
f = joinpath(files, "test_dates.csv.gz")
f = joinpath(files, "test_datetimes.csv.gz")
f = joinpath(files, "test_empty_file.csv.gz")
f = joinpath(files, "test_empty_file_newlines.csv.gz")
f = joinpath(files, "test_excel_date_formats.csv.gz")
f = joinpath(files, "test_float_in_int_column.csv.gz")
f = joinpath(files, "test_floats.csv.gz")
f = joinpath(files, "test_header_on_row_4.csv.gz")
f = joinpath(files, "test_mac_line_endings.csv.gz")
f = joinpath(files, "test_missing_value.csv.gz")
f = joinpath(files, "test_missing_value_NULL.csv.gz")
f = joinpath(files, "test_mixed_date_formats.csv.gz")
f = joinpath(files, "test_newline_line_endings.csv.gz")
f = joinpath(files, "test_no_header.csv.gz")
f = joinpath(files, "test_one_row_of_data.cscv")
f = joinpath(files, "test_one_row_of_data.csv.gz")
f = joinpath(files, "test_quoted_delim_and_newline.csv.gz")
f = joinpath(files, "test_quoted_numbers.csv.gz")
f = joinpath(files, "test_simple_quoted.csv.gz")
f = joinpath(files, "test_single_column.csv.gz")
f = joinpath(files, "test_tab_null_empty.txt.gz")
f = joinpath(files, "test_tab_null_string.txt.gz")
f = joinpath(files, "test_utf16.csv.gz")
f = joinpath(files, "test_utf16_be.csv.gz")
f = joinpath(files, "test_utf16_le.csv.gz")
f = joinpath(files, "test_utf8.csv.gz")
f = joinpath(files, "test_utf8_with_BOM.csv.gz")
f = joinpath(files, "test_windows.csv.gz")
f = joinpath(files, "utf8.csv.gz")
f = joinpath(files, "zika.csv.gz")


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