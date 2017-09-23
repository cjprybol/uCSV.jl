function parsesource(source, delim, quotes, escape, comment, encodings, header, skiprows,
                     types, isnullable, iscategorical, colparsers, typeparsers,
                     typedetectrows, skipmalformed, trimwhitespace)

    currentline = 0
    colnames = Vector{String}()
    if isa(header, Vector{String})
        colnames = header
    elseif header > 0
        line = _readline(source, comment)
        currentline += 1
        while currentline < header
            line = _readline(source, comment)
            currentline += 1
        end
        if currentline == header
            fields, isquoted, e = getfields(split(line, delim), delim, quotes, escape, trimwhitespace)
            while e
                if eof(source)
                    throw(ErrorException("unexpected EOF"))
                else
                    line *= "\n" * readline(source)
                    fields, isquoted, e = getfields(split(line, delim), delim, quotes, escape, trimwhitespace)
                end
            end
            colnames = convert(Vector{String}, fields)
        end
    end

    numcols = 0
    rawstrings = Array{String, 2}(typedetectrows, numcols)
    isquoted = Vector{Bool}(numcols)
    currentline = 0
    linesparsedfortypedetection = 0
    while !eof(source) && linesparsedfortypedetection < typedetectrows
        line = _readline(source, comment)
        currentline += 1
        if in(currentline, skiprows)
            continue
        end
        fields, quoted, e = getfields(split(line, delim), delim, quotes, escape, trimwhitespace)
        while e
            if eof(source)
                throw(ErrorException("unexpected EOF"))
            else
                line *= "\n" * readline(source)
                fields, quoted, e = getfields(split(line, delim), delim, quotes, escape, trimwhitespace)
            end
        end
        linesparsedfortypedetection += 1
        if linesparsedfortypedetection == 1
            numcols = length(fields)
            rawstrings = Array{String, 2}(typedetectrows, numcols)
            isquoted = falses(numcols)
        elseif length(fields) != numcols
            handlemalformed(numcols, length(fields), currentline, skipmalformed)
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
                                                 String => x -> string(x))

    for (k, v) in typeparsers
        type2parser[k] = v
    end
    for (k, T) in index2type
        if !haskey(type2parser, T)
            type2parser[T] = x -> parse(T, x)
        end
    end
    @assert all(v -> isa(v, Function), values(type2parser))
    @assert all(v -> isa(v, Function), values(index2parser))

    vals = Array{Any, 2}(size(rawstrings)...)

    for col in 1:size(rawstrings, 2)
        for row in 1:size(rawstrings, 1)
            if haskey(encodings, rawstrings[row, col])
                vals[row, col] = encodings[rawstrings[row, col]]
            elseif haskey(index2parser, col)
                vals[row, col] = index2parser[col](rawstrings[row, col])
            elseif haskey(index2type, col)
                vals[row, col] = type2parser[index2type[col]](rawstrings[row, col])
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

    valtypes = typeof.(vals)
    coltypes = Type[promote_type(valtypes[:, col]...) for col in 1:size(valtypes, 2)]
    if any(values(index2nullable)) && !any(isnull, values(encodings))
        throw(ArgumentError("""
                            Nullable columns have been requested but the user has not specified any
                            strings to interpret as null values via the `encodings` argument.
                            """))
    end
    for (k,v) in index2nullable
        if v
            coltypes[k] = Union{coltypes[k], Null}
        end
    end

    n = size(vals, 1)
    data = [Vector{T}(n) for T in coltypes]
    for col in 1:numcols
        data[col] .= vals[:, col]
    end

    for (i, T) in enumerate(coltypes)
        if !haskey(index2parser, i)
            index2parser[i] = x -> type2parser[Nulls.T(T)](x)
        end
    end

    while !eof(source)
        line = _readline(source, comment)
        currentline += 1
        if in(currentline, skiprows) || isempty(line)
            continue
        end
        fields, quoted, e = getfields(split(line, delim), delim, quotes, escape, trimwhitespace)
        while e
            if eof(source)
                throw(ErrorException("unexpected EOF"))
            else
                line *= "\n" * readline(source)
                fields, quoted, e = getfields(split(line, delim), delim, quotes, escape, trimwhitespace)
            end
        end
        if length(fields) != numcols
            handlemalformed(numcols, length(fields), currentline, skipmalformed)
            continue
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
                                         Error parsing field $f in row $currentline, column $i.
                                         Unable to push value $(encodings[f]) to column of type $(eltype(data[i]))
                                         Possible fixes include:
                                           1. set `typedetectrows` to a value >= $i
                                           2. manually specify the element-type of column $i via the `types` argument
                                           3. manually specify a parser for column $i via the `parsers` argument
                                         """))
                else
                    throw(ErrorException("""
                                         Error parsing field $f in row $currentline, column $i.
                                         Unable to parse field $f as type $(eltype(data[i]))
                                         Possible fixes include:
                                           1. set `typedetectrows` to a value >= $i
                                           2. manually specify the element-type of column $i via the `types` argument
                                           3. manually specify a parser for column $i via the `parsers` argument
                                         """))
                end
            end
        end
    end
    data = convert(Vector{Any}, data)
    for (k,v) in index2categorical
        if v
            data[k] = CategoricalVector(data[k])
        end
    end
    return data, colnames
end
