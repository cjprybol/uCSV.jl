"""
    read(fullpath;
         delim=',',
         quotes=null,
         escape=null,
         comment=null,
         encodings=Dict{String, Any}(),
         header=0,
         skiprows=Vector{Int}(),
         types=Dict{Int,DataType}(),
         isnullable=Dict{Int,Bool}(),
         coltypes=Vector,
         colparsers=Dict{Int,Function}(),
         typeparsers=Dict{DataType, Function}(),
         typedetectrows=1,
         skipmalformed=false,
         trimwhitespace=false)

Take an input file or IO source and user-defined parsing rules and return:
1. a `Vector{Any}` containing the parsed columns
2. a `Vector{String}` containing the header (column names)

# Arguments
- `fullpath::Union{String,IO}`
    - the path to a local file, or an open IO source from which to read data
- `delim::Union{Char,String}`
    - whatever the dataset is being split on
    - default: `delim=','`
        - for CSV files
    - frequently used:
        - `delim='\\t'`
        - `delim=' '`
        - `delim='|'`
    - may contain any valid UTF-8 character or string
- `quotes::Union{Char,Null}`
    - the character used for quoting fields in the dataset
    - default: `quotes=null`
        - by default, the parser does not check for quotes.
    - frequently used:
        - `quotes='"'`
- `escape::Union{Char,Null}`
    - the character used for escaping other special & reserved parsing characters
    - default: `escape=null`
        - by default, the parser does not check for escapes.
    - frequently used:
        - `escape='"'`
            - double-quotes within quotes, e.g. `"firstname ""nickname"" lastname"`
        - `escape='\\\\'`
            - note that the first backslash is just to escape the second backslash
            - e.g. `"firstname \\\"nickname\\\" lastname"`
- `comment::Union{Char,String,Null}`
    - the character or string used for comment lines in your dataset
        - note that skipped comment lines do not contribute to the line count for the header
          (if the user requests parsing a header on a specific row) or for skiprows
    - default: `comment=null`
        - by default, the parser does not check for comments
    - frequently used:
        - `comment='#'`
        - `comment='!'`
        - `comment="#!"`
- `encodings::Dict{String,Any}`
    - A dictionary mapping parsed strings to desired julia values
        - if your dataset has booleans that are not represented as `"true"` and `"false"` or missing values that you'd like to read as `null`s, you'll need to use this!
    - default: `encodings=Dict{String, Any}()`
        - by default, the parser does not check for any reserved fields
    - frequently used:
        - `encodings=Dict{String, Any}("" => null)`
        - `encodings=Dict{String, Any}("NA" => null)`
        - `encodings=Dict{String, Any}("N/A" => null)`
        - `encodings=Dict{String, Any}("NULL" => null)`
        - `encodings=Dict{String, Any}("TRUE" => true, "FALSE" => false)`
        - `encodings=Dict{String, Any}("True" => true, "False" => false)`
        - `encodings=Dict{String, Any}("T" => true, "F" => false)`
        - `encodings=Dict{String, Any}("yes" => true, "no" => false)`
        - ... your encodings here ...
            - can include any number of `String` => value mappings
            - note that if the user requests `quotes`, `escapes`, or `trimwhitespace`, these requests
              will be applied (removed) the raw string *BEFORE* checking whether the field matches
              any strings in in the `encodings` argument.
- `header::Union{Integer,Vector{String}}`
    - The line in the dataset on which to parse the header
        - note that commented lines and blank lines do not contribute to this value
          e.g. if the first 3 lines of your dataset are comments, you'll still need to
          set `header=1` to interpret the first line of parsed data as the header.
    - default: `header=0`
        - no header is checked for by default
    - frequently used:
        - `header=1`
- `skiprows::AbstractVector{Int}`
    - A `Vector` or `Range` (e.g. `1:10`) or rows to skip
        - note that this is 1-based in reference to the first row *AFTER* the header.
          If `header=0` or is provided by the user, this will be the first non-empty
          line in the dataset. Otherwise `skiprows=1:1` will skip the `header+1`-nth line
          in the file.
    - default: `skiprows=Vector{Int}()`
        - no rows are skipped
    - frequently used:
        - `skiprows=6:typemax(Int)`
            - read only the first 5 lines of the dataset
- `types::Union{Type, Dict{Int, Type}, Dict{String, Type}, Vector{Type}}`
    - declare the types of the columns
        - scalar, e.g. `types=Bool`
            - scalars will be broadcast to apply to every column of the dataset
        - vector, e.g. `types=[Bool, Int, Float64, String, Symbol, Date, DateTime]`
            - the vector length must match the number of parsed columns
        - dictionary, e.g. `types=("column1" => Bool)` or `types=(1 => Union{Int, Null})`
            - users can refer to the columns by name (only if a header is provided or
              parsed!) or by index
    - default:
        - `types=Dict{Int,DataType}()`
            - column-types will be interpreted from the dataset
    - built-in support for parsing the following:
        - `Int`
        - `Float64`
        - `String`
        - `Symbol`
        - `Date` -- only the default date format will work
        - `DateTime` -- only the default datetime format will work
        - for other types or unsupported formats, see `colparsers` and `typeparsers`
- `isnullable::Union{Bool, Dict{Int, Bool}, Dict{String, Bool}, Vector{Bool}}`
    - declare whether columns should have element-type `Union{T, Null} where T`
        - scalar, e.g. `isnullable=true`
            - scalars will be broadcast to apply to every column of the dataset
        - vector, e.g. `isnullable=[true, false, true, true]`
            - the vector length must match the number of parsed columns
        - dictionary, e.g. `isnullable=("column1" => true)` or `isnullable=(17 => true)`
            - users can refer to the columns by name (only if a header is provided or
              parsed!) or by index
    - default: `isnullable=Dict{Int,Bool}()`
        - column-types are only nullable if null values are detected in rows
          `1:typedetectrows`.
- `coltypes::Union{AbstractVector, Dict{Int, AbstractVector}, Dict{String, AbstractVector}, Vector{AbstractVector}}`
    - declare the type of vector that should be used for columns
    - should work for any AbstractVector that allows `push!`ing values
        - scalar, e.g. `coltypes=CategoricalVector`
            - scalars will be broadcast to apply to every column of the dataset
        - vector, e.g. `coltypes=[CategoricalVector, Vector, CategoricalVector]`
            - the vector length must match the number of parsed columns
        - dictionary, e.g. `coltypes=("column1" => CategoricalVector)` or `coltypes=(17 => CategoricalVector)`
            - users can refer to the columns by name (only if a header is provided or
              parsed!) or by index
    - default: `coltypes=Vector`
        - all columns are returned as standard julia `Vector`s
- `colparsers::Union{Function, Dict{Int, Function}, Dict{String, Function}, Vector{Function}}`
    - provide custom functions for converting parsed strings to values by column
        - scalar, e.g. `colparsers=(x -> parse(Float64, replace(x, ',', '.')))`
            - scalars will be broadcast to apply to every column of the dataset
        - vector, e.g. `colparsers=[x -> mydateparser(x), x -> mytimeparser(x)]`
            - the vector length must match the number of parsed columns
        - dictionary, e.g. `colparsers=("column1" => x -> mydateparser(x))`
            - users can refer to the columns by name (only if a header is provided or
              parsed!) or by index
    - default: `colparsers=Dict{Int,Function}()`
        - column parsers are determined based on user-specified types and those
          detected from the data
- `typeparsers::Dict{Type, Function}`
    - provide custom functions for converting parsed strings to values by column type
        - note user must specify column types for this to have the intended effect,
          as the parser uses the default type-parsers for detecting column type.
    - default: `colparsers=Dict{DataType, Function}()`
        - column parsers are determined based on user-specified types and those
          detected from the data
    - frequently used:
        - `typeparsers=Dict(Int => x -> parse(Float64, replace(x, ',', '.')))` # euro-style floats!
            - in combination with `types` to specify which columns to apply the parsers to.
- `typedetectrows::Int=1`
    - specify how many rows of data to read before interpretting the values that each
      column should take on
        - commented, skipped, and empty lines are not counted when determining
          which rows are used for type detection, e.g. setting `typedetectrows=10` and
          `skiprows=1:5` means type detection will occur on rows `6:15`
- `skipmalformed::Bool=false`
    - specify whether the parser should skip a line or fail with an error if a line is
      parsed but does not contain the expected number of rows
    - default: `skipmalformed=false`
        - malformed lines result in an error
- `trimwhitespace::Bool=false`
    - specify whether should extra whitespace be removed from the beginning and ends of fields.
    - leading and trailing whitespace *OUTSIDE* of quoted fields is trimmed by default.
    - `trimwhitespace=true` will also trim leading and trailing whitespace *WITHIN* quotes
"""

function read(fullpath::Union{String,IO};
              delim::Union{Char,String}=',',
              quotes::Union{Char,Null}=null,
              escape::Union{Char,Null}=null,
              comment::Union{Char,String,Null}=null,
              encodings::Dict{String,Any}=Dict{String, Any}(),
              header::Union{Integer,Vector{String}}=0,
              skiprows::AbstractVector{Int}=Vector{Int}(),
              types::Union{T1,COLMAP{T1},Vector{T1}} where {T1<:Type}=Dict{Int,DataType}(),
              isnullable::Union{Bool,COLMAP{Bool},Vector{Bool}}=Dict{Int,Bool}(),
              coltypes::Union{Type{<:AbstractVector},COLMAP{UnionAll},Vector{UnionAll}}=Vector,
              colparsers::Union{F1, COLMAP{F1}, Vector{F1}} where F1=Dict{Int,Function}(),
              typeparsers::Dict{T2, F2} where {T2<:Type, F2}=Dict{DataType, Function}(),
              typedetectrows::Int=1,
              skipmalformed::Bool=false,
              trimwhitespace::Bool=false)

        source = isa(fullpath, IO) ? fullpath : open(fullpath)
        reserved = filter(x -> !isnull(x), [delim, quotes, escape, comment])
        if !isnull(quotes) && quotes == escape
            @assert length(unique(string.(reserved))) == length(reserved) - 1
        else
            @assert length(unique(string.(reserved))) == length(reserved)
        end
        if isa(coltypes, Vector{UnionAll})
            @assert all(x -> x <: AbstractVector, coltypes)
        elseif isa(coltypes, COLMAP{UnionAll})
            @assert all(x -> x <: AbstractVector, collect(values(coltypes)))
        end
        @assert typedetectrows >= 1
        if typedetectrows > 100
            warn("""
                 Large values for `typedetectrows` will reduce performance. Consider using a lower value and specifying column-types via the `types` and `isnullable` arguments instead.
                 """)
        end
        data, colnames = parsesource(source, delim, quotes, escape, comment, encodings,
                                     header, skiprows, types, isnullable, coltypes,
                                     colparsers, typeparsers, typedetectrows, skipmalformed,
                                     trimwhitespace)
        return data, colnames
end
