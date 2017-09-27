function checkfield(field, quotes::Char, escape::Char, trimwhitespace::Bool)
    isquoted = false
    inquotes = false
    escaped = false
    toskip = Vector{Int}(0)
    for i in eachindex(field)
        c = field[i]
        if escaped
            escaped = false
        elseif !inquotes
            if trimwhitespace && ismatch(r"\s", string(c))
                push!(toskip, i)
            elseif c == quotes
                inquotes = true
                isquoted = true
                push!(toskip, i)
            elseif c == escape
                escaped = true
                push!(toskip, i)
            else
               continue
            end
        else    # inquotes
            if c == quotes
                if quotes != escape || length(find(c -> c == quotes, field[i:end])) == 1
                    inquotes = false
                    push!(toskip, i)
                else
                    escaped = true
                    push!(toskip, i)
                end
            elseif c == escape
                escaped = true
                push!(toskip, i)
            else
               continue
            end
        end
    end
    if !isempty(toskip)
        field[[i for i in eachindex(field) if !in(i, toskip)]], inquotes, escaped, isquoted
    else
        return field, inquotes, escaped, isquoted
    end
end

function checkfield(field, quotes::Char, escape::Null, trimwhitespace::Bool)
    isquoted = false
    inquotes = false
    escaped = false
    toskip = Vector{Int}(0)
    for i in eachindex(field)
        c = field[i]
        if !inquotes
            if trimwhitespace && ismatch(r"\s", string(c))
                push!(toskip, i)
            elseif c == quotes
                inquotes = true
                isquoted = true
                push!(toskip, i)
            else
               continue
            end
        else    # inquotes
            if c == quotes
                inquotes = false
                push!(toskip, i)
            else
               continue
            end
        end
    end
    if !isempty(toskip)
        return field[[i for i in eachindex(field) if !in(i, toskip)]], inquotes, escaped, isquoted
    else
        return field, inquotes, escaped, isquoted
    end
end

function checkfield(field, quotes::Null, escape::Char, trimwhitespace::Bool)
    isquoted = false
    inquotes = false
    escaped = false
    toskip = Vector{Int}(0)
    for i in eachindex(field)
        c = field[i]
        if escaped
            escaped = false
        elseif c == escape
            escaped = true
            push!(toskip, i)
        else
            continue
        end
    end
    if !isempty(toskip)
        if trimwhitespace
            return strip(field[[i for i in eachindex(field) if !in(i, toskip)]]), inquotes, escaped, isquoted
        else
            field[[i for i in eachindex(field) if !in(i, toskip)]], inquotes, escaped, isquoted
        end
    else
        if trimwhitespace
            return strip(field), inquotes, escaped, isquoted
        else
            return field, inquotes, escaped, isquoted
        end
    end
end

function checkfield(field, quotes::Null, escape::Null, trimwhitespace::Bool)
    isquoted = false
    inquotes = false
    escaped = false
    toskip = Vector{Int}(0)
    if trimwhitespace
        return strip(field), inquotes, escaped, isquoted
    else
        return field, inquotes, escaped, isquoted
    end
end
