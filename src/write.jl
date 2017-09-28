"""
    function write(fullpath;
                   header=null,
                   data=null,
                   delim=',',
                   quotes=null,
                   quotetypes=AbstractString)

write a dataset to disk or IO

# Arguments
- `fullpath::Union{String, IO}`
    - the path on disk or IO where you want to write to.
- `header::Union{Vector{String}, Null}`
    - the column names for the data
        - default: `header=null`
            - no header is written
- `data::Union{Vector{<:Any}, Null}`
    - the dataset to write to disk or IO
        - default: `data=null`
            - no data is written
- `delim::Union{Char, String}`
    - the delimiter to seperate fields by
    - default: `delim=','`
        - for CSV files
    - frequently used:
        - `delim='\\t'`
        - `delim=' '`
        - `delim='|'`
- `quotes::Union{Char, Null}`
    - the quoting character to use when writing fields
        - default: `quotes=null`
            - fields are not quoted by default, and fields are written using julia's
              default string-printing mechanisms
- `quotetypes::Type`
    - when quoting fields, quote only columns where `coltype <: quotetypes`
        - default: `quotetypes=AbsractString`
            - only the header and fields where `coltype <: AbsractString` will be quoted
            - note that columns of `Union{<:coltype, Null}` will also be quoted, for cases where columns that you desire to be quoted also have missing values.
        - frequently used:
            - `quotetypes=Any`
                - quote every field in the dataset
"""

function write(fullpath::Union{String, IO};
               header::Union{Vector{String}, Null}=null,
               data::Union{Vector{<:Any}, Null}=null,
               delim::Union{Char, String}=',',
               quotes::Union{Char, Null}=null,
               quotetypes::Type=AbstractString)
    if isnull(header) && isnull(data)
        throw(ArgumentError("no header or data provided"))
    elseif !isnull(data)
        @assert length(unique(length.(data))) == 1
        if !isnull(header)
            @assert length(header) == length(data)
        end
    end
    if isa(fullpath, IO)
        if iswritable(fullpath)
            f = fullpath
        else
            throw(ArgumentError("""
                                Provided IO is not writable
                                """))
        end
    else
        f = open(fullpath, "w")
    end
    if !isnull(header)
        if !isnull(quotes)
            for i in eachindex(header)
                header[i] = string(quotes, header[i], quotes)
            end
        end
        Base.write(f, join(header, delim) * "\n")
    end
    if !isnull(data)
        numcols = length(data)
        eltypes = eltype.(data)
        for row in 1:length(data[1])
            rowvalues = [string(data[col][row]) for col in 1:numcols]
            if !isnull(quotes)
                for i in find(e -> e <: quotetypes || (e != Null && e <: Union{quotetypes, Null}), eltypes)
                    rowvalues[i] = string(quotes, rowvalues[i], quotes)
                end
            end
            Base.write(f, join(rowvalues, delim) * "\n")
        end
    end
    close(f)
end

"""
    function write(fullpath,
                   df;
                   delim=',',
                   quotes=null,
                   quotetypes=AbstractString)

write a DataFrame to disk or IO

# Arguments
- `fullpath::Union{String, IO}`
    - the path on disk or IO where you want to write to.
- `df::DataFrame`
    - the DataFrame to write to disk or IO
- `delim::Union{Char, String}`
    - the delimiter to seperate fields by
    - default: `delim=','`
        - for CSV files
    - frequently used:
        - `delim='\\t'`
        - `delim=' '`
        - `delim='|'`
- `quotes::Union{Char, Null}`
    - the quoting character to use when writing fields
        - default: `quotes=null`
            - fields are not quoted by default, and fields are written using julia's
              default string-printing mechanisms
- `quotetypes::Type`
    - when quoting fields, quote only columns where `coltype <: quotetypes`
        - default: `quotetypes=AbsractString`
            - only the header and fields where `coltype <: AbsractString` will be quoted
            - note that columns of `Union{<:coltype, Null}` will also be quoted, for cases where columns that you desire to be quoted also have missing values.
        - frequently used:
            - `quotetypes=Any`
                - quote every field in the dataset
"""

function write(fullpath, df::DataFrame; kwargs...)
    write(fullpath; header = string.(names(df)), data = df.columns, kwargs...)
end
