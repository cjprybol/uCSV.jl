function getintdict(arg::Vector, numcols::Int, colnames::Vector{String})
    if length(arg) != numcols
        throw(ArgumentError("""
                            One of the following user-supplied arguments:
                              1. types
                              2. isnullable
                              3. iscategorical
                              4. colparsers
                            was provided as a vector and the length of this vector ($(length(arg))) != the number of detected columns ($numcols).
                            """))
    end
    return Dict(i => arg[i] for i in 1:length(arg))
end

function getintdict{T}(arg::Dict{String, T}, numcols::Int, colnames::Vector{String})
    if isempty(colnames)
        throw(ArgumentError("""
                            One of the following user-supplied arguments:
                              1. types
                              2. isnullable
                              3. iscategorical
                              4. colparsers
                            was provided as a Dict with String keys that cannot be mapped to column indices because column names have either not been provided or have not been parsed.
                            """))
    end
    if all(k -> in(k, colnames), keys(arg))
        return Dict(findfirst(colnames, k) => v for (k,v) in arg)
    else
        k = findfirst(filter(k -> in(k, colnames), keys(arg)))
        throw(ArgumentError("""
                            user-provided column name $k does not match any parsed or user-provided column names.
                            """))
    end
end

function getintdict{T}(arg::Dict{Int, T}, numcols::Int, colnames::Vector{String})
    return arg
end

function getintdict(arg, numcols::Int, colnames::Vector{String})
    return Dict(i => arg for i in 1:numcols)
end

function handlemalformed(expected::Int, observed::Int, currentline::Int, skipmalformed::Bool, line)
    if skipmalformed
        warn("""
             Parsed $observed fields on row $currentline. Expected $expected. Skipping...
             """)
    else
        throw(ErrorException("""
                         Parsed $observed fields on row $currentline. Expected $expected.
                         line:
                         $line
                         Possible fixes may include:
                           1. including $currentline in the `skiprows` argument
                           2. setting `skipmalformed=true`
                           3. if this line is a comment, set the `comment` argument
                           4. if fields are quoted, setting the `quotes` argument
                           5. if special characters are escaped, setting the `escape` argument
                           6. fixing the malformed line in the source or file before invoking `uCSV.read`
                         """))
    end
end

function _readline(splitsource::Vector{T}, comment::Null) where T
    line = shift!(splitsource)
    while isempty(line) && !isempty(splitsource)
        line = shift!(splitsource)
    end
    return line
end

function _readline(splitsource::Vector{T}, comment) where T
    line = shift!(splitsource)
    while (startswith(line, comment) || isempty(line)) && !isempty(splitsource)
        line = shift!(splitsource)
    end
    return line
end

function DataFrames.DataFrame(data, colnames::Vector{String})
    DataFrames.DataFrame(data, Symbol.(colnames))
end
