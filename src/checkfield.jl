function checkfield(field, quotes::Char, escape::Char, trimwhitespace::Bool)
    isquoted = false
    inquotes = false
    escaped = false
    toskip = falses(length(field))
    anyskip = false
    for i in eachindex(field)
        c = field[i]
        if escaped
            escaped = false
        elseif !inquotes
            if trimwhitespace && ismatch(r"\s", string(c))
                anyskip = true
                toskip[i] = true
            elseif c == quotes
                inquotes = true
                isquoted = true
                anyskip = true
                toskip[i] = true
            elseif c == escape
                escaped = true
                anyskip = true
                toskip[i] = true
            else
               continue
            end
        else    # inquotes
            if c == quotes
                if quotes != escape || count(c -> c == quotes, field[i:end]) == 1
                    inquotes = false
                    anyskip = true
                    toskip[i] = true
                else
                    escaped = true
                    anyskip = true
                    toskip[i] = true
                end
            elseif c == escape
                escaped = true
                anyskip = true
                toskip[i] = true
            else
               continue
            end
        end
    end
    if (inquotes || escaped)
        return field, isquoted, true
    else
        if anyskip
            f = field[Int[chr2ind(field, i) for i in find(!, toskip)]]
            field = SubString(f, start(f), endof(f))
        end
        return field, isquoted, false
    end
end

function checkfield(field, quotes::Char, escape::Null, trimwhitespace::Bool)
    isquoted = false
    badbreak = false
    quoteindices = find(c -> c == quotes, field)
    if length(quoteindices) == 0
        if trimwhitespace
            field = strip(field)
        end
    elseif length(quoteindices) == 2
        field = SubString(field, nextind(field, last(quoteindices[1])), prevind(field, quoteindices[2]))
        if trimwhitespace
            field = strip(field)
        end
        isquoted = true
    else
        badbreak = true
    end
    return field, isquoted, badbreak
end

function checkfield(field, quotes::Null, escape::Char, trimwhitespace::Bool)
    isquoted = false
    inquotes = false
    escaped = false
    toskip = falses(length(field))
    anyskip = false
    for i in eachindex(field)
        c = field[i]
        if escaped
            escaped = false
        elseif c == escape
            escaped = true
            anyskip = true
            toskip[i] = true
        else
            continue
        end
    end
    if (inquotes || escaped)
        return field, false, true
    end
    if anyskip
        f = field[Int[chr2ind(field, i) for i in find(!, toskip)]]
        field = SubString(f, start(f), endof(f))
    end
    if trimwhitespace
        return strip(field), false, false
    else
        return field, false, false
    end
end
