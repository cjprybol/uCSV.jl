function parsesource(source, delim, quotes, escape, comment, encodings, header, skiprows,
                     types, isnullable, coltypes, colparsers, typeparsers, typedetectrows,
                     skipmalformed, trimwhitespace)

    currentline = 0
    colnames = Vector{String}()
    #######################################################################################
    # HEADER
    #######################################################################################
    # user provided
    if isa(header, Vector{String})
        colnames = header
    # parse header from row `header` as specified by the user
    elseif header > 0
        line = _readline(source, comment)
        currentline += 1
        while currentline < header
            line = _readline(source, comment)
            currentline += 1
        end
        if currentline == header
            fields, quoted, badbreak = parsefields(line, delim, quotes, escape, trimwhitespace)
            # e is true if `getfields` determined that we split a line prematurely on a quoted newline
            while badbreak
                if eof(source)
                    throwbadbreak("header", line, quotes)
                else
                    line *= "\n" * readline(source)
                    fields, quoted, badbreak = parsefields(line, delim, quotes, escape, trimwhitespace)
                end
            end
            colnames = convert(Vector{String}, fields)
        end
    end

    #######################################################################################
    # DETERMINE COLUMN TYPES AND PARSING FUNCTIONS FOR EACH COLUMN
    #######################################################################################
    numcols = 0
    rawstrings = Vector{Vector{SubString{String}}}()
    isquoted = Vector{Bool}(numcols)
    currentline = 0
    # lines parsed for type detection
    linesparsed = 0
    while !eof(source) && linesparsed < typedetectrows
        line = _readline(source, comment)
        currentline += 1
        if in(currentline, skiprows)
            continue
        end
        linesparsed += 1
        fields, quoted, badbreak = parsefields(line, delim, quotes, escape, trimwhitespace)
        eof(source) && length(fields) == 1 && isempty(fields[1]) && return Any[], colnames
        while badbreak
            if eof(source)
                throwbadbreak("line $currentline", line, quotes)
            else
                line *= "\n" * readline(source)
                fields, quoted, badbreak = parsefields(line, delim, quotes, escape, trimwhitespace)
            end
        end
        if linesparsed == 1
            numcols = length(fields)
            for i in 1:numcols
                push!(rawstrings, Vector{SubString{String}}())
            end
            isquoted = falses(numcols)
        elseif length(fields) != numcols
            handlemalformed(numcols, length(fields), currentline, skipmalformed, line)
            linesparsed -= 1
            continue
        end
        for (i, (f, q)) in enumerate(zip(fields, quoted))
            push!(rawstrings[i], f)
            isquoted[i] |= q
        end
    end

    if currentline == 0 || eof(source) && isempty(rawstrings)
        return Any[], colnames
    end

    if !isempty(colnames) && length(colnames) != numcols
        throwcolumnnumbermismatch(header, colnames, numcols)
    end

    # convert all of the available parsing requests to dictionaries index by column-index
    index2type = getintdict(types, numcols, colnames)
    for (i, iq) in enumerate(isquoted)
        if !haskey(index2type, i) && iq
            index2type[i] = String
        end
    end
    index2nullable = getintdict(isnullable, numcols, colnames)
    index2coltype = getintdict(coltypes, numcols, colnames)
    index2parser::Dict{Int, Function} = getintdict(colparsers, numcols, colnames)
    type2parser::Dict{DataType, Function} = Dict(Int64 => x -> parse(Int64, x),
                                                 Int32 => x -> parse(Int32, x),
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

    vals = Array{Any, 2}(linesparsed, numcols)

    # convert parsed fields from raw strings to correct types based on user-requests and defaults
    for col in 1:numcols
        for row in 1:linesparsed
            if haskey(encodings, rawstrings[col][row])
                vals[row, col] = encodings[rawstrings[col][row]]
            elseif haskey(index2parser, col)
                vals[row, col] = index2parser[col](rawstrings[col][row])
            elseif haskey(index2type, col)
                vals[row, col] = type2parser[Nulls.T(index2type[col])](rawstrings[col][row])
            else
                tryint = tryparse(Int, rawstrings[col][row])
                if !isnull(tryint)
                    vals[row, col] = get(tryint)
                    continue
                end
                tryfloat = tryparse(Float64, rawstrings[col][row])
                if !isnull(tryfloat)
                    vals[row, col] = get(tryfloat)
                    continue
                end
                vals[row, col] = String(rawstrings[col][row])
            end
        end
    end

    # determine the type of each column of data based on parsed data and user-specified types
    valtypes = typeof.(vals)
    eltypes = Vector{Type}(size(vals, 2))
    for col in 1:length(eltypes)
        if haskey(index2type, col)
            eltypes[col] = index2type[col]
        else
            if any(x -> x == String, valtypes[:, col])
                eltypes[col] = String
                for (row, v) in enumerate(vals[:, col])
                    vals[row, col] = isnull(vals[row, col]) ? vals[row, col] : string(vals[row, col])
                end
            else
                eltypes[col] = promote_type([T for T in valtypes[:, col] if T != Null]...)
            end
        end
        if (haskey(index2nullable, col) && index2nullable[col]) || any(x -> x == Null, valtypes[:, col])
            eltypes[col] = Union{eltypes[col], Null}
        end
    end
    if any(values(index2nullable)) && !any(isnull, values(encodings))
        throw(ArgumentError("""
                            Nullable columns have been requested but the user has not specified any strings to interpret as null values via the `encodings` argument.
                            """))
    end

    # create typed data columns and fill the columns with data parsed while detecting types
    n = size(vals, 1)
    data = [haskey(index2coltype, i) ? index2coltype[i]{T}(n) : Vector{T}(n) for (i, T) in enumerate(eltypes)]
    for (col, T) in enumerate(eltypes)
        if T == String
            for (row, val) in enumerate(vals[:, col])
                data[col][row] = string(val)
            end
        else
            data[col] .= vals[:, col]
        end
    end

    # fill in remaining column parsing rules with type rules
    for (i, T) in enumerate(eltypes)
        if !haskey(index2parser, i)
            index2parser[i] = x -> type2parser[Nulls.T(T)](x)
        end
    end
    #######################################################################################
    # PARSE REMAINDER OF FILE WITH PARSING FUNCTIONS FOR EACH COLUMN
    #######################################################################################
    while !eof(source)
        line = _readline(source, comment)
        currentline += 1
        if in(currentline, skiprows)
            continue
        end
        fields, quoted, badbreak = parsefields(line, delim, quotes, escape, trimwhitespace)
        while badbreak
            if length(fields) > length(data) || eof(source)
                throwbadbreak("line $currentline", line, quotes)
            else
                line *= "\n" * readline(source)
                fields, quoted, badbreak = parsefields(line, delim, quotes, escape, trimwhitespace)
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
                throwbadconversion(f, currentline, i, encodings, data)
            end
        end
    end
    return convert(Vector{Any}, data), colnames
end
