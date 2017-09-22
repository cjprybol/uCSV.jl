# using CSV, Base.Test, BenchmarkTools
# julia --track-allocation=user


using CSV

files = joinpath(Pkg.dir("CSV"), "test", "data")
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


# Profile.clear()
# Profile.clear_malloc_data()
# @profile CSV.read(joinpath(files, "iris.csv"))
# Profile.print(format=:flat)




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
