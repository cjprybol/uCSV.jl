function read(fullpath::Union{String,IO};
              delim::Union{Char,String}=',',
              quotes::Union{Char,Null}=null,
              escape::Union{Char,Null}=null,
              comment::Union{Char,String,Null}=null,
              encodings::Dict{String,Any}=Dict{String, Any}(),
              header::Union{Integer,Vector{String}}=0,
              skiprows::AbstractVector{Int}=Vector{Int}(),
              types::Union{T1,COLMAP{T1},Vector{T1}} where {T1<:Type}=Dict{Int,DataType}(),
              isnullable::Union{Bool,COLMAP{Bool},Vector{Bool}}=Dict{Int,Bool}(),
              iscategorical::Union{Bool, COLMAP{Bool}, Vector{Bool}}=Dict{Int,Bool}(),
              colparsers::Union{F1, COLMAP{F1}, Vector{F1}} where F1=Dict{Int,Function}(),
              typeparsers::Dict{T2, F2} where {T2<:Type, F2}=Dict{DataType, Function}(),
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
        if typedetectrows > 100
            warn("""
                 Large values for `typedetectrows` will reduce performance. Consider using a lower value and specifying column-types via the `types` and `isnullable` arguments instead.
                 """)
        end
        data, colnames = parsesource(source, delim, quotes, escape, comment, encodings,
                                     header, skiprows, types, isnullable, iscategorical,
                                     colparsers, typeparsers, typedetectrows, skipmalformed,
                                     trimwhitespace)
        return data, colnames
end
