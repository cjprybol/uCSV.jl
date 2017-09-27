var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#uCSV.jl-Documentation-1",
    "page": "Home",
    "title": "uCSV.jl Documentation",
    "category": "section",
    "text": ""
},

{
    "location": "index.html#uCSV.read",
    "page": "Home",
    "title": "uCSV.read",
    "category": "Function",
    "text": "read(fullpath;\n     delim=',',\n     quotes=null,\n     escape=null,\n     comment=null,\n     encodings=Dict{String, Any}(),\n     header=0,\n     skiprows=Vector{Int}(),\n     types=Dict{Int,DataType}(),\n     isnullable=Dict{Int,Bool}(),\n     iscategorical=Dict{Int,Bool}(),\n     colparsers=Dict{Int,Function}(),\n     typeparsers=Dict{DataType, Function}(),\n     typedetectrows=1,\n     skipmalformed=false,\n     trimwhitespace=false)\n\nTake an input file or IO source and user-defined parsing rules and return:\n\na Vector{Any} containing the parsed columns\na Vector{String} containing the header (column names)\n\nArguments\n\nfullpath::Union{String,IO}\nthe path to a local file, or an open IO source from which to read data\ndelim::Union{Char,String}\nwhatever the dataset is being split on\ndefault: delim=','\nfor CSV files\nfrequently used:\ndelim='\\t'\ndelim=' '\ndelim='|'\nmay contain any valid UTF-8 character or string\nquotes::Union{Char,Null}\nthe character used for quoting fields in the dataset\ndefault: quotes=null\nby default, the parser does not check for quotes.\nfrequently used:\nquotes='\"'\nescape::Union{Char,Null}\nthe character used for escaping other special & reserved parsing characters\ndefault: escape=null\nby default, the parser does not check for escapes.\nfrequently used:\nescape='\"'\ndouble-quotes within quotes, e.g. \"firstname \"\"nickname\"\" lastname\"\nescape='\\\\'\nnote that the first backslash is just to escape the second backslash\ne.g. \"firstname \\\"nickname\\\" lastname\"\ncomment::Union{Char,String,Null}\nthe character or string used for comment lines in your dataset\nnote that skipped comment lines do not contribute to the line count for the header (if the user requests parsing a header on a specific row) or for skiprows\ndefault: comment=null\nby default, the parser does not check for comments\nfrequently used:\ncomment='#'\ncomment='!'\ncomment=\"#!\"\nencodings::Dict{String,Any}\nA dictionary mapping parsed strings to desired julia values\nif your dataset has booleans that are not represented as \"true\" and \"false\" or missing values that you'd like to read as nulls, you'll need to use this!\ndefault: encodings=Dict{String, Any}()\nby default, the parser does not check for any reserved fields\nfrequently used:\nencodings=Dict{String, Any}(\"\" => null)\nencodings=Dict{String, Any}(\"NA\" => null)\nencodings=Dict{String, Any}(\"N/A\" => null)\nencodings=Dict{String, Any}(\"NULL\" => null)\nencodings=Dict{String, Any}(\"TRUE\" => true, \"FALSE\" => false)\nencodings=Dict{String, Any}(\"True\" => true, \"False\" => false)\nencodings=Dict{String, Any}(\"T\" => true, \"F\" => false)\nencodings=Dict{String, Any}(\"yes\" => true, \"no\" => false)\n... your encodings here ...\ncan include any number of String => value mappings\nnote that if the user requests quotes, escapes, or trimwhitespace, these requests will be applied (removed) the raw string BEFORE checking whether the field matches any strings in in the encodings argument.\nheader::Union{Integer,Vector{String}}\nThe line in the dataset on which to parse the header\nnote that commented lines and blank lines do not contribute to this value e.g. if the first 3 lines of your dataset are comments, you'll still need to set header=1 to interpret the first line of parsed data as the header.\ndefault: header=0\nno header is checked for by default\nfrequently used:\nheader=1\nskiprows::AbstractVector{Int}\nA Vector or Range (e.g. 1:10) or rows to skip\nnote that this is 1-based in reference to the first row AFTER the header. If header=0 or is provided by the user, this will be the first non-empty line in the dataset. Otherwise skiprows=1:1 will skip the header+1-nth line in the file.\ndefault: skiprows=Vector{Int}()\nno rows are skipped\nfrequently used:\nskiprows=6:typemax(Int)\nread only the first 5 lines of the dataset\ntypes::Union{Type, Dict{Int, Type}, Dict{String, Type}, Vector{Type}}\ndeclare the types of the columns, can be in any of the following forms:\nscalar, e.g. types=Bool\nscalars will be broadcast to apply to every column of the dataset\nvector, e.g. types=[Bool, Int, Float64, String, Symbol, Date, DateTime]\nthe vector length must match the number of parsed columns\ndictionary, e.g. types=(\"column1\" => Bool) or types=(1 => Union{Int, Null})\nusers can refer to the columns by name (only if a header is provided or parsed!) or by index\ndefault:\ntypes=Dict{Int,DataType}()\ncolumn-types will be interpreted from the dataset\nbuilt-in support for parsing the following:\nInt\nFloat64\nString\nSymbol\nDate – only the default date format will work\nDateTime – only the default datetime format will work\nfor other types or unsupported formats, see colparsers and typeparsers\nisnullable::Union{Bool, Dict{Int, Bool}, Dict{String, Bool}, Vector{Bool}}\ndeclare whether columns should have element-type Union{T, Null} where T, can be in any of the following forms:\nscalar, e.g. isnullable=true\nscalars will be broadcast to apply to every column of the dataset\nvector, e.g. isnullable=[true, false, true, true]\nthe vector length must match the number of parsed columns\ndictionary, e.g. isnullable=(\"column1\" => true) or isnullable=(17 => true)\nusers can refer to the columns by name (only if a header is provided or parsed!) or by index\ndefault: isnullable=Dict{Int,Bool}()\ncolumn-types are only nullable if null values are detected in rows 1:typedetectrows.\niscategorical::Union{Bool, Dict{Int, Bool}, Dict{String, Bool}, Vector{Bool}}\ndeclare whether columns should be CategoricalVectors can be in any of the following forms:\nscalar, e.g. iscategorical=true\nscalars will be broadcast to apply to every column of the dataset\nvector, e.g. iscategorical=[true, false, true, true]\nthe vector length must match the number of parsed columns\ndictionary, e.g. iscategorical=(\"column1\" => true) or isnullable=(17 => true)\nusers can refer to the columns by name (only if a header is provided or parsed!) or by index\ndefault: iscategorical=Dict{Int,Bool}()\nall columns are returned as standard julia vectors\ncolparsers::Union{Function, Dict{Int, Function}, Dict{String, Function}, Vector{Function}}\nprovide custom functions for converting parsed strings to values by column\nscalar, e.g. colparsers=(x -> parse(Float64, replace(x, ',', '.')))\nscalars will be broadcast to apply to every column of the dataset\nvector, e.g. colparsers=[x -> mydateparser(x), x -> mytimeparser(x)]\nthe vector length must match the number of parsed columns\ndictionary, e.g. colparsers=(\"column1\" => x -> mydateparser(x))\nusers can refer to the columns by name (only if a header is provided or parsed!) or by index\ndefault: colparsers=Dict{Int,Function}()\ncolumn parsers are determined based on user-specified types and those detected from the data\ntypeparsers::Dict{Type, Function}\nprovide custom functions for converting parsed strings to values by column type\nnote user must specify column types for this to have the intended effect, as the parser uses the default type-parsers for detecting column type.\ndefault: colparsers=Dict{DataType, Function}()\ncolumn parsers are determined based on user-specified types and those detected from the data\nfrequently used:\ntypeparsers=Dict(Int => x -> parse(Float64, replace(x, ',', '.'))) # euro-style floats!\nin combination with types to specify which columns to apply the parsers to.\ntypedetectrows::Int=1\nspecify how many rows of data to read before interpretting the values that each column should take on\ncommented, skipped, and empty lines are not counted when determining which rows are used for type detection, e.g. setting typedetectrows=10 and skiprows=1:5 means type detection will occur on rows 6:15\nskipmalformed::Bool=false\nspecify whether the parser should skip a line or fail with an error if a line is parsed but does not contain the expected number of rows\ndefault: skipmalformed=false\nmalformed lines result in an error\ntrimwhitespace::Bool=false\nspecify whether should extra whitespace be removed from the beginning and ends of fields.\nQuoted leading and trailing whitespace will not be trimmed.\n\n\n\n"
},

{
    "location": "index.html#uCSV.write",
    "page": "Home",
    "title": "uCSV.write",
    "category": "Function",
    "text": "function write(fullpath;\n               header=null,\n               data=null,\n               delim=',',\n               quotes=null,\n               quotetypes=AbstractString)\n\nwrite a dataset\n\nArguments\n\nfullpath::Union{String, IO}\nthe path on disk or IO where you want to write to.\nheader::Union{Vector{String}, Null}\nthe column names for the data\ndefault: header=null\nno header is written\ndata::Union{Vector{<:Any}, Null}\nthe dataset to write to disk\ndefault: data=null\nno data is written\ndelim::Union{Char, String}\nthe delimiter to seperate fields by\ndefault: delim=','\nfor CSV files\nfrequently used:\ndelim='\\t'\ndelim=' '\ndelim='|'\nquotes::Union{Char, Null}\nthe quoting character to use when writing fields\ndefault: quotes=null\nfields are not quoted by default, and fields are written using julia's default string-printing mechanisms\nquotetypes::Type\nwhen quoting fields, quote only columns where coltype <: quotetypes\n\ndefault: quotetypes=AbsractString\nonly the header and fields where coltype <: AbsractString will be quoted\nnote that columns of Union{<:coltype, Null} will also be quoted, for cases where columns that you desire to be quoted also have missing values.\nfrequently used:\nquotetypes=Any\nquote every field in the dataset\n\n\n\n"
},

{
    "location": "index.html#Functions-1",
    "page": "Home",
    "title": "Functions",
    "category": "section",
    "text": "uCSV.read\nuCSV.write"
},

{
    "location": "index.html#Manual-1",
    "page": "Home",
    "title": "Manual",
    "category": "section",
    "text": "Pages = [\n    \"man/defaults.md\",\n    \"man/headers.md\",\n    \"man/dataframes.md\",\n    \"man/delimiters.md\",\n    \"man/missingdata.md\",\n    \"man/declaring-column-element-types.md\",\n    \"man/declaring-column-vector-types.md\",\n    \"man/international.md\",\n    \"man/customparsers.md\",\n    \"man/quotes-escapes.md\",\n    \"man/comments-skiplines.md\",\n    \"man/malformed.md\",\n    \"man/url.md\",\n    \"man/compressed.md\",\n    \"man/unsupported.md\",\n    \"man/benchmarks.md\"\n]\nDepth = 1"
},

{
    "location": "man/defaults.html#",
    "page": "Getting Started",
    "title": "Getting Started",
    "category": "page",
    "text": ""
},

{
    "location": "man/defaults.html#Getting-Started-1",
    "page": "Getting Started",
    "title": "Getting Started",
    "category": "section",
    "text": ""
},

{
    "location": "man/defaults.html#uCSV.read-1",
    "page": "Getting Started",
    "title": "uCSV.read",
    "category": "section",
    "text": "uCSV.read enables you to construct more complex parsing-rules through a compact and flexible API that aims to handle everything from the simple to the nightmarish.By default, it assumes that you're starting with a simple comma-delimited data matrix. This makes uCSV.read a suitable tool for reading raw numeric datasets for conversion to 2-D Arrays, in addition to reading more complex datasetsjulia> using uCSV\n\njulia> s =\n       \"\"\"\n       1.0,1.0,1.0\n       2.0,2.0,2.0\n       3.0,3.0,3.0\n       \"\"\";\n\njulia> data, header = uCSV.read(IOBuffer(s));\n\njulia> data\n3-element Array{Any,1}:\n [1.0, 2.0, 3.0]\n [1.0, 2.0, 3.0]\n [1.0, 2.0, 3.0]\n\njulia> header\n0-element Array{String,1}\n\njulia> uCSV.tomatrix(uCSV.read(IOBuffer(s)))\n3×3 Array{Float64,2}:\n 1.0  1.0  1.0\n 2.0  2.0  2.0\n 3.0  3.0  3.0\nSome examples of what uCSV.read can handle:String delimiters\nUnlimited field => value encodings for when you have multiple null-strings, boolean encodings, or other special fields\nBuilt-in support for Strings, Ints, Float64s, Symbols, Dates, DateTimes, and Booleans with default formatting rules\nFlexible methods for manually specifying column types, column nullability, type-specific parsers, column-specific parsers, and columns that should be CategoricalVectors\nCommented lines are skipped on request, blank lines skipped by default\nAbility to skip any rows in the dataset during parsing\nAbility to skip malformed rows\nAbility to trim extra whitespace around fields and end of lines\nAbility to specify how many rows to read for detecting column types\nEscape characters for quotes within quoted fields, and for quotes, newlines, and delimiters outside of quoted fields\nReading files from URLs (via HTTP.jl) and from compressed sources (via TranscodingStreams.jl)\nAnd more!uCSV.read will only try and parse your data into Ints, Float64s, or Strings, by default. No need to worry about the parser imposing any specialty vector- or element-types during the parsing that may conflict with downstream processing. If there's something uCSV doesn't support that you'd like to see, file an issue or open a pull request!"
},

{
    "location": "man/defaults.html#uCSV.write()-1",
    "page": "Getting Started",
    "title": "uCSV.write()",
    "category": "section",
    "text": "Give uCSV.write some data and a header (or just one or the other), a delimiter (if you wan't something other than a comma), a quote character (if you want fields to be quoted), and a declaration of what column-types you'd like to be quoted (it defaults to string columns). That's it!"
},

{
    "location": "man/headers.html#",
    "page": "Headers",
    "title": "Headers",
    "category": "page",
    "text": ""
},

{
    "location": "man/headers.html#Headers-1",
    "page": "Headers",
    "title": "Headers",
    "category": "section",
    "text": "Headers can either be supplied as an integer indicating which line of the dataset should be parsed as the column names.julia> using uCSV\n\njulia> s =\n       \"\"\"\n       c1,c2,c3\n       1,1.0,a\n       2,2.0,b\n       3,3.0,c\n       \"\"\";\n\njulia> data, header = uCSV.read(IOBuffer(s), header = 1);\n\njulia> data\n3-element Array{Any,1}:\n [1, 2, 3]\n [1.0, 2.0, 3.0]\n String[\"a\", \"b\", \"c\"]\n\njulia> header\n3-element Array{String,1}:\n \"c1\"\n \"c2\"\n \"c3\"\nThe user can also supply their own names, which is convenient when the desired output is a DataFrame (see next section).julia> using uCSV\n\njulia> s =\n       \"\"\"\n       1,1.0,a\n       2,2.0,b\n       3,3.0,c\n       \"\"\";\n\njulia> data, header = uCSV.read(IOBuffer(s), header = [\"Ints\", \"Floats\", \"Strings\"])\n\njulia> data\n3-element Array{Any,1}:\n [1, 2, 3]\n [1.0, 2.0, 3.0]\n String[\"a\", \"b\", \"c\"]\n\njulia> header\n3-element Array{String,1}:\n \"Ints\"\n \"Floats\"\n \"Strings\"\n"
},

{
    "location": "man/dataframes.html#",
    "page": "Reading into DataFrames",
    "title": "Reading into DataFrames",
    "category": "page",
    "text": ""
},

{
    "location": "man/dataframes.html#Reading-into-DataFrames-1",
    "page": "Reading into DataFrames",
    "title": "Reading into DataFrames",
    "category": "section",
    "text": "uCSV implements a convenience constructor for DataFrames that takes the output of uCSV.read (a Tuple{Vector::Any, Vector{String}}) and converts it to a DataFrame.note: Note\nWhen NamedTuples becomes available in a release version of Julia, uCSV read will return the data as a NamedTuple object and this function will be deprecated (since DataFrames will implement its own constructor for NamedTuples)julia> using uCSV, DataFrames\n\njulia> s =\n       \"\"\"\n       1.0,1.0,1.0\n       2.0,2.0,2.0\n       3.0,3.0,3.0\n       \"\"\";\n\njulia> DataFrame(uCSV.read(IOBuffer(s)))\n3×3 DataFrames.DataFrame\n│ Row │ x1  │ x2  │ x3  │\n├─────┼─────┼─────┼─────┤\n│ 1   │ 1.0 │ 1.0 │ 1.0 │\n│ 2   │ 2.0 │ 2.0 │ 2.0 │\n│ 3   │ 3.0 │ 3.0 │ 3.0 │\nAnd again, but with a headerjulia> using uCSV, DataFrames\n\njulia> s =\n       \"\"\"\n       c1,c2,c3\n       1,1.0,a\n       2,2.0,b\n       3,3.0,c\n       \"\"\";\n\njulia> DataFrame(uCSV.read(IOBuffer(s), header = 1))\n3×3 DataFrames.DataFrame\n│ Row │ c1 │ c2  │ c3 │\n├─────┼────┼─────┼────┤\n│ 1   │ 1  │ 1.0 │ a  │\n│ 2   │ 2  │ 2.0 │ b  │\n│ 3   │ 3  │ 3.0 │ c  │\n"
},

{
    "location": "man/delimiters.html#",
    "page": "Delimiters",
    "title": "Delimiters",
    "category": "page",
    "text": ""
},

{
    "location": "man/delimiters.html#Delimiters-1",
    "page": "Delimiters",
    "title": "Delimiters",
    "category": "section",
    "text": "Commas are used by defaultjulia> using uCSV, DataFrames\n\njulia> s =\n       \"\"\"\n       1,2,3\n       \"\"\"\n\"1,2,3\\n\"\n\njulia> DataFrame(uCSV.read(IOBuffer(s)))\n1×3 DataFrames.DataFrame\n│ Row │ x1 │ x2 │ x3 │\n├─────┼────┼────┼────┤\n│ 1   │ 1  │ 2  │ 3  │\nSpaces can be usedjulia> using uCSV, DataFrames\n\njulia> s =\n       \"\"\"\n       1 2 3\n       \"\"\"\n\"1 2 3\\n\"\n\njulia> DataFrame(uCSV.read(IOBuffer(s), delim=' '))\n1×3 DataFrames.DataFrame\n│ Row │ x1 │ x2 │ x3 │\n├─────┼────┼────┼────┤\n│ 1   │ 1  │ 2  │ 3  │\nSo can Tabsjulia> using uCSV, DataFrames\n\njulia> s =\n       \"\"\"\n       1\\t2\\t3\n       \"\"\"\n\"1\\t2\\t3\\n\"\n\njulia> DataFrame(uCSV.read(IOBuffer(s), delim='\\t'))\n1×3 DataFrames.DataFrame\n│ Row │ x1 │ x2 │ x3 │\n├─────┼────┼────┼────┤\n│ 1   │ 1  │ 2  │ 3  │\nSo can Stringsjulia> using uCSV, DataFrames\n\njulia> s =\n       \"\"\"\n       1||2||3\n       \"\"\"\n\"1||2||3\\n\"\n\njulia> DataFrame(uCSV.read(IOBuffer(s), delim=\"||\"))\n1×3 DataFrames.DataFrame\n│ Row │ x1 │ x2 │ x3 │\n├─────┼────┼────┼────┤\n│ 1   │ 1  │ 2  │ 3  │\nnon-ASCII characters work just finejulia> using uCSV, DataFrames\n\njulia> s =\n       \"\"\"\n       1˚2˚3\n       \"\"\"\n\"1˚2˚3\\n\"\n\njulia> DataFrame(uCSV.read(IOBuffer(s), delim='˚'))\n1×3 DataFrames.DataFrame\n│ Row │ x1 │ x2 │ x3 │\n├─────┼────┼────┼────┤\n│ 1   │ 1  │ 2  │ 3  │\nnon-ASCII strings work toojulia> using uCSV, DataFrames\n\njulia> s =\n       \"\"\"\n       1≤≥2≤≥3\n       \"\"\"\n\"1≤≥2≤≥3\\n\"\n\njulia> DataFrame(uCSV.read(IOBuffer(s), delim=\"≤≥\"))\n1×3 DataFrames.DataFrame\n│ Row │ x1 │ x2 │ x3 │\n├─────┼────┼────┼────┤\n│ 1   │ 1  │ 2  │ 3  │\n"
},

{
    "location": "man/missingdata.html#",
    "page": "Missing Data",
    "title": "Missing Data",
    "category": "page",
    "text": ""
},

{
    "location": "man/missingdata.html#Missing-Data-1",
    "page": "Missing Data",
    "title": "Missing Data",
    "category": "section",
    "text": "Missing data is very common in many fields of research, but not ALL fields of research. In addition, users may want to handle different encodings for missing data differently, e.g. encoding data that has been masked/removed for privacy reasons with a different value than data that simply doesn't exist. To enable these distinctions, uCSV requires that users provide arguments that instruct uCSV.read how they would like missing data to be parsed, how many rows should be read to automatically detect null values encoded by the user (for setting column types to Union{T, Null}), and/or to declare up-front which columns should allow missing values (For cases when the first missing value encountered in a column is many rows into the dataset. Declaring these columns to be nullable up-front and keeping typedetectrows set to low values improves parsing performance relative to asking uCSV.read to auto-detect columns with missing values via large typedetectrows values).Detecting columns that contain missing values via typedetectrowsjulia> using uCSV, DataFrames, Nulls\n\njulia> s =\n       \"\"\"\n       1,hey,1\n       2,you,2\n       3,,3\n       4,\"\",4\n       5,NULL,5\n       6,NA,6\n       \"\"\";\n\njulia> encodings = Dict{String, Any}(\"\" => null, \"\\\"\\\"\" => null, \"NULL\" => null, \"NA\" => null);\n\njulia> DataFrame(uCSV.read(IOBuffer(s), encodings=encodings, typedetectrows=3))\n6×3 DataFrames.DataFrame\n│ Row │ x1 │ x2   │ x3 │\n├─────┼────┼──────┼────┤\n│ 1   │ 1  │ hey  │ 1  │\n│ 2   │ 2  │ you  │ 2  │\n│ 3   │ 3  │ null │ 3  │\n│ 4   │ 4  │ null │ 4  │\n│ 5   │ 5  │ null │ 5  │\n│ 6   │ 6  │ null │ 6  │\nDeclaring that all columns may contain missing valuesjulia> using uCSV, DataFrames, Nulls\n\njulia> s =\n       \"\"\"\n       1,hey,1\n       2,you,2\n       3,,3\n       4,\"\",4\n       5,NULL,5\n       6,NA,6\n       \"\"\";\n\njulia> encodings = Dict{String, Any}(\"\" => null, \"\\\"\\\"\" => null, \"NULL\" => null, \"NA\" => null);\n\njulia> DataFrame(uCSV.read(IOBuffer(s), encodings=encodings, isnullable=true))\n6×3 DataFrames.DataFrame\n│ Row │ x1 │ x2   │ x3 │\n├─────┼────┼──────┼────┤\n│ 1   │ 1  │ hey  │ 1  │\n│ 2   │ 2  │ you  │ 2  │\n│ 3   │ 3  │ null │ 3  │\n│ 4   │ 4  │ null │ 4  │\n│ 5   │ 5  │ null │ 5  │\n│ 6   │ 6  │ null │ 6  │\nDeclaring whether each column may contain missing values with a boolean vectorjulia> using uCSV, DataFrames, Nulls\n\njulia> s =\n       \"\"\"\n       1,hey,1\n       2,you,2\n       3,,3\n       4,\"\",4\n       5,NULL,5\n       6,NA,6\n       \"\"\";\n\njulia> encodings = Dict{String, Any}(\"\" => null, \"\\\"\\\"\" => null, \"NULL\" => null, \"NA\" => null);\n\njulia> DataFrame(uCSV.read(IOBuffer(s), encodings=encodings, isnullable=[false, true, false]))\n6×3 DataFrames.DataFrame\n│ Row │ x1 │ x2   │ x3 │\n├─────┼────┼──────┼────┤\n│ 1   │ 1  │ hey  │ 1  │\n│ 2   │ 2  │ you  │ 2  │\n│ 3   │ 3  │ null │ 3  │\n│ 4   │ 4  │ null │ 4  │\n│ 5   │ 5  │ null │ 5  │\n│ 6   │ 6  │ null │ 6  │\nDeclaring the nullability of a subset of columns with a Dictionary (keys are column indices)julia> using uCSV, DataFrames, Nulls\n\njulia> s =\n       \"\"\"\n       1,hey,1\n       2,you,2\n       3,,3\n       4,\"\",4\n       5,NULL,5\n       6,NA,6\n       \"\"\";\n\njulia> encodings = Dict{String, Any}(\"\" => null, \"\\\"\\\"\" => null, \"NULL\" => null, \"NA\" => null);\n\njulia> DataFrame(uCSV.read(IOBuffer(s), encodings=encodings, isnullable=Dict(2 => true)))\n6×3 DataFrames.DataFrame\n│ Row │ x1 │ x2   │ x3 │\n├─────┼────┼──────┼────┤\n│ 1   │ 1  │ hey  │ 1  │\n│ 2   │ 2  │ you  │ 2  │\n│ 3   │ 3  │ null │ 3  │\n│ 4   │ 4  │ null │ 4  │\n│ 5   │ 5  │ null │ 5  │\n│ 6   │ 6  │ null │ 6  │\nDeclaring the nullability of a subset of columns with a Dictionary (keys are column names)julia> using uCSV, DataFrames, Nulls\n\njulia> s =\n       \"\"\"\n       a,b,c\n       1,hey,1\n       2,you,2\n       3,,3\n       4,\"\",4\n       5,NULL,5\n       6,NA,6\n       \"\"\";\n\njulia> encodings = Dict{String, Any}(\"\" => null, \"\\\"\\\"\" => null, \"NULL\" => null, \"NA\" => null);\n\njulia> DataFrame(uCSV.read(IOBuffer(s), encodings=encodings, header=1, isnullable=Dict(\"b\" => true)))\n6×3 DataFrames.DataFrame\n│ Row │ a │ b    │ c │\n├─────┼───┼──────┼───┤\n│ 1   │ 1 │ hey  │ 1 │\n│ 2   │ 2 │ you  │ 2 │\n│ 3   │ 3 │ null │ 3 │\n│ 4   │ 4 │ null │ 4 │\n│ 5   │ 5 │ null │ 5 │\n│ 6   │ 6 │ null │ 6 │\nDeclaring the nullability of a subset of columns by specifying the element-typejulia> using uCSV, DataFrames, Nulls\n\njulia> s =\n       \"\"\"\n       1,hey,1\n       2,you,2\n       3,,3\n       4,\"\",4\n       5,NULL,5\n       6,NA,6\n       \"\"\";\n\njulia> encodings = Dict{String, Any}(\"\" => null, \"\\\"\\\"\" => null, \"NULL\" => null, \"NA\" => null);\n\njulia> DataFrame(uCSV.read(IOBuffer(s), encodings=encodings, types=Dict(2 => Union{String, Null})))\n6×3 DataFrames.DataFrame\n│ Row │ x1 │ x2   │ x3 │\n├─────┼────┼──────┼────┤\n│ 1   │ 1  │ hey  │ 1  │\n│ 2   │ 2  │ you  │ 2  │\n│ 3   │ 3  │ null │ 3  │\n│ 4   │ 4  │ null │ 4  │\n│ 5   │ 5  │ null │ 5  │\n│ 6   │ 6  │ null │ 6  │\n"
},

{
    "location": "man/declaring-column-element-types.html#",
    "page": "Declaring Column Element Types",
    "title": "Declaring Column Element Types",
    "category": "page",
    "text": ""
},

{
    "location": "man/declaring-column-element-types.html#Declaring-Column-Element-Types-1",
    "page": "Declaring Column Element Types",
    "title": "Declaring Column Element Types",
    "category": "section",
    "text": ""
},

{
    "location": "man/declaring-column-element-types.html#Booleans-1",
    "page": "Declaring Column Element Types",
    "title": "Booleans",
    "category": "section",
    "text": "If booleans are encoded as lower-case trues and falses in your dataset, the default parse function for booleans can be used. You can request this by setting the type argument.Declaring all columns to be booleanjulia> using uCSV, DataFrames\n\njulia> s =\n       \"\"\"\n       true\n       false\n       \"\"\";\n\njulia> DataFrame(uCSV.read(IOBuffer(s), types=Bool))\n2×1 DataFrames.DataFrame\n│ Row │ x1    │\n├─────┼───────┤\n│ 1   │ true  │\n│ 2   │ false │\nDeclaring the type of each column with a vectorjulia> using uCSV, DataFrames\n\njulia> s =\n       \"\"\"\n       true\n       false\n       \"\"\";\n\njulia> DataFrame(uCSV.read(IOBuffer(s), types=[Bool]))\n2×1 DataFrames.DataFrame\n│ Row │ x1    │\n├─────┼───────┤\n│ 1   │ true  │\n│ 2   │ false │\nDeclaring the type of specific columns with a dictionaryjulia> using uCSV, DataFrames\n\njulia> s =\n       \"\"\"\n       true\n       false\n       \"\"\";\n\njulia> DataFrame(uCSV.read(IOBuffer(s), types=Dict(1 => Bool)))\n2×1 DataFrames.DataFrame\n│ Row │ x1    │\n├─────┼───────┤\n│ 1   │ true  │\n│ 2   │ false │\nSpecifying the text-encodings for your boolean valuesjulia> using uCSV, DataFrames\n\njulia> s =\n       \"\"\"\n       T\n       F\n       True\n       False\n       0\n       1\n       yes\n       no\n       y\n       n\n       YES\n       NO\n       Yes\n       No\n       \"\"\";\n\njulia> trues = Dict{String, Any}(s => true for s in [\"T\", \"True\", \"1\", \"yes\", \"y\", \"YES\", \"Yes\"])\nDict{String,Any} with 7 entries:\n  \"YES\"  => true\n  \"True\" => true\n  \"1\"    => true\n  \"yes\"  => true\n  \"T\"    => true\n  \"Yes\"  => true\n  \"y\"    => true\n\njulia> falses = Dict{String, Any}(s => false for s in [\"F\", \"False\", \"0\", \"no\", \"n\", \"NO\", \"No\"])\nDict{String,Any} with 7 entries:\n  \"NO\"    => false\n  \"No\"    => false\n  \"False\" => false\n  \"0\"     => false\n  \"no\"    => false\n  \"F\"     => false\n  \"n\"     => false\n\njulia> DataFrame(uCSV.read(IOBuffer(s), encodings=merge(trues, falses)))\n14×1 DataFrames.DataFrame\n│ Row │ x1    │\n├─────┼───────┤\n│ 1   │ true  │\n│ 2   │ false │\n│ 3   │ true  │\n│ 4   │ false │\n│ 5   │ false │\n│ 6   │ true  │\n│ 7   │ true  │\n│ 8   │ false │\n│ 9   │ true  │\n│ 10  │ false │\n│ 11  │ true  │\n│ 12  │ false │\n│ 13  │ true  │\n│ 14  │ false │\n"
},

{
    "location": "man/declaring-column-element-types.html#Symbols-1",
    "page": "Declaring Column Element Types",
    "title": "Symbols",
    "category": "section",
    "text": "Declaring all columns as Symboljulia> using uCSV, DataFrames\n\njulia> s =\n       \"\"\"\n       x1\n       y7\n       µ∆\n       \"\"\";\n\njulia> df = DataFrame(uCSV.read(IOBuffer(s), types=Symbol))\n3×1 DataFrames.DataFrame\n│ Row │ x1 │\n├─────┼────┤\n│ 1   │ x1 │\n│ 2   │ y7 │\n│ 3   │ µ∆ │\n\njulia> eltype.(df.columns) == [Symbol]\ntrue\nDeclaring the type of each columnjulia> using uCSV, DataFrames\n\njulia> s =\n       \"\"\"\n       x1\n       y7\n       µ∆\n       \"\"\";\n\njulia> df = DataFrame(uCSV.read(IOBuffer(s), types=[Symbol]))\n3×1 DataFrames.DataFrame\n│ Row │ x1 │\n├─────┼────┤\n│ 1   │ x1 │\n│ 2   │ y7 │\n│ 3   │ µ∆ │\n\njulia> eltype.(df.columns) == [Symbol]\ntrue\nDeclaring the type of specific columnsjulia> using uCSV, DataFrames\n\njulia> s =\n       \"\"\"\n       x1\n       y7\n       µ∆\n       \"\"\";\n\njulia> df = DataFrame(uCSV.read(IOBuffer(s), types=Dict(1 => Symbol)))\n3×1 DataFrames.DataFrame\n│ Row │ x1 │\n├─────┼────┤\n│ 1   │ x1 │\n│ 2   │ y7 │\n│ 3   │ µ∆ │\n\njulia> eltype.(df.columns) == [Symbol]\ntrue\n"
},

{
    "location": "man/declaring-column-element-types.html#Dates-1",
    "page": "Declaring Column Element Types",
    "title": "Dates",
    "category": "section",
    "text": "Dates that are parseable with the default formattingjulia> using uCSV, DataFrames\n\njulia> s =\n       \"\"\"\n       2013-01-01\n       \"\"\";\n\njulia> DataFrame(uCSV.read(IOBuffer(s), types=Date))\n1×1 DataFrames.DataFrame\n│ Row │ x1         │\n├─────┼────────────┤\n│ 1   │ 2013-01-01 │\n"
},

{
    "location": "man/declaring-column-element-types.html#Dates-that-require-user-specified-parsing-rules-1",
    "page": "Declaring Column Element Types",
    "title": "Dates that require user-specified parsing rules",
    "category": "section",
    "text": "note: Note\nCheck out the full list of available formatting options for Dates/DateTimes in the Julia docsSpecifying column types in conjunction with declaring a type-specific parser functionjulia> using uCSV, DataFrames\n\njulia> s =\n       \"\"\"\n       12/24/36\n       \"\"\";\n\njulia> DataFrame(uCSV.read(IOBuffer(s), types=Date, typeparsers=Dict(Date => x -> Date(x, \"m/d/y\"))))\n1×1 DataFrames.DataFrame\n│ Row │ x1         │\n├─────┼────────────┤\n│ 1   │ 0036-12-24 │\nSpecifying a column-specific parser functionjulia> using uCSV, DataFrames\n\njulia> s =\n       \"\"\"\n       12/24/36\n       \"\"\";\n\njulia> DataFrame(uCSV.read(IOBuffer(s), colparsers=Dict(1 => x -> Date(x, \"m/d/y\"))))\n1×1 DataFrames.DataFrame\n│ Row │ x1         │\n├─────┼────────────┤\n│ 1   │ 0036-12-24 │\n"
},

{
    "location": "man/declaring-column-element-types.html#DateTimes-1",
    "page": "Declaring Column Element Types",
    "title": "DateTimes",
    "category": "section",
    "text": "The same techniques demonstrated for other types also apply here. To make it interesting, let's try handling multiple encodings at once.julia> using uCSV, DataFrames\n\njulia> s =\n       \"\"\"\n       2015-01-01 00:00:00\n       2015-01-02 00:00:01\n       2015-01-03 00:12:00.001\n       \"\"\";\n\njulia> function datetimeparser(x)\n           if in('.', x)\n              return DateTime(x, \"y-m-d H:M:S.s\")\n          else\n              return DateTime(x, \"y-m-d H:M:S\")\n          end\n       end\ndatetimeparser (generic function with 1 method)\n\njulia> DataFrame(uCSV.read(IOBuffer(s), colparsers=(x -> datetimeparser(x))))\n3×1 DataFrames.DataFrame\n│ Row │ x1                      │\n├─────┼─────────────────────────┤\n│ 1   │ 2015-01-01T00:00:00     │\n│ 2   │ 2015-01-02T00:00:01     │\n│ 3   │ 2015-01-03T00:12:00.001 │\n"
},

{
    "location": "man/declaring-column-vector-types.html#",
    "page": "Declaring Column Vector Types",
    "title": "Declaring Column Vector Types",
    "category": "page",
    "text": ""
},

{
    "location": "man/declaring-column-vector-types.html#Declaring-Column-Vector-Types-1",
    "page": "Declaring Column Vector Types",
    "title": "Declaring Column Vector Types",
    "category": "section",
    "text": ""
},

{
    "location": "man/declaring-column-vector-types.html#CategoricalArrays-1",
    "page": "Declaring Column Vector Types",
    "title": "CategoricalArrays",
    "category": "section",
    "text": "Declaring all columns should be parsed as CategoricalArraysjulia> using uCSV, DataFrames\n\njulia> s =\n       \"\"\"\n       a,b,c\n       a,b,c\n       a,b,c\n       a,b,c\n       \"\"\";\n\njulia> eltype.(DataFrame(uCSV.read(IOBuffer(s), iscategorical=true)).columns)\n3-element Array{DataType,1}:\n CategoricalArrays.CategoricalValue{String,UInt32}\n CategoricalArrays.CategoricalValue{String,UInt32}\n CategoricalArrays.CategoricalValue{String,UInt32}\nDeclaring whether each column should be a CategoricalArray or notjulia> using uCSV, DataFrames\n\njulia> s =\n       \"\"\"\n       a,b,c\n       a,b,c\n       a,b,c\n       a,b,c\n       \"\"\";\n\njulia> eltype.(DataFrame(uCSV.read(IOBuffer(s), iscategorical=[true, true, true])).columns)\n3-element Array{DataType,1}:\n CategoricalArrays.CategoricalValue{String,UInt32}\n CategoricalArrays.CategoricalValue{String,UInt32}\n CategoricalArrays.CategoricalValue{String,UInt32}\nDeclaring whether specific columns should be CategoricalArrays by indexjulia> using uCSV, DataFrames\n\njulia> s =\n       \"\"\"\n       a,b,c\n       a,b,c\n       a,b,c\n       a,b,c\n       \"\"\";\n\njulia> eltype.(DataFrame(uCSV.read(IOBuffer(s), iscategorical=Dict(3 => true))).columns)\n3-element Array{DataType,1}:\n String\n String\n CategoricalArrays.CategoricalValue{String,UInt32}\nDeclaring whether specific columns should be CategoricalArrays by column namejulia> using uCSV, DataFrames\n\njulia> s =\n       \"\"\"\n       a,b,c\n       a,b,c\n       a,b,c\n       a,b,c\n       \"\"\";\n\njulia> eltype.(DataFrame(uCSV.read(IOBuffer(s), header=1, iscategorical=Dict(\"a\" => true))).columns)\n3-element Array{DataType,1}:\n CategoricalArrays.CategoricalValue{String,UInt32}\n String\n String\n"
},

{
    "location": "man/declaring-column-vector-types.html#Other-Vector-Types-1",
    "page": "Declaring Column Vector Types",
    "title": "Other Vector Types",
    "category": "section",
    "text": ""
},

{
    "location": "man/declaring-column-vector-types.html#TODO-1",
    "page": "Declaring Column Vector Types",
    "title": "TODO",
    "category": "section",
    "text": ""
},

{
    "location": "man/international.html#",
    "page": "International Representations for Numbers",
    "title": "International Representations for Numbers",
    "category": "page",
    "text": ""
},

{
    "location": "man/international.html#International-Representations-for-Numbers-1",
    "page": "International Representations for Numbers",
    "title": "International Representations for Numbers",
    "category": "section",
    "text": "This strategy applies to any number of international data representation formats, however the most commonly requested format to support appears to be decimal-comma floats.This can be done by declaring the column types in conjunction with a type-specific parser that overrides the default Float64 parsingjulia> using uCSV, DataFrames\n\njulia> s =\n       \"\"\"\n       19,97;3,14;999\n       \"\"\";\n\njulia> imperialize(x) = parse(Float64, replace(x, ',', '.'))\nimperialize (generic function with 1 method)\n\njulia> DataFrame(uCSV.read(IOBuffer(s), delim=';', types=Dict(1 => Float64, 2 => Float64), typeparsers=Dict(Float64 => x -> imperialize(x))))\n1×3 DataFrames.DataFrame\n│ Row │ x1    │ x2   │ x3  │\n├─────┼───────┼──────┼─────┤\n│ 1   │ 19.97 │ 3.14 │ 999 │\nOr by declaring the column parsers directlyjulia> using uCSV, DataFrames\n\njulia> s =\n       \"\"\"\n       19,97;3,14;999\n       \"\"\";\n\njulia> imperialize(x) = parse(Float64, replace(x, ',', '.'))\nimperialize (generic function with 1 method)\n\njulia> DataFrame(uCSV.read(IOBuffer(s), delim=';', colparsers=Dict(1 => x -> imperialize(x), 2 => x -> imperialize(x))))\n1×3 DataFrames.DataFrame\n│ Row │ x1    │ x2   │ x3  │\n├─────┼───────┼──────┼─────┤\n│ 1   │ 19.97 │ 3.14 │ 999 │"
},

{
    "location": "man/customparsers.html#",
    "page": "Custom Parsers",
    "title": "Custom Parsers",
    "category": "page",
    "text": ""
},

{
    "location": "man/customparsers.html#Custom-Parsers-1",
    "page": "Custom Parsers",
    "title": "Custom Parsers",
    "category": "section",
    "text": "You can declare any parser function that takes T <: AbstractString and returns a Julia value.Your custom parsers can be applied to specific columnsusing uCSV, DataFrames\nfunction myparser(x)\n    # code\nend\nmy_input = ...\nuCSV.read(my_input, colparsers=Dict(column => x -> myparser(x)))You can also declare the relevant column-types and implement parsers specific to that typeusing uCSV, DataFrames\nfunction myparser(x)\n    # code\nend\nmy_input = ...\nuCSV.read(my_input, types=Dict(1 => MyType), typeparsers=Dict(MyType => x -> myparser(x)))"
},

{
    "location": "man/quotes-escapes.html#",
    "page": "Quotes and Escapes",
    "title": "Quotes and Escapes",
    "category": "page",
    "text": ""
},

{
    "location": "man/quotes-escapes.html#Quotes-and-Escapes-1",
    "page": "Quotes and Escapes",
    "title": "Quotes and Escapes",
    "category": "section",
    "text": ""
},

{
    "location": "man/quotes-escapes.html#Quoted-Fields-1",
    "page": "Quotes and Escapes",
    "title": "Quoted Fields",
    "category": "section",
    "text": "Quotes are not interpreted by defaultjulia> using uCSV, DataFrames\n\njulia> s =\n       \"\"\"\n       \"I,have,delimiters,in,my,field\"\n       \"\"\";\n\njulia> DataFrame(uCSV.read(IOBuffer(s)))\n1×6 DataFrames.DataFrame\n│ Row │ x1 │ x2   │ x3         │ x4 │ x5 │ x6     │\n├─────┼────┼──────┼────────────┼────┼────┼────────┤\n│ 1   │ \"I │ have │ delimiters │ in │ my │ field\" │\nBut you can declare the character that uCSV.read should interpret as a quotejulia> using uCSV, DataFrames\n\njulia> s =\n       \"\"\"\n       \"I,have,delimiters,in,my,field\"\n       \"\"\";\n\njulia> DataFrame(uCSV.read(IOBuffer(s), quotes='\"'))\n1×1 DataFrames.DataFrame\n│ Row │ x1                            │\n├─────┼───────────────────────────────┤\n│ 1   │ I,have,delimiters,in,my,field │\n"
},

{
    "location": "man/quotes-escapes.html#Quoted-Fields-w/-Internal-Double-Quotes-1",
    "page": "Quotes and Escapes",
    "title": "Quoted Fields w/ Internal Double Quotes",
    "category": "section",
    "text": "A common convention is to have double-quotes within quoted fields to represent text that should remain quoted after parsing.julia> using uCSV, DataFrames\n\njulia> players = [\"\\\"Rich \\\"\\\"Goose\\\"\\\" Gossage\\\"\",\n                  \"\\\"Henry \\\"\\\"Hammerin' Hank\\\"\\\" Aaron\\\"\"];\n\njulia> for p in players\n           println(p)\n       end\n\"Rich \"\"Goose\"\" Gossage\"\n\"Henry \"\"Hammerin' Hank\"\" Aaron\"\n\njulia> DataFrame(uCSV.read(IOBuffer(join(names, '\\n')), quotes='\"', escape='\"'))\n2×1 DataFrames.DataFrame\n│ Row │ x1                           │\n├─────┼──────────────────────────────┤\n│ 1   │ Rich \"Goose\" Gossage         │\n│ 2   │ Henry \"Hammerin' Hank\" Aaron │\n"
},

{
    "location": "man/quotes-escapes.html#Escapes-1",
    "page": "Quotes and Escapes",
    "title": "Escapes",
    "category": "section",
    "text": "Special characters that would normally be parsed as quotes, newlines, or delimiters can be escapedjulia> using uCSV, DataFrames\n\njulia> players = [\"\\\"Rich \\\\\\\"Goose\\\\\\\" Gossage\\\"\",\n                  \"\\\"Henry \\\\\\\"Hammerin' Hank\\\\\\\" Aaron\\\"\"];\n\njulia> for p in players\n           println(p)\n       end\n\"Rich \\\"Goose\\\" Gossage\"\n\"Henry \\\"Hammerin' Hank\\\" Aaron\"\n\njulia> DataFrame(uCSV.read(IOBuffer(join(names, '\\n')), quotes='\"', escape='\\\\'))\n2×1 DataFrames.DataFrame\n│ Row │ x1                           │\n├─────┼──────────────────────────────┤\n│ 1   │ Rich \"Goose\" Gossage         │\n│ 2   │ Henry \"Hammerin' Hank\" Aaron │\n"
},

{
    "location": "man/comments-skiplines.html#",
    "page": "Skipping Comments and Rows",
    "title": "Skipping Comments and Rows",
    "category": "page",
    "text": ""
},

{
    "location": "man/comments-skiplines.html#Skipping-Comments-and-Rows-1",
    "page": "Skipping Comments and Rows",
    "title": "Skipping Comments and Rows",
    "category": "section",
    "text": "Skipping comments by declaring what commented lines start withjulia> using uCSV, DataFrames\n\njulia> s =\n       \"\"\"\n       # i am a comment\n       data\n       \"\"\";\n\njulia> DataFrame(uCSV.read(IOBuffer(s), comment='#'))\n1×1 DataFrames.DataFrame\n│ Row │ x1   │\n├─────┼──────┤\n│ 1   │ data │\nSkipping comments by declaring what line the dataset starts onjulia> using uCSV, DataFrames\n\njulia> s =\n       \"\"\"\n       # i am a comment\n       data\n       \"\"\";\n\njulia> DataFrame(uCSV.read(IOBuffer(s), skiprows=1:1))\n1×1 DataFrames.DataFrame\n│ Row │ x1   │\n├─────┼──────┤\n│ 1   │ data │\nSkipping comments by declaring what line the header starts onjulia> using uCSV\n\njulia> s =\n       \"\"\"\n       # i am a comment\n       I'm the header\n       \"\"\";\n\njulia> data, header = uCSV.read(IOBuffer(s), header=2);\n\njulia> data\n0-element Array{Any,1}\n\njulia> header\n1-element Array{String,1}:\n \"I'm the header\"\nSkipping comments by declaring what commented lines start with and what line the header starts.note: Note\nLines skipped because they are blank/empty or via comment=\"...\" are not counted towards the row number used for locating header=#. For example, if the first 5 lines of your file are blank, and the next 5 are comments, you would still set header=1 to read the row that is on the 11-th line of the input source.julia> using uCSV\n\njulia> s =\n       \"\"\"\n       # i am a comment\n       I'm the header\n       \"\"\";\n\njulia> data, header = uCSV.read(IOBuffer(s), comment='#', header=1);\n\njulia> data\n0-element Array{Any,1}\n\njulia> header\n1-element Array{String,1}:\n \"I'm the header\"\nSkipping comments, declaring the header row, and skipping some datajulia> using uCSV, DataFrames\n\njulia> s =\n       \"\"\"\n       # i am a comment\n       I'm the header\n       skipped data\n       included data\n       \"\"\";\n\njulia> DataFrame(uCSV.read(IOBuffer(s), comment='#', header=1, skiprows=1:1))\n1×1 DataFrames.DataFrame\n│ Row │ I'm the header │\n├─────┼────────────────┤\n│ 1   │ included data  │\njulia> using uCSV, DataFrames\n\njulia> s =\n       \"\"\"\n       # i am a comment\n       I'm the header\n       skipped data\n       included data\n       \"\"\";\n\njulia> DataFrame(uCSV.read(IOBuffer(s), skiprows=1:3))\n1×1 DataFrames.DataFrame\n│ Row │ x1            │\n├─────┼───────────────┤\n│ 1   │ included data │\nnote: Note\nLines skipped via skiprows do not count towards the number of lines used for detecting column-types with typedetectrows"
},

{
    "location": "man/malformed.html#",
    "page": "Malformed Data",
    "title": "Malformed Data",
    "category": "page",
    "text": ""
},

{
    "location": "man/malformed.html#Malformed-Data-1",
    "page": "Malformed Data",
    "title": "Malformed Data",
    "category": "section",
    "text": "In really large and messy datasets, you may just want to skip the malformed rows.julia> using uCSV, DataFrames, Base.Test\n\njulia> s =\n       \"\"\"\n       1\n       1,2\n       \"\"\";\n\njulia> e = @test_throws ErrorException DataFrame(uCSV.read(IOBuffer(s)))\nTest Passed\n\n      Thrown: ErrorException\n\njulia> @test e.value.msg == \"\"\"\n                            Parsed 2 fields on row 2. Expected 1.\n                            line:\n                            1,2\n                            Possible fixes may include:\n                              1. including 2 in the `skiprows` argument\n                              2. setting `skipmalformed=true`\n                              3. if this line is a comment, setting the `comment` argument\n                              4. if fields are quoted, setting the `quotes` argument\n                              5. if special characters are escaped, setting the `escape` argument\n                              6. fixing the malformed line in the source or file before invoking `uCSV.read`\n                            \"\"\"\nTest Passed\n\n\njulia> DataFrame(uCSV.read(IOBuffer(s), skipmalformed=true))\nWARNING: Parsed 2 fields on row 2. Expected 1. Skipping...\n1×1 DataFrames.DataFrame\n│ Row │ x1 │\n├─────┼────┤\n│ 1   │ 1  │\n"
},

{
    "location": "man/url.html#",
    "page": "Reading data from URLs",
    "title": "Reading data from URLs",
    "category": "page",
    "text": ""
},

{
    "location": "man/url.html#Reading-data-from-URLs-1",
    "page": "Reading data from URLs",
    "title": "Reading data from URLs",
    "category": "section",
    "text": "Using the HTTP.jl packagejulia> using uCSV, DataFrames, HTTP\n\njulia> html = \"https://raw.github.com/vincentarelbundock/Rdatasets/master/csv/datasets/USPersonalExpenditure.csv\";\n\njulia> DataFrame(uCSV.read(HTTP.body(HTTP.get(html)), quotes='\"', header=1))\n5×6 DataFrames.DataFrame\n│ Row │                     │ 1940  │ 1945  │ 1950 │ 1955 │ 1960 │\n├─────┼─────────────────────┼───────┼───────┼──────┼──────┼──────┤\n│ 1   │ Food and Tobacco    │ 22.2  │ 44.5  │ 59.6 │ 73.2 │ 86.8 │\n│ 2   │ Household Operation │ 10.5  │ 15.5  │ 29.0 │ 36.5 │ 46.2 │\n│ 3   │ Medical and Health  │ 3.53  │ 5.76  │ 9.71 │ 14.0 │ 21.1 │\n│ 4   │ Personal Care       │ 1.04  │ 1.98  │ 2.45 │ 3.4  │ 5.4  │\n│ 5   │ Private Education   │ 0.341 │ 0.974 │ 1.8  │ 2.6  │ 3.64 │\n"
},

{
    "location": "man/compressed.html#",
    "page": "Reading Compressed Datasets",
    "title": "Reading Compressed Datasets",
    "category": "page",
    "text": ""
},

{
    "location": "man/compressed.html#Reading-Compressed-Datasets-1",
    "page": "Reading Compressed Datasets",
    "title": "Reading Compressed Datasets",
    "category": "section",
    "text": "Using the TranscodingStreams.jl ecosystem of packages is the currently recommended approach, although other methods should work as well!julia> using uCSV, DataFrames, CodecZlib\n\njulia> iris_file = joinpath(Pkg.dir(\"uCSV\"), \"test\", \"data\", \"iris.csv.gz\");\n\njulia> iris_io = GzipDecompressionStream(open(iris_file));\n\njulia> DataFrame(uCSV.read(iris_io, header=1))[1:5, :Species]\n5-element Array{String,1}:\n \"Iris-setosa\"\n \"Iris-setosa\"\n \"Iris-setosa\"\n \"Iris-setosa\"\n \"Iris-setosa\"\n"
},

{
    "location": "man/unsupported.html#",
    "page": "Common formatting issues",
    "title": "Common formatting issues",
    "category": "page",
    "text": ""
},

{
    "location": "man/unsupported.html#Common-formatting-issues-1",
    "page": "Common formatting issues",
    "title": "Common formatting issues",
    "category": "section",
    "text": ""
},

{
    "location": "man/unsupported.html#Dataset-isn't-UTF-8-1",
    "page": "Common formatting issues",
    "title": "Dataset isn't UTF-8",
    "category": "section",
    "text": "This package relies heavily on the String capabilities of the base Julia language and implements very little custom text processing. If you see garbled characters output by uCSV.read, there's a good chance that your dataset is not encoded in UTF-8 and needs to be converted."
},

{
    "location": "man/unsupported.html#Recommended-Solutions-1",
    "page": "Common formatting issues",
    "title": "Recommended Solutions",
    "category": "section",
    "text": "For converting your text file to UTF-8, consider using tools like iconv or StringEncodings.jl."
},

{
    "location": "man/unsupported.html#Dataset-doesn't-use-Unix-\\n-or-Windows-\\r\\n-line-endings-1",
    "page": "Common formatting issues",
    "title": "Dataset doesn't use Unix \\n or Windows \\r\\n line endings",
    "category": "section",
    "text": "You'll probably catch this when you try to read your data and it's parsed as 1 giant row with \\r characters in the fields where you expected new rows to begin. This line ending was used by old Mac OS operating systems and continued to be used by Excel for Mac 2003, 2007, and 2011 long after Mac OS switched to using Unix-style \\n line endings.Try viewing your file in a command-line plain text viewer like vi or less. If you see ^M character sequences at the expected line breaks, you'll need to convert those to either Unix-style \\n or Windows-style \\r\\n yourself."
},

{
    "location": "man/unsupported.html#Recommended-Solutions-2",
    "page": "Common formatting issues",
    "title": "Recommended Solutions",
    "category": "section",
    "text": "Unix/Linux/MacOSUsing homebrew/linuxbrewbrew install dos2unix\nmac2unix my_file.macOS9.csv my_file.unix.csvtrcat my_file.macOS9.csv | tr '\\r' '\\n' > my_file.unix.csvThis can also be done with vi, sed, perl, awk, emacs, and many other command line text editing tools. If you'd like to see more examples here and have one to contribute, please open a PR!Juliaif starting with a filemacOS9_io = open(\"/path/to/my/file.csv\")\n# continue to the next exampleif starting with an IOStreamunix_io = IOBuffer(replace(read(macOS9_io, String), '\\r', '\\n'))\n# this can now be passed to uCSV.read"
},

{
    "location": "man/unsupported.html#[\"Smart\"-punctation](http://smartquotesforsmartpeople.com/)-1",
    "page": "Common formatting issues",
    "title": "\"Smart\" punctation",
    "category": "section",
    "text": "Any individual \"smart\" quote will work, but paired \"smart\" quotes where beginning and ends are oriented differently are not supported."
},

{
    "location": "man/unsupported.html#Recommended-Solutions-3",
    "page": "Common formatting issues",
    "title": "Recommended Solutions",
    "category": "section",
    "text": "Blast them away in your favorite text-editor with find and replace."
},

{
    "location": "man/benchmarks.html#",
    "page": "Benchmarks",
    "title": "Benchmarks",
    "category": "page",
    "text": ""
},

{
    "location": "man/benchmarks.html#Benchmarks-1",
    "page": "Benchmarks",
    "title": "Benchmarks",
    "category": "section",
    "text": "Note these are not exhaustive, but I've done by best to cover various common formats and to ensure that all of the readers output the data using standard Julia Vectors and Types for accurate comparison. This does not necessarily reflect the strengths or weaknesses of the other packages relative to uCSV."
},

{
    "location": "man/benchmarks.html#Read-1",
    "page": "Benchmarks",
    "title": "Read",
    "category": "section",
    "text": ""
},

{
    "location": "man/benchmarks.html#Setup-1",
    "page": "Benchmarks",
    "title": "Setup",
    "category": "section",
    "text": "All data will be read into equivalent DataFramesusing uCSV, CSV, TextParse, CodecZlib, Nulls, DataFrames, Base.Test\nGDS = GzipDecompressionStream;\n\nfunction textparse2DF(x)\n    DataFrame(Any[x[1]...], Symbol.(x[2]))\nend"
},

{
    "location": "man/benchmarks.html#[Iris](https://github.com/cjprybol/uCSV.jl/blob/master/test/data/iris.csv.gz)-1",
    "page": "Benchmarks",
    "title": "Iris",
    "category": "section",
    "text": "iris_file = joinpath(Pkg.dir(\"uCSV\"), \"test\", \"data\", \"iris.csv.gz\");\n@time df1 = DataFrame(uCSV.read(GDS(open(iris_file)), header=1));\n@time df2 = CSV.read(GDS(open(iris_file)), types=Dict(6=>String));\n@time df3 = textparse2DF(csvread(GDS(open(iris_file)), pooledstrings=false));\n@test df1 == df2 == df3julia> @time df1 = DataFrame(uCSV.read(GDS(open(iris_file)), header=1));\n  3.791587 seconds (2.52 M allocations: 127.846 MiB, 1.99% gc time)\n\njulia> @time df2 = CSV.read(GDS(open(iris_file)), types=Dict(6=>String));\n  6.818591 seconds (4.07 M allocations: 200.507 MiB, 3.18% gc time)\n\njulia> @time df3 = textparse2DF(csvread(GDS(open(iris_file)), pooledstrings=false));\n  2.667487 seconds (1.78 M allocations: 96.523 MiB, 2.51% gc time)\n\njulia> @test df1 == df2 == df3\nTest Passed\n"
},

{
    "location": "man/benchmarks.html#[0s-1s](https://github.com/cjprybol/uCSV.jl/blob/master/test/data/0s-1s.csv.gz)-1",
    "page": "Benchmarks",
    "title": "0s-1s",
    "category": "section",
    "text": "ints_file = joinpath(Pkg.dir(\"uCSV\"), \"test\", \"data\", \"0s-1s.csv.gz\");\n@time df1 = DataFrame(uCSV.read(GDS(open(ints_file)), header=1));\n@time df2 = CSV.read(GDS(open(ints_file)));\n@time df3 = textparse2DF(csvread(GDS(open(ints_file))));\n@test df1 == df2 == df3julia> ints_file = joinpath(Pkg.dir(\"uCSV\"), \"test\", \"data\", \"0s-1s.csv.gz\");\n\njulia> @time df1 = DataFrame(uCSV.read(GDS(open(ints_file)), header=1));\n  6.379254 seconds (33.76 M allocations: 1.425 GiB, 7.30% gc time)\n\njulia> @time df2 = CSV.read(GDS(open(ints_file)));\n 10.377598 seconds (10.11 M allocations: 358.625 MiB, 2.43% gc time)\n\njulia> @time df3 = textparse2DF(csvread(GDS(open(ints_file))));\n  2.525099 seconds (1.83 M allocations: 189.862 MiB, 3.67% gc time)\n\njulia> @test df1 == df2 == df3\nTest Passed\n"
},

{
    "location": "man/benchmarks.html#[Flights](https://github.com/cjprybol/uCSV.jl/blob/master/test/data/2010_BSA_Carrier_PUF.csv.gz)-1",
    "page": "Benchmarks",
    "title": "Flights",
    "category": "section",
    "text": "carrier_file = joinpath(Pkg.dir(\"uCSV\"), \"test\", \"data\", \"2010_BSA_Carrier_PUF.csv.gz\");\n@time df1 = DataFrame(uCSV.read(GDS(open(carrier_file)), header=1, typedetectrows=2, encodings=Dict{String,Any}(\"\" => null), types=Dict(3 =>  Union{String, Null})));\n@time df2 = CSV.read(GDS(open(carrier_file)), types=Dict(3 => Union{String, Null}, 4 => String, 5 => String, 8 => String));\n# does not parse correctly\n@time df3 = textparse2DF(csvread(GDS(open(carrier_file)), pooledstrings=false, type_detect_rows=228990, nastrings=[\"\"]));\n@test_broken df1 == df2 == df3\n@test df1 == df2julia> carrier_file = joinpath(Pkg.dir(\"uCSV\"), \"test\", \"data\", \"2010_BSA_Carrier_PUF.csv.gz\");\n\njulia> @time df1 = DataFrame(uCSV.read(GDS(open(carrier_file)), header=1, typedetectrows=2, encodings=Dict{String,Any}(\"\" => null), types=Dict(3 =>  Union{String, Null})));\n 51.146730 seconds (229.57 M allocations: 9.036 GiB, 49.18% gc time)\n\njulia> @time df2 = CSV.read(GDS(open(carrier_file)), types=Dict(3 => Union{String, Null}, 4 => String, 5 => String, 8 => String));\n 13.113943 seconds (76.93 M allocations: 1.803 GiB, 32.44% gc time)\n\njulia> # does not parse correctly\n       @time df3 = textparse2DF(csvread(GDS(open(carrier_file)), pooledstrings=false, type_detect_rows=228990, nastrings=[\"\"]));\n 27.005981 seconds (49.83 M allocations: 2.734 GiB, 57.52% gc time)\n\njulia> @test_broken df1 == df2 == df3\nTest Broken\nExpression: df1 == df2 == df3\n\n\njulia> @test df1 == df2\nTest Passed"
},

{
    "location": "man/benchmarks.html#[Human-Genome-Feature-Format](https://github.com/cjprybol/uCSV.jl/blob/master/test/data/Homo_sapiens.GRCh38.90.gff3.gz)-1",
    "page": "Benchmarks",
    "title": "Human Genome Feature Format",
    "category": "section",
    "text": "genome_file = joinpath(Pkg.dir(\"uCSV\"), \"test\", \"data\", \"Homo_sapiens.GRCh38.90.gff3.gz\");\n@time df1 = DataFrame(uCSV.read(GDS(open(genome_file)), delim='\\t', comment='#', types=Dict(1 => String)));\n@time df2 = CSV.read(IOBuffer(join(filter(line -> !startswith(line, '#'), readlines(GDS(open(genome_file)))), '\\n')), delim='\\t', types=Dict(1 => String, 2 => String, 3 => String, 6 => String, 7 => String, 8 => String, 9 => String), header=[:x1, :x2, :x3, :x4, :x5, :x6, :x7, :x8, :x9]);\n@test_broken df3 = textparse2DF(csvread(IOBuffer(join(filter(line -> !startswith(line, '#'), readlines(GDS(open(genome_file)))), '\\n')), '\\t', pooledstrings=false));\n@test df1 == df2julia> genome_file = joinpath(Pkg.dir(\"uCSV\"), \"test\", \"data\", \"Homo_sapiens.GRCh38.90.gff3.gz\");\n\njulia> @time df1 = DataFrame(uCSV.read(GDS(open(genome_file)), delim='\\t', comment='#', types=Dict(1 => String)));\n 48.559884 seconds (197.88 M allocations: 8.669 GiB, 50.47% gc time)\n\njulia> @time df2 = CSV.read(IOBuffer(join(filter(line -> !startswith(line, '#'), readlines(GDS(open(genome_file)))), '\\n')), delim='\\t', types=Dict(1 => String, 2 => String, 3 => String, 6 => String, 7 => String, 8 => String, 9 => String), header=[:x1, :x2, :x3, :x4, :x5, :x6, :x7, :x8, :x9]);\n 22.231910 seconds (85.95 M allocations: 3.893 GiB, 44.77% gc time)\n\njulia> @test_broken df3 = textparse2DF(csvread(IOBuffer(join(filter(line -> !startswith(line, '#'), readlines(GDS(open(genome_file)))), '\\n')), '\\t', pooledstrings=false));\n\njulia> @test df1 == df2\nTest Passed\n"
},

{
    "location": "man/benchmarks.html#[Country-Indicators](https://github.com/cjprybol/uCSV.jl/blob/master/test/data/indicators.csv.gz)-1",
    "page": "Benchmarks",
    "title": "Country Indicators",
    "category": "section",
    "text": "indicators_file = joinpath(Pkg.dir(\"uCSV\"), \"test\", \"data\", \"indicators.csv.gz\");\n@time df1 = DataFrame(uCSV.read(GDS(open(indicators_file)), quotes='\"'));\n@time df2 = CSV.read(GDS(open(indicators_file)), header=[:x1, :x2, :x3, :x4, :x5, :x6], types=Dict(1 => String, 2 => String, 3 => String, 4 => String));\n@time df3 = textparse2DF(csvread(GDS(open(indicators_file)), pooledstrings=false, header_exists=false, colnames=[:x1, :x2, :x3, :x4, :x5, :x6]));\n@test df1 == df2 == df3julia> indicators_file = joinpath(Pkg.dir(\"uCSV\"), \"test\", \"data\", \"indicators.csv.gz\");\n\njulia> @time df1 = DataFrame(uCSV.read(GDS(open(indicators_file)), quotes='\"'));\n 77.891937 seconds (229.19 M allocations: 11.248 GiB, 41.44% gc time)\n\njulia> @time df2 = CSV.read(GDS(open(indicators_file)), header=[:x1, :x2, :x3, :x4, :x5, :x6], types=Dict(1 => String, 2 => String, 3 => String, 4 => String));\n 17.559485 seconds (55.74 M allocations: 1.922 GiB, 26.93% gc time)\n\njulia> @time df3 = textparse2DF(csvread(GDS(open(indicators_file)), pooledstrings=false, header_exists=false, colnames=[:x1, :x2, :x3, :x4, :x5, :x6]));\n 13.672462 seconds (13.38 M allocations: 1.384 GiB, 26.24% gc time)\n\njulia> eltype.(df1.columns) == eltype.(df2.columns) == eltype.(df3.columns)\ntrue\n"
},

{
    "location": "man/benchmarks.html#[Yellow-Taxi](https://s3.amazonaws.com/nyc-tlc/tripdata/yellow_tripdata_2015-01.csv)-1",
    "page": "Benchmarks",
    "title": "Yellow Taxi",
    "category": "section",
    "text": "taxi_file = joinpath(homedir(), \"Downloads\", \"yellow_tripdata_2015-01.csv\");\n@time df1 = DataFrame(uCSV.read(taxi_file, header=1, typedetectrows=6, types=Dict(18=>Union{Float64, Null}), encodings=Dict{String,Any}(\"\" => null)));\n@time df2 = CSV.read(taxi_file, types=eltype.(df1.columns));\n@time df3 = textparse2DF(csvread(taxi_file));julia> @time df1 = DataFrame(uCSV.read(taxi_file, header=1, typedetectrows=6, types=Dict(18=>Union{Float64, Null}), encodings=Dict{String,Any}(\"\" => null)));\n455.962678 seconds (1.79 G allocations: 70.441 GiB, 49.24% gc time)\n\njulia> @time df2 = CSV.read(taxi_file, types=eltype.(df1.columns));\n112.266853 seconds (692.94 M allocations: 13.221 GiB, 72.15% gc time)\n\njulia> @time df3 = textparse2DF(csvread(taxi_file));\n 67.999334 seconds (28.69 M allocations: 3.790 GiB, 56.92% gc time)\n"
},

{
    "location": "man/benchmarks.html#Write-1",
    "page": "Benchmarks",
    "title": "Write",
    "category": "section",
    "text": "If you're interested in seeing this, let me know by filing an issue or by running some comparisons yourself and opening a PR with the results!"
},

]}
