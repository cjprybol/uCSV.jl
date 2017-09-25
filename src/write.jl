"""
    function write(fullpath;
                   header=null,
                   data=null,
                   delim=',',
                   quotes=null)

write a dataset to disk

# Arguments
- `fullpath::String`
    - the path on disk where you want to write the file. writting to streams is not
      currently supported, but if you're interested in this feature please file an issue
      or open a pull request!
- `header::Union{Vector{String}, Null}`
    - the column names for the data
        - default: `header=null`
            - no header is written to disk
- `data::Union{Vector{<:Any}, Null}`
    - the dataset to write to disk
        - default: `data=null`
            - no data is written to disk
- `delim::Union{Char, String}`
    - the delimiter to seperate fields by
        - default: `delim=','`
            - comma-seperated values
- `quotes::Union{Char, Null}`
    - the quoting character to use when writing fields
        - default: `quotes=null`
            - fields are not quoted by default, and fields are written using julia's
              default string-printing mechanisms
"""

function write(fullpath::String;
               header::Union{Vector{String}, Null}=null,
               data::Union{Vector{<:Any}, Null}=null,
               delim::Union{Char, String}=',',
               quotes::Union{Char, Null}=null)
    if isnull(header) && isnull(data)
        throw(ArgumentError("no header or data provided"))
    elseif !isnull(data)
        @assert length(unique(length.(data))) == 1
        if !isnull(header)
            @assert length(header) == length(data)
        end
    end
    f = open(fullpath, "w")
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
                for i in find(e -> e == String, eltypes)
                    rowvalues[i] = string(quotes, rowvalues[i], quotes)
                end
            end
            Base.write(f, join(rowvalues, delim) * "\n")
        end
    end
    close(f)
end
