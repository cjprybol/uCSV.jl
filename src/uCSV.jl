__precompile__(true)
module CSV

using DataFrames, Nulls

COLMAP{T} = Union{Dict{String, T}, Dict{Int, T}}

include("read.jl")
include("write.jl")
include("parsesource.jl")
include("getfields.jl")
include("checkfield.jl")
include("helperfunctions.jl")

end # module
