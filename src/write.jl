function write(fullpath::String;
               delim::Union{Char, String}=',',
               quotes::Union{Char, Null}=null,
               escapechar::Char='\\',
               encodings::Dict{Any, String}=Dict{Any, String}(),
               header::Bool=true,
               append::Bool=false,
               quotefields::Bool=false)
    @show "make me write something"
end
