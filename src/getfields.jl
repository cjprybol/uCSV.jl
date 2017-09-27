function getfields(fields, delim, quotes, escape, trimwhitespace)
    isquoted = falses(length(fields))
    for (fi, field) in enumerate(fields)
        _field, inquotes, escaped, quoted = checkfield(field, quotes, escape, trimwhitespace)
        if inquotes || escaped
            if fi < length(fields)
                fields[fi] = string(fields[fi], delim, fields[fi+1])
                deleteat!(fields, fi+1)
                return getfields(fields, delim, quotes, escape, trimwhitespace)
            else
                return fields, isquoted, true
            end
        end
        if _field != field
            fields[fi] = _field
        end
        isquoted[fi] = quoted
    end
    return fields, isquoted, false
end
