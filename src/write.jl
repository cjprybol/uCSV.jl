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
