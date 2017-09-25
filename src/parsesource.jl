function parsesource(source, delim, quotes, escape, comment, encodings, header, skiprows,
                     types, isnullable, iscategorical, colparsers, typeparsers,
                     typedetectrows, skipmalformed, trimwhitespace)

    currentline = 0
    colnames = Vector{String}()
    # strip excessive newlines at end of file
    rawstring = rstrip(Base.read(source, String))
    # stop here if an empty file
    isempty(rawstring) && return Any[], Vector{String}()
    # handle unicode "beginning of message" start to the file
    if rawstring[1] == '\ufeff'
        rawstring = string(rawstring[chr2ind(rawstring,2):end])
    end
    # call newlines based on linux, mac, or windows line endings
    splitsource = split(rawstring, r"\r\n?|\n")
    #######################################################################################
    # HEADER
    #######################################################################################
    # user provided
    if isa(header, Vector{String})
        colnames = header
    # parse header from row `header` as specified by the user
    elseif header > 0
        line = _readline(splitsource, comment)
        currentline += 1
        while currentline < header
            line = _readline(splitsource, comment)
            currentline += 1
        end
        if currentline == header
            fields, isquoted, e = getfields(split(line, delim), delim, quotes, escape, trimwhitespace)
            # e is true if `getfields` determined that we split a line prematurely on a quoted newline
            while e
                if isempty(splitsource)
                    throw(ErrorException("unexpected EOF"))
                else
                    line *= "\n" * shift!(splitsource)
                    fields, isquoted, e = getfields(split(line, delim), delim, quotes, escape, trimwhitespace)
                end
            end
            colnames = convert(Vector{String}, fields)
        end
    end

    #######################################################################################
    # DETERMINE COLUMN TYPES AND PARSING FUNCTIONS FOR EACH COLUMN
    #######################################################################################
    numcols = 0
    rawstrings = Array{String, 2}(typedetectrows, numcols)
    isquoted = Vector{Bool}(numcols)
    currentline = 0
    linesparsedfortypedetection = 0
    while !isempty(splitsource) && linesparsedfortypedetection < typedetectrows
        line = _readline(splitsource, comment)
        currentline += 1
        if in(currentline, skiprows)
            continue
        end
        linesparsedfortypedetection += 1
        fields, quoted, e = getfields(split(line, delim), delim, quotes, escape, trimwhitespace)
        while e
            if isempty(splitsource)
                throw(ErrorException("unexpected EOF"))
            else
                line *= "\n" *  shift!(splitsource)
                fields, quoted, e = getfields(split(line, delim), delim, quotes, escape, trimwhitespace)
            end
        end
        if linesparsedfortypedetection == 1
            numcols = length(fields)
            rawstrings = Array{String, 2}(typedetectrows, numcols)
            isquoted = falses(numcols)
        elseif length(fields) != numcols
            handlemalformed(numcols, length(fields), currentline, skipmalformed, line)
            linesparsedfortypedetection -= 1
            continue
        end
        rawstrings[linesparsedfortypedetection, :] .= fields
        isquoted .|= quoted
    end

    if currentline == 0
        return Any[], colnames
    elseif linesparsedfortypedetection < typedetectrows
        rawstrings = rawstrings[1:linesparsedfortypedetection, :]
    end

    numcols = size(rawstrings, 2)
    if !isempty(colnames) && length(colnames) != numcols
        if isa(header, Int)
            throw(ErrorException("""
                                 parsed header $colnames has $(length(colnames)) columns, but $numcols were detected the in dataset.
                                 """))
        else
            throw(ArgumentError("""
                                user-provided header $header has $(length(header)) columns, but $numcols were detected the in dataset.
                                """))
        end
    end

    # convert all of the available parsing requests to dictionaries index by column-index
    index2type::Dict{Int, Type} = getintdict(types, numcols, colnames)
    for (i, iq) in enumerate(isquoted)
        if !haskey(index2type, i) && iq
            index2type[i] = String
        end
    end
    index2nullable::Dict{Int, Bool} = getintdict(isnullable, numcols, colnames)
    index2categorical::Dict{Int, Bool} = getintdict(iscategorical, numcols, colnames)
    index2parser::Dict{Int, Function} = getintdict(colparsers, numcols, colnames)
    type2parser::Dict{DataType, Function} = Dict(Int => x -> parse(Int, x),
                                                 Float64 => x -> parse(Float64, x),
                                                 String => x -> string(x),
                                                 Date => x -> parse(Date, x),
                                                 DateTime => x -> parse(DateTime, x),
                                                 Symbol => x -> Symbol(string(x)),
                                                 Bool => x -> parse(Bool, x))

    for (T, Func) in typeparsers
        type2parser[T] = Func
    end
    # anonymous functions don't play well with the type-system and would refuse anonymous
    # functions as `Function`s, so we have to give a lax function restriction and enforce
    # it manually here
    @assert all(v -> isa(v, Function), values(type2parser))
    @assert all(v -> isa(v, Function), values(index2parser))

    vals = Array{Any, 2}(size(rawstrings)...)

    # convert parsed fields from raw strings to correct types based on user-requests and defaults
    for col in 1:size(rawstrings, 2)
        for row in 1:size(rawstrings, 1)
            if haskey(encodings, rawstrings[row, col])
                vals[row, col] = encodings[rawstrings[row, col]]
            elseif haskey(index2parser, col)
                vals[row, col] = index2parser[col](rawstrings[row, col])
            elseif haskey(index2type, col)
                vals[row, col] = type2parser[Nulls.T(index2type[col])](rawstrings[row, col])
            else
                tryint = tryparse(Int, rawstrings[row, col])
                if !isnull(tryint)
                    vals[row, col] = get(tryint)
                    continue
                end
                tryfloat = tryparse(Float64, rawstrings[row, col])
                if !isnull(tryfloat)
                    vals[row, col] = get(tryfloat)
                    continue
                end
                vals[row, col] = string(rawstrings[row, col])
            end
        end
    end

    # determine the type of each column of data based on parsed data and user-specified types
    valtypes = typeof.(vals)
    coltypes = Vector{Type}(size(vals, 2))
    for col in 1:length(coltypes)
        if haskey(index2type, col)
            coltypes[col] = index2type[col]
        else
            if any(x -> x == String, valtypes[:, col])
                coltypes[col] = String
                for (row, v) in enumerate(vals[:, col])
                    vals[row, col] = isnull(vals[row, col]) ? vals[row, col] : string(vals[row, col])
                end
            else
                coltypes[col] = promote_type([T for T in valtypes[:, col] if T != Null]...)
            end
        end
        if (haskey(index2nullable, col) && index2nullable[col]) ||
            any(x -> x == Null, valtypes[:, col])
            coltypes[col] = Union{coltypes[col], Null}
        end
    end
    if any(values(index2nullable)) && !any(isnull, values(encodings))
        throw(ArgumentError("""
                            Nullable columns have been requested but the user has not specified any strings to interpret as null values via the `encodings` argument.
                            """))
    end

    # create typed data columns and fill the columns with data parsed while detecting types
    n = size(vals, 1)
    data = [Vector{T}(n) for T in coltypes]
    for (col, T) in enumerate(coltypes)
        if T == String
            for (row, val) in enumerate(vals[:, col])
                data[col][row] = string(val)
            end
        else
            data[col] .= vals[:, col]
        end
    end

    # fill in remaining column parsing rules with type rules
    for (i, T) in enumerate(coltypes)
        if !haskey(index2parser, i)
            index2parser[i] = x -> type2parser[Nulls.T(T)](x)
        end
    end
    #######################################################################################
    # PARSE REMAINDER OF FILE WITH PARSING FUNCTIONS FOR EACH COLUMN
    #######################################################################################
    while !isempty(splitsource)
        line = _readline(splitsource, comment)
        currentline += 1
        if in(currentline, skiprows)
            continue
        end
        fields, quoted, e = getfields(split(line, delim), delim, quotes, escape, trimwhitespace)
        while e
            if isempty(splitsource)
                throw(ErrorException("unexpected EOF"))
            else
                line *= "\n" * shift!(splitsource)
                fields, quoted, e = getfields(split(line, delim), delim, quotes, escape, trimwhitespace)
            end
        end
        if length(fields) != numcols
            if !isnull(comment) && startswith(fields[1], comment)
                continue
            elseif length(fields) == 1 && isempty(strip(fields[1]))
                continue
            else
                handlemalformed(numcols, length(fields), currentline, skipmalformed, line)
                continue
            end
        end
        for (i, f) in enumerate(fields)
            try
                if haskey(encodings, f)
                    push!(data[i], encodings[f])
                else
                    push!(data[i], index2parser[i](f))
                end
            catch
                if haskey(encodings, f)
                    throw(ErrorException("""
                                         Error parsing field "$f" in row $currentline, column $i.
                                         Unable to push value $(encodings[f]) to column of type $(eltype(data[i]))
                                         Possible fixes may include:
                                           1. set `typedetectrows` to a value >= $currentline
                                           2. manually specify the element-type of column $i via the `types` argument
                                           3. manually specify a parser for column $i via the `parsers` argument
                                           4. if the value is null, setting the `isnullable` argument
                                         """))
                else
                    throw(ErrorException("""
                                         Error parsing field "$f" in row $currentline, column $i.
                                         Unable to parse field "$f" as type $(eltype(data[i]))
                                         Possible fixes may include:
                                           1. set `typedetectrows` to a value >= $currentline
                                           2. manually specify the element-type of column $i via the `types` argument
                                           3. manually specify a parser for column $i via the `parsers` argument
                                           4. if the intended value is null or another special encoding, setting the `encodings` argument appropriately.
                                         """))
                end
            end
        end
    end
    data = convert(Vector{Any}, data)
    # apply CategoricalVector requests
    for (k,v) in index2categorical
        if v
            data[k] = CategoricalVector(data[k])
        end
    end
    return data, colnames
end
