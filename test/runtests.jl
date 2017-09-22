using uCSV, HTTP, CodecZlib, RDatasets, Base.Test

files = joinpath(Pkg.dir("uCSV"), "test", "data")
@time CSV.read("/Users/Cameron/Desktop/test_files/yellow_tripdata_2015-01.csv")
# @time CSV.read(joinpath(files, "iris.csv"), skiprows=2:typemax(Int))
# @time CSV.read(joinpath(files, "iris.csv"))
@time CSV.read("/Users/Cameron/Desktop/test_files/yellow_tripdata_2015-01.csv", skiprows=2:typemax(Int))
@time CSV.read("/Users/Cameron/Desktop/test_files/yellow_tripdata_2015-01.csv", skiprows=typemax(Int):typemax(Int))
# @time CSV.read("/Users/Cameron/Desktop/test_files/yellow_tripdata_2015-01.csv", skiprows=2:typemax(Int))
# @time CSV.read("/Users/Cameron/Desktop/test_files/yellow_tripdata_2015-01.csv", skiprows=10:typemax(Int))
# @time CSV.read("/Users/Cameron/Desktop/test_files/yellow_tripdata_2015-01.csv", skiprows=1000:typemax(Int))
# @time CSV.read("/Users/Cameron/Desktop/test_files/yellow_tripdata_2015-01.csv", skiprows=10000:typemax(Int))
# @time CSV.read("/Users/Cameron/Desktop/test_files/yellow_tripdata_2015-01.csv", skiprows=100000:typemax(Int))







#
# s =
# """
# c1,c2,c3
# 1,1.0,a
# 2,2.0,b
# 3,3.0,c
# """
# CSV.read(IOBuffer(s))
# @time CSV.read(IOBuffer(s))
#
#
# s =
# """
# 1997,Ford,E350
# """
# CSV.parserow(IOBuffer(s), ',', '\\', ('"', '"'), '.', false, Dict{Int, Function}())
#
# s =
# """
# 1997,Ford,E350\n
# """
# CSV.parserow(IOBuffer(s), ',', '\\', ('"', '"'), '.', false, Dict{Int, Function}())
#
# s =
# """
# "1997","Ford","E350"
# """
# CSV.parserow(IOBuffer(s), ',', '\\', ('"', '"'), '.', false, Dict{Int, Function}())
#
# s =
# """
# "19"97,"Fo"rd,E3"50"
# """
# CSV.parserow(IOBuffer(s), ',', '\\', ('"', '"'), '.', false, Dict{Int, Function}())
#
# s =
# """
# \"\"\"1997\"\"\",\"Ford\",\"E350\"
# """
# CSV.parserow(IOBuffer(s), ',', '\\', ('"', '"'), '.', false, Dict{Int, Function}())
#
# s =
# """
# 1997,Ford,E350,"Super, luxurious truck"
# """
# CSV.parserow(IOBuffer(s), ',', '\\', ('"', '"'), '.', false, Dict{Int, Function}())
#
# s =
# """
# 1997,Ford,E350,"Super,, luxurious truck"
# """
# CSV.parserow(IOBuffer(s), ',', '\\', ('"', '"'), '.', false, Dict{Int, Function}())
#
# s =
# """
# 1997,Ford,E350,"Super,,, luxurious truck"
# """
# CSV.parserow(IOBuffer(s), ',', '\\', ('"', '"'), '.', false, Dict{Int, Function}())
#
# s =
# """
# 1997,Ford,E350,Super\\, luxurious truck
# """
# CSV.parserow(IOBuffer(s), ',', '\\', ('"', '"'), '.', false, Dict{Int, Function}())
#
# s =
# """
# 1997,Ford,E350,Super\\,\\, luxurious truck
# """
# CSV.parserow(IOBuffer(s), ',', '\\', ('"', '"'), '.', false, Dict{Int, Function}())
#
# s =
# """
# 1997,Ford,E350,Super\\,\\,\\, luxurious truck
# """
# CSV.parserow(IOBuffer(s), ',', '\\', ('"', '"'), '.', false, Dict{Int, Function}())
#
#
# s = "1997,Ford,E350,\"Super, \"\"luxurious\"\" truck\""
# CSV.parserow(IOBuffer(s), ',', '"', ('"', '"'), '.', false, Dict{Int, Function}())
#
# s =
# """
# 1997,Ford,E350,"Super, \"luxurious\" truck"
# """
# CSV.parserow(IOBuffer(s), ',', '\\', ('"', '"'), '.', false, Dict{Int, Function}())
#
# s =
# """
# 1997,Ford,E350,Super "luxurious" truck
# """
# CSV.parserow(IOBuffer(s), ',', '\\', ('"', '"'), '.', false, Dict{Int, Function}())
#
# s =
# """
# 19,97;Ford;E350;Super "luxurious" truck
# """
# CSV.parserow(IOBuffer(s), ';', '\\', ('"', '"'), ',', false, Dict{Int, Function}())
#
# s = "1997,Ford,E350,\"Go get one now\nthey are going fast\""
# CSV.parserow(IOBuffer(s), ',', '\\', ('"', '"'), '.', false, Dict{Int, Function}())
#
# s = "1997,Ford,E350,\"Go get one now\n\nthey are going fast\""
# CSV.parserow(IOBuffer(s), ',', '\\', ('"', '"'), '.', false, Dict{Int, Function}())
#
# s =
# """
# 1997,Ford,E350,"Go get one now\\nthey are going fast"
# """
# CSV.parserow(IOBuffer(s), ',', '\\', ('"', '"'), '.', false, Dict{Int, Function}())
#
# s =
# """
# 1997, Ford, E350
# """
# CSV.parserow(IOBuffer(s), ',', '\\', ('"', '"'), '.', false, Dict{Int, Function}())
#
# s =
# """
# 1997, Ford, E350
# """
# CSV.parserow(IOBuffer(s), ',', '\\', ('"', '"'), '.', true, Dict{Int, Function}())
#
# s =
# """
# 1997, "Ford" ,E350
# """
# CSV.parserow(IOBuffer(s), ',', '\\', ('"', '"'), '.', false, Dict{Int, Function}())
#
# s =
# """
# 1997, "Ford" ,E350
# """
# CSV.parserow(IOBuffer(s), ',', '\\', ('"', '"'), '.', true, Dict{Int, Function}())
#
# s =
# """
# 1997,Ford,E350," Super luxurious truck "
# """
# CSV.parserow(IOBuffer(s), ',', '\\', ('"', '"'), '.', false, Dict{Int, Function}())
#
# s =
# """
# 1997,Ford,E350," Super luxurious truck "
# """
# CSV.parserow(IOBuffer(s), ',', '\\', ('"', '"'), '.', true, Dict{Int, Function}())
#
# s =
# """
# Los Angeles,34°03′N,118°15′W
# """
# CSV.parserow(IOBuffer(s), ',', '\\', ('"', '"'), '.', true, Dict{Int, Function}())
#
# s =
# """
# New York City,40°42′46″N,74°00′21″W
# """
# CSV.parserow(IOBuffer(s), ',', '\\', ('"', '"'), '.', true, Dict{Int, Function}())
#
# s =
# """
# Paris,48°51′24″N,2°21′03″E
# """
# CSV.parserow(IOBuffer(s), ',', '\\', ('"', '"'), '.', true, Dict{Int, Function}())
#
#
# delim = ","
# escape = "\\"
# quotes = ("\"", "\"")
# decimal = "."
# CSV.parserow(IOBuffer(s), delim, escape, quotes, decimal, trimwhitespace, transforms)
# # end
#
# # end
#
#
#
# @testset "Char parsing"
# end
#
# @testset "String Parsing"
# end
#
# @test parsefields(IOBuffer("""
#
#                            """)) == ["1997", "Ford", "E350", "Go get one now\nthey are going fast"]
#
#
# # is parsed incorrectly when string literal starts on next line
# @test parsefields(IOBuffer()) ==
#     ["1997", "Ford", "E350", "Go get one now\nthey are going fast"]
#
# @test parsefields(IOBuffer("")) ==
#     ["1997", "Ford", "E350", "Go get one now\n\nthey are going fast"]
#
# @test parsefields(IOBuffer("")) ==
#     ["1997", "Ford", "E350", "Go get one now\\nthey are going fast"]
#
# @test parsefields(IOBuffer("""
#
#                            """)) == ["1997", " Ford", " E350"]
#
# @test parsefields(IOBuffer("""
#
#                            """), trimwhitespace = true) == ["1997", "Ford", "E350"]
#
# @test parsefields(IOBuffer("""
#
#                            """), trimwhitespace = true) == ["1997", "Ford", "E350"]
#
# @test parsefields(IOBuffer("""
#
#                            """)) == ["1997", "Ford", "E350", " Super luxurious truck "]
#
# @test parsefields(IOBuffer("""
#
#                            """), trimwhitespace = true) == ["1997", "Ford", "E350", " Super luxurious truck "]
#
# @test parsefields(IOBuffer("""
#
#                            """)) == ["Los Angeles", "34°03′N", "118°15′W"]
#
# @test parsefields(IOBuffer("""
#
#                            """)) == ["New York City", "40°42′46″N", "74°00′21″W"]
#
# @test parsefields(IOBuffer("""
#
#                            """)) == ["Paris", "48°51′24″N", "2°21′03″E"]
#
# @testset "detecttypes"
# end
#
# @testset "detecttypes"
# end
#
# @testset "parsefields"
# end
#
# @testset "RawField equality"
# end
#
# @tesetset "match improperly split quotes"
# end
#
# @testset "imperialize euro-style decimals"
# end
#
# @testset "parsestrings"
# end
#
# @testset "read delimited files"
# end
#
# @testset "quoted delimiters"
# end
#
# @testset "quoted newlines"
# end
#
# @testset "dates"
#     # https://github.com/JuliaStats/DataFrames.jl/issues/292
# end
#
# @testset "times"
#     # https://github.com/JuliaStats/DataFrames.jl/issues/292
# end
#
# @testset "datetimes"
#     # https://github.com/JuliaStats/DataFrames.jl/issues/292
# end
#
# @testset "read urls"
#     # https://github.com/JuliaStats/DataFrames.jl/issues/292
#     # https://github.com/JuliaStats/DataFrames.jl/issues/385
# end
#
# @testset "read files with missing data"
# end
#
# @testset "read files with quotes escaping quotes"
# end
#
# @testset "read euro style decimals"
#     # https://github.com/JuliaStats/DataFrames.jl/issues/291
#     # https://github.com/JuliaData/CSV.jl/issues/83
#     # https://github.com/JuliaStats/DataFrames.jl/issues/402
# end
#
# @testset "read scientific notation numbers"
# end
#
# @testset "different beginning and ending quotes"
#     # https://github.com/JuliaData/CSV.jl/issues/60
#     x = """
#         {reddish}, {red, ish}
#         {darkish}, {dark, ish}
#         {greenish}, {green, ish}
#         {greyish}, {grey, ish}
#         """
# end
#
# @testset "skip whitespace"
# end
#
# @testset "skip whitespace"
# end
#
# @testset "nullstrings"
#     # https://github.com/JuliaStats/DataFrames.jl/issues/304
#     x = """
#         1,hey,1
#         2,you,2
#         3,,3
#         4,"",4
#         5,NULL,5
#         """
# end
#
# @testset "skip malformed"
#     # https://github.com/JuliaData/CSV.jl/issues/76
# end
#
# @testset "skip comments at start of file"
# end
#
# @testset "headerless files"
# end
#
# @testset "header not on first line"
# end
#
# @testset "gap between header and data"
# end
#
# @testset "null inference"
# end
#
# @testset "categorical arrays"
# end
#
# @testset "gzipped files"
#     # https://github.com/JuliaData/CSV.jl/issues/46
#     # https://github.com/JuliaStats/DataFrames.jl/issues/292
# end
#
# @testset "header shorter than columns"
#     # https://github.com/JuliaData/CSV.jl/issues/54
#     x = """
#         A;B;C
#         1,1,10
#         2,0,16
#         """
# end
#
# @testset "truncated final line"
#     # https://github.com/JuliaData/CSV.jl/issues/54
#     x = """
#         A,B,C
#         1,1,10
#         6,1
#         """
# end
#
# @testset "write with no quotemarks"
#     # https://discourse.julialang.org/t/writing-dataframe-with-no-quotemarks/4599
#     # https://github.com/JuliaStats/DataFrames.jl/issues/1080
# end
#
# @testset "mmap and writeables"
#     # https://github.com/JuliaData/CSV.jl/issues/66
# end
#
# @testset "allow string delimiters"
#     # https://github.com/JuliaData/CSV.jl/issues/71
#     # https://github.com/JuliaStats/DataFrames.jl/issues/292
# end
#
# @testset "allow regex delimiters"
#     # https://github.com/JuliaStats/DataFrames.jl/issues/292
# end
#
# @testset "boolean strings"
#     # https://github.com/JuliaData/CSV.jl/issues/79
# end
#
# @testset "countlines"
#     # needed for efficient skiprows
# end
#
# @testset "skiprows"
#     # https://github.com/JuliaStats/DataFrames.jl/issues/292
#     # where 1 refers to first row after header
#     # end refers to last line in dataset
#     # need to be able to efficiently slice ranges in data
#     # skip beginning
#     # skip end
#     # skip middle
#     # skip beginning & end
#     # skip beginning & middle & end
# end
#
# @testset "transforms"
#     # https://github.com/JuliaStats/DataFrames.jl/issues/292
#     # refer to columns by #
#     # refer to columns by Symbol
#     # refer to columns by String
# end
#
# @testset "specify column types"
# end
#
# @testset "tricky escapes"
#     # https://github.com/JuliaStats/DataFrames.jl/issues/292
# end
#
# @testset "handle trailing whitespace"
#     # https://github.com/JuliaData/CSV.jl/issues/84
#     # use transforms
#     # use trimwhitespace
# end
#
# @testset "quote-escaped quotes"
#     # https://github.com/JuliaData/CSV.jl/issues/86
# end
#
# @testset "coltype promotions"
#     # https://github.com/JuliaData/CSV.jl/issues/88
# end
#
# @testset "skip commented lines"
#     # I want this functionality to read VCFs
# end
#
#
#
# # @test joinquotes(["a", "b", "c", "d", "e"], [false, false, true, false, true], ',') ==
# #     ["a", "b", "c,d,e"]
# #
# # @test imperialize("string,string") == "string,string"
# # @test imperialize("123,123") == "123.123"
# # @test imperialize("123,") == "123."
# # @test imperialize(",123") == ".123"
# # @test imperialize("string, string") == "string, string"
# # @test imperialize("123, 123") == "123, 123"
# # @test imperialize("123 ,") == "123 ,"
# # @test imperialize(", 123") == ", 123"
#
#
#
#
#
#
# parsefields(IOBuffer("""
#                      Los Angeles,34°03′N,118°15′W
#                      New York City,40°42′46″N,74°00′21″W
#                      Paris,48°51′24″N,2°21′03″E
#                      """))
#
# parsefields(IOBuffer("""
#                      Year,Make,Model
#                      1997,Ford,E350
#                      2000,Mercury,Cougar
#                      """))
#
# b = IOBuffer("Year,Make,Model,Description,Price\n1997,Ford,E350,\"ac, abs, moon\",3000.00\n1999,Chevy,\"Venture \"\"Extended Edition\"\"\",\"\",4900.00\n1999,Chevy,\"Venture \"\"Extended Edition, Very Large\"\"\",,5000.00\n1996,Jeep,Grand Cherokee,\"MUST SELL!\nair, moon roof, loaded\",4799.00\n")
#
# parsefields(b, escapechar = '"')
#
# parsefields(IOBuffer("""
#                      Year,Make,Model,Length
#                      1997,Ford,E350,2.34
#                      2000,Mercury,Cougar,2.38
#                      """))
#
# parsefields(IOBuffer("""
#                      Year;Make;Model;Length
#                      1997;Ford;E350;2,34
#                      2000;Mercury;Cougar;2,38
#                      """), euro = true)
#
# parsefields(IOBuffer("""
#                      I,am,a,csv
#                      file,with,two,rows
#                      """))
#
# parsefields(IOBuffer("""
#                      I\tam\ta\ttsv
#                      file\twith\ttwo\trows
#                      """))

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
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/plyr/baseball.csv.gz # lots of NAs
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/pscl/ca2006.csv.gz # true false encodings
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/pscl/presidentialElections.csv.gz # different true false
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
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/ggplot2/economics.csv.gz # more dates
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/ggplot2/presidential.csv.gz # more dates
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/pscl/UKHouseOfCommons.csv.gz
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/vcd/Lifeboats.csv.gz # dates
https://github.com/johnmyleswhite/RDatasets.jl/raw/master/data/vcd/SexualFun.csv.gz

CSV.read(GzipDecompressionStream(HTTP.body(HTTP.get(html))))

for line in eachline((IOBuffer(Requests.read(get(html)))))
    println(line)
end

# using CSV, Base.Test, BenchmarkTools



using CSV
