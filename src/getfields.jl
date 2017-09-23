function getfields(fields, delim, quotes, escape, trimwhitespace)
    isquoted = falses(length(fields))
    for (fi, field) in enumerate(fields)
        inquotes, escaped, toskip, quoted = checkfield(field, quotes, escape, trimwhitespace)
        if inquotes || escaped
            if fi < length(fields)
                fields[fi] = string(fields[fi], delim, fields[fi+1])
                deleteat!(fields, fi+1)
                return getfields(fields, delim, quotes, escape, trimwhitespace)
            else
                return fields, isquoted, true
            end
        end
        if !isempty(toskip)
            fields[fi] = field[[i for i in eachindex(field) if !in(i, toskip)]]
        end
        isquoted[fi] = quoted
    end
    return fields, isquoted, false
end
