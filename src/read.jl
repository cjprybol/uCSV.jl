function read(fullpath::Union{String,IO};
              delim::Union{Char,String}=',',
              quotes::Union{Char,Null}=null,
              escape::Union{Char,Null}=null,
              comment::Union{Char,String,Null}=null,
              encodings::Dict{String,Any}=Dict{String, Any}(),
              header::Union{Integer,Vector{String}}=0,
              skiprows::AbstractVector{Int}=Vector{Int}(),
              types::Union{Type,COLMAP{Type},Vector{Type}}=Dict{Int,Type}(),
              isnullable::Union{Bool,COLMAP{Bool},Vector{Bool}}=Dict{Int,Bool}(),
              iscategorical::Union{Bool, COLMAP{Bool}, Vector{Bool}}=Dict{Int,Bool}(),
              parsers::Union{Function, COLMAP{Function}, Vector{Function}}=Dict{Int,Function}(),
              typedetectrows::Int=1,
              skipmalformed::Bool=false,
              trimwhitespace::Bool=false)

        source = isa(fullpath, IO) ? fullpath : open(fullpath)
        reserved = filter(x -> !isnull(x), [delim, quotes, escape, comment])
        if !isnull(quotes) && quotes == escape
            @assert length(unique(string.(reserved))) == length(reserved) - 1
        else
            @assert length(unique(string.(reserved))) == length(reserved)
        end
        colnames, data = parsesource(source, delim, quotes, escape, comment, encodings, header, skiprows, types, isnullable, iscategorical, parsers, typedetectrows, skipmalformed, trimwhitespace)
        return colnames, data
end
